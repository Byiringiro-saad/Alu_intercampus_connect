import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_decorations.dart';
import '../../utils/app_routes.dart';
import '../../widgets/app_canvas.dart';
import '../../widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      step: '01',
      title: 'Find what matters\non your campus',
      description:
          'Workshops, hackathons, internships, and leadership programs — '
          'curated for Rwanda and Mauritius campuses.',
      icon: Icons.explore_outlined,
    ),
    _OnboardingPage(
      step: '02',
      title: 'Belong to\ncommunity hubs',
      description:
          'Join entrepreneurship, AI, climate, and leadership circles. '
          'Real peers, real projects, real impact.',
      icon: Icons.hub_outlined,
    ),
    _OnboardingPage(
      step: '03',
      title: 'Grow your\nleadership story',
      description:
          'Every RSVP, hub join, and conversation builds your campus '
          'impact score — visible to you and your community.',
      icon: Icons.auto_graph_rounded,
    ),
  ];

  void _complete() {
    context.read<AuthProvider>().completeOnboarding();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.brand(isDark);

    return Scaffold(
      body: AppCanvas(
        showAccent: true,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(onPressed: _complete, child: const Text('Skip')),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => _pages[i],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  children: List.generate(
                    _pages.length,
                    (i) => Expanded(
                      child: Container(
                        height: 3,
                        margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                        decoration: BoxDecoration(
                          color: i <= _currentPage
                              ? accent
                              : AppDecorations.borderColor(context),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: PrimaryButton(
                  label: _currentPage < _pages.length - 1
                      ? 'Continue'
                      : 'Enter ALU Connect',
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                      );
                    } else {
                      _complete();
                    }
                  },
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String step;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.brand(isDark);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 28),
          Icon(icon, size: 40, color: accent.withValues(alpha: 0.85)),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.65),
                  height: 1.55,
                ),
          ),
        ],
      ),
    );
  }
}
