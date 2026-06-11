import 'package:flutter/material.dart';
import '../../widgets/empty_state.dart';

/// Mock network error screen for error handling demonstration.
class NetworkUnavailableScreen extends StatelessWidget {
  const NetworkUnavailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connection Error')),
      body: EmptyState(
        icon: Icons.wifi_off_rounded,
        title: 'Network Unavailable',
        message:
            'Unable to connect to ALU Connect servers. '
            'Please check your internet connection and try again.',
        actionLabel: 'Retry',
        onAction: () => Navigator.pop(context),
      ),
    );
  }
}
