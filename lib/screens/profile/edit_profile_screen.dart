import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../services/profile_image_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/profile_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _programController;
  late String _selectedCampus;
  late String _avatarPath;
  late Set<String> _selectedInterests;
  bool _isPickingPhoto = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user!;
    _nameController = TextEditingController(text: user.name);
    _programController = TextEditingController(text: user.program);
    _selectedCampus = user.campus;
    _avatarPath = user.avatarUrl;
    _selectedInterests = Set<String>.from(user.interests);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _programController.dispose();
    super.dispose();
  }

  Future<void> _uploadPhoto() async {
    setState(() => _isPickingPhoto = true);
    try {
      final path = await ProfileImageService.pickAndSaveFromGallery();
      if (!mounted) return;
      if (path != null) {
        setState(() => _avatarPath = path);
      }
    } catch (e) {
      if (!mounted) return;
      final needsRestart = e.toString().contains('MissingPluginException');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            needsRestart
                ? 'Photo upload needs a full app restart. Stop the app, run '
                  '"flutter run" again, then try uploading.'
                : 'Could not upload photo: $e',
          ),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: needsRestart ? 6 : 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isPickingPhoto = false);
    }
  }

  void _removePhoto() {
    setState(() => _avatarPath = '');
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final profile = context.read<ProfileProvider>();

    auth.updateCurrentUserProfile(
      name: _nameController.text.trim(),
      program: _programController.text.trim(),
      campus: _selectedCampus,
      avatarUrl: _avatarPath,
      interests: _selectedInterests.toList(),
    );

    profile.updateProfile(
      name: _nameController.text.trim(),
      program: _programController.text.trim(),
      campus: _selectedCampus,
      avatarUrl: _avatarPath,
      interests: _selectedInterests.toList(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = ProfileImageService.hasAvatar(_avatarPath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    ProfileAvatar(
                      avatarUrl: _avatarPath,
                      radius: 52,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _isPickingPhoto ? null : _uploadPhoto,
                      icon: _isPickingPhoto
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload_rounded),
                      label: Text(
                        hasPhoto ? 'Change photo' : 'Upload photo',
                      ),
                    ),
                    if (hasPhoto) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _removePhoto,
                        child: const Text('Remove photo'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => Validators.required(v, fieldName: 'Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: context.read<AuthProvider>().user?.email,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  helperText: 'Email cannot be changed',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _programController,
                decoration: const InputDecoration(
                  labelText: 'Program',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                validator: (v) => Validators.required(v, fieldName: 'Program'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCampus,
                decoration: const InputDecoration(
                  labelText: 'Campus',
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
                items: AppConstants.campuses
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCampus = v!),
              ),
              const SizedBox(height: 24),
              Text(
                'Interests',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.interestOptions.map((interest) {
                  final selected = _selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: selected,
                    onSelected: (v) {
                      setState(() {
                        if (v) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
