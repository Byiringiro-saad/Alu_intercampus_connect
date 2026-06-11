import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/profile_avatar.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameController = TextEditingController();
  final Set<String> _selectedMemberIds = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createGroup() {
    final auth = context.read<AuthProvider>();
    final chat = context.read<ChatProvider>();
    final currentUser = auth.user;

    if (currentUser == null) return;

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a group name'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedMemberIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select at least one member'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final members = auth.allRegisteredUsers
        .where((user) => _selectedMemberIds.contains(user.id))
        .toList();

    final conversationId = chat.createGroup(
      name: _nameController.text,
      creator: currentUser,
      selectedMembers: members,
      isRegistered: auth.isRegisteredUser,
    );

    if (conversationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not create group'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.chatDetail,
      arguments: conversationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final currentUser = auth.user;
    final others = currentUser == null
        ? <UserProfile>[]
        : auth.otherRegisteredUsers(currentUser.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: others.isEmpty
          ? const EmptyState(
              icon: Icons.groups_outlined,
              title: 'No members available',
              message:
                  'Other registered students are required to create a group chat.',
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Group name',
                      prefixIcon: Icon(Icons.groups_outlined),
                      hintText: 'e.g. Hackathon Team, Study Group',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add members',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: others.length,
                    itemBuilder: (_, index) {
                      final user = others[index];
                      final selected = _selectedMemberIds.contains(user.id);

                      return CheckboxListTile(
                        value: selected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedMemberIds.add(user.id);
                            } else {
                              _selectedMemberIds.remove(user.id);
                            }
                          });
                        },
                        secondary: ProfileAvatar(avatarUrl: user.avatarUrl),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _createGroup,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Create Group'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
