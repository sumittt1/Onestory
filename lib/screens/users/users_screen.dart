import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../widgets/common/widgets.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = MockDataProvider.getUsers();

    return AppShell(
      selectedIndex: 5,
      title: 'Users',
      subtitle: 'Manage authorized users',
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search users',
                        hintText: 'Enter name or email',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                ...users.map((user) => _buildUserCard(context, user)),
                const SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            right: AppTheme.spacingMedium,
            bottom: AppTheme.spacingMedium,
            child: FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add user dialog (mock)')),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Add User'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserModel user) {
    final searchLower = _searchController.text.toLowerCase();
    final matchesSearch = user.name.toLowerCase().contains(searchLower) ||
        user.email.toLowerCase().contains(searchLower);

    if (!matchesSearch) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Text(
            user.name.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusBadge(role: user.role),
            const SizedBox(width: AppTheme.spacingSmall),
            StatusBadge(isActive: user.isActive),
            const SizedBox(width: AppTheme.spacingSmall),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit user (mock)')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: AppTheme.errorColor,
              onPressed: () {
                ConfirmationDialog.show(
                  context: context,
                  title: 'Remove User',
                  message: 'Are you sure you want to remove ${user.name}?',
                  isDestructive: true,
                ).then((confirmed) {
                  if (confirmed == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User removed (mock)')),
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
