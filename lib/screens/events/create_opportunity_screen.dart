import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../models/opportunity_category.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../services/local_image_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_decorations.dart';
import '../../utils/app_routes.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/cover_image_picker.dart';
import '../../widgets/empty_state.dart';

class CreateOpportunityScreen extends StatefulWidget {
  const CreateOpportunityScreen({super.key});

  @override
  State<CreateOpportunityScreen> createState() =>
      _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxParticipantsController = TextEditingController(text: '50');
  final _timeController = TextEditingController(text: '10:00 AM');

  OpportunityCategory _category = OpportunityCategory.events;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  String _selectedCampus = AppConstants.campuses.first;
  String _coverImagePath = '';

  @override
  void initState() {
    super.initState();
    _locationController.text = _selectedCampus;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxParticipantsController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _preview(UserProfile user) {
    if (!_formKey.currentState!.validate()) return;

    if (!LocalImageService.hasImage(_coverImagePath)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a cover image before continuing'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final draft = EventModel(
      id: 'draft',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      organizer: '${user.name} · ${user.roleLabel}',
      organizerId: user.id,
      date: _selectedDate,
      time: _timeController.text.trim(),
      location: _locationController.text.trim(),
      category: _category,
      imageUrl: _coverImagePath,
      maxParticipants: int.parse(_maxParticipantsController.text),
    );

    Navigator.pushNamed(
      context,
      AppRoutes.createPreview,
      arguments: draft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    if (user == null || !user.canPostOpportunities) {
      return Scaffold(
        appBar: AppBar(title: const Text('Create Opportunity')),
        body: EmptyState(
          icon: Icons.lock_outline,
          title: 'Not authorized to post',
          message: user == null
              ? 'Log in with an authorized account to publish opportunities.'
              : 'Students can browse and RSVP. To post events, hackathons, '
                  'workshops, internships, and announcements, sign up as a '
                  'club leader, event organizer, entrepreneur, community '
                  'leader, or academic team member.',
          actionLabel: user == null ? 'Go to Login' : null,
          onAction: user == null
              ? () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (_) => false,
                  )
              : null,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Opportunity')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.brandMuted(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                  borderRadius: BorderRadius.circular(AppDecorations.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posting as ${user.roleLabel}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.role.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CoverImagePicker(
                imagePath: _coverImagePath,
                onChanged: (path) => setState(() => _coverImagePath = path),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => Validators.required(v, fieldName: 'Title'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (v) =>
                    Validators.required(v, fieldName: 'Description'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<OpportunityCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Activity type',
                ),
                items: OpportunityCategory.publishable
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _category.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Theme.of(context).cardColor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (v) => Validators.required(v, fieldName: 'Time'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCampus,
                decoration: const InputDecoration(labelText: 'Campus'),
                items: AppConstants.campuses
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _selectedCampus = v!;
                    _locationController.text = v;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Venue details',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (v) =>
                    Validators.required(v, fieldName: 'Location'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxParticipantsController,
                decoration: const InputDecoration(
                  labelText: 'Maximum participants',
                ),
                keyboardType: TextInputType.number,
                validator: Validators.maxParticipants,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => _preview(user),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Preview & Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
