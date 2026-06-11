import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../utils/app_colors.dart';

/// QR Attendance Check-In mock — simulates event check-in flow.
class QrCheckinScreen extends StatefulWidget {
  const QrCheckinScreen({super.key});

  @override
  State<QrCheckinScreen> createState() => _QrCheckinScreenState();
}

class _QrCheckinScreenState extends State<QrCheckinScreen> {
  bool _scanned = false;
  bool _scanning = false;

  Future<void> _simulateScan() async {
    setState(() => _scanning = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _scanning = false;
      _scanned = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance recorded! +15 leadership points'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventId = ModalRoute.of(context)?.settings.arguments as String?;
    final event = eventId != null
        ? context.watch<EventProvider>().getById(eventId)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('QR Check-In')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (event != null) ...[
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _scanned
                        ? AppColors.success
                        : Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _scanning
                    ? const Center(child: CircularProgressIndicator())
                    : Icon(
                        _scanned
                            ? Icons.check_circle
                            : Icons.qr_code_scanner,
                        size: 120,
                        color: _scanned
                            ? AppColors.success
                            : Theme.of(context).colorScheme.primary,
                      ),
              ),
              const SizedBox(height: 32),
              Text(
                _scanned
                    ? 'Check-in successful!'
                    : 'Point your camera at the event QR code',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (!_scanned)
                FilledButton.icon(
                  onPressed: _scanning ? null : _simulateScan,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Simulate Scan'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
