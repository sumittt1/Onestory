import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_navigation.dart';
import '../../app/theme.dart';
import '../../core/responsive/breakpoints.dart';
import '../../state/dashboard_provider.dart';
import 'app_header.dart';
import 'app_sidebar.dart';

class AppShell extends StatefulWidget {
  final int selectedIndex;
  final String title;
  final String? subtitle;
  final List<Widget>? headerActions;
  final Widget body;

  const AppShell({
    super.key,
    required this.selectedIndex,
    required this.title,
    this.subtitle,
    this.headerActions,
    required this.body,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<DashboardProvider>();
      if (provider.rooms.isEmpty && !provider.isLoading) {
        provider.loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isMobile(context)) {
      return _buildMobileLayout(context);
    }
    return _buildDesktopLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            selectedIndex: widget.selectedIndex,
            onItemSelected: (index) => AppNavigation.goToIndex(context, index),
          ),
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  title: widget.title,
                  subtitle: widget.subtitle,
                  actions: widget.headerActions,
                ),
                Expanded(child: widget.body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final showBottomNav =
        widget.selectedIndex < AppNavigation.mobileBottomNavCount;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.power, color: AppTheme.primaryColor, size: 32),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      'OneStory',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                    ),
                    Text(
                      'Energy Management',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              ...List.generate(AppSidebar.items.length, (index) {
                final item = AppSidebar.items[index];
                final isSelected = widget.selectedIndex == index;
                return ListTile(
                  leading: Icon(
                    isSelected ? item.selectedIcon : item.icon,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textSecondary,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onTap: () {
                    Navigator.pop(context);
                    AppNavigation.goToIndex(context, index);
                  },
                );
              }),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          AppHeader(
            title: widget.title,
            subtitle: widget.subtitle,
            actions: widget.headerActions,
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Expanded(child: widget.body),
        ],
      ),
      bottomNavigationBar: showBottomNav
          ? BottomNavigationBar(
              currentIndex: widget.selectedIndex,
              onTap: (index) => AppNavigation.goToIndex(context, index),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.meeting_room_outlined),
                  activeIcon: Icon(Icons.meeting_room),
                  label: 'Classrooms',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business_outlined),
                  activeIcon: Icon(Icons.business),
                  label: 'Buildings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bolt_outlined),
                  activeIcon: Icon(Icons.bolt),
                  label: 'Energy',
                ),
              ],
            )
          : null,
    );
  }
}
