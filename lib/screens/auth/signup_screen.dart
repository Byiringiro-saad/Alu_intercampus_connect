import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/app_canvas.dart';
import '../../widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _programController = TextEditingController();
  String _selectedCampus = AppConstants.campuses.first;
  UserRole _selectedRole = UserRole.student;
  final Set<String> _selectedInterests = {};

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _programController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.signup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      program: _programController.text.trim(),
      campus: _selectedCampus,
      role: _selectedRole,
      interests: _selectedInterests.toList(),
    );
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Sign up failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join ALU Connect'),
      ),
      body: AppCanvas(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create your account',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us who you are. You can add a profile photo anytime.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (v) => Validators.required(v, fieldName: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                    validator: Validators.password,
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
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    items: AppConstants.campuses
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCampus = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<UserRole>(
                    initialValue: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Account type',
                      prefixIcon: Icon(Icons.badge_outlined),
                      helperText:
                          'Authorized roles can publish campus opportunities',
                    ),
                    items: UserRole.values
                        .map(
                          (r) => DropdownMenuItem(value: r, child: Text(r.label)),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedRole = v!),
                  ),
                  if (_selectedRole.canPostOpportunities)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _selectedRole.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.success,
                            ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Interests',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pick at least one so we can recommend the right events for you.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.interestOptions.map((interest) {
                      final selected = _selectedInterests.contains(interest);
                      return FilterChip(
                        label: Text(interest),
                        selected: selected,
                        onSelected: (on) => setState(() {
                          if (on) {
                            _selectedInterests.add(interest);
                          } else {
                            _selectedInterests.remove(interest);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Create account',
                    isLoading: auth.isLoading,
                    onPressed: auth.isLoading ? null : _signup,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
