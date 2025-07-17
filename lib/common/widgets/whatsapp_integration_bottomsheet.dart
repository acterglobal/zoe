import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/zoe_sheet_model.dart';

class WhatsAppIntegrationBottomSheet extends StatefulWidget {
  final ZoeSheetModel currentSheet;
  final Function(bool isConnected) onConnectionChanged;

  const WhatsAppIntegrationBottomSheet({
    super.key,
    required this.currentSheet,
    required this.onConnectionChanged,
  });

  @override
  State<WhatsAppIntegrationBottomSheet> createState() =>
      _WhatsAppIntegrationBottomSheetState();
}

class _WhatsAppIntegrationBottomSheetState
    extends State<WhatsAppIntegrationBottomSheet> {
  int _currentStep = 0;
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late bool _isConnected;
  bool _notifyOnTaskChanges = true;
  bool _notifyOnEventChanges = true;
  bool _notifyOnSheetUpdates = false;
  bool _dailySummary = true;

  @override
  void initState() {
    super.initState();
    _isConnected = widget.currentSheet.isWhatsAppConnected;
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppTheme.getSurface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: _buildContent(),
              ),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppTheme.getTextSecondary(context).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF25D366).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildWhatsAppIcon(24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WhatsApp Integration',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.getTextPrimary(context),
                  ),
                ),
                Text(
                  'Connect this sheet to your WhatsApp group',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isConnected) {
      return _buildConnectedView();
    }

    return _buildSetupStepper();
  }

  Widget _buildSetupStepper() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress indicator
        _buildProgressIndicator(),
        const SizedBox(height: 32),
        // Step content
        _buildStepContent(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(2, (index) {
        final isActive = index <= _currentStep;
        final isCompleted = index < _currentStep;

        return Expanded(
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF25D366)
                      : AppTheme.getSurfaceVariant(context),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        )
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : AppTheme.getTextSecondary(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              if (index < 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: index < _currentStep
                          ? const Color(0xFF25D366)
                          : AppTheme.getSurfaceVariant(context),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1(); // Bot Setup
      case 1:
        return _buildStep3(); // Notification Settings
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Step 1: Add Zoey Bot',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add our WhatsApp bot to your group to receive notifications',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.getTextSecondary(context),
          ),
        ),
        const SizedBox(height: 24),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.getSurfaceVariant(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.getBorder(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.phone_rounded,
                    size: 20,
                    color: Color(0xFF25D366),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Zoey Bot Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getTextPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.getSurface(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '+1 (555) 123-ZOEY',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.getTextPrimary(context),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Phone number copied to clipboard'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: const Text('Copy'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '1. Copy the bot number above\n2. Add it to your WhatsApp group\n3. The bot will send a confirmation message',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.getTextSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Step 2: Notification Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose what updates you want to receive in WhatsApp',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.getTextSecondary(context),
          ),
        ),
        const SizedBox(height: 24),

        _buildNotificationToggle(
          'Task Updates',
          'Get notified when tasks are added, completed, or modified',
          Icons.check_box_rounded,
          _notifyOnTaskChanges,
          (value) => setState(() => _notifyOnTaskChanges = value),
        ),

        _buildNotificationToggle(
          'Event Updates',
          'Receive notifications for new events and schedule changes',
          Icons.event_rounded,
          _notifyOnEventChanges,
          (value) => setState(() => _notifyOnEventChanges = value),
        ),

        _buildNotificationToggle(
          'Sheet Updates',
          'Get notified when sheet content is modified',
          Icons.edit_rounded,
          _notifyOnSheetUpdates,
          (value) => setState(() => _notifyOnSheetUpdates = value),
        ),

        _buildNotificationToggle(
          'Daily Summary',
          'Receive a daily summary of sheet activity',
          Icons.today_rounded,
          _dailySummary,
          (value) => setState(() => _dailySummary = value),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String description,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceVariant(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.getTextSecondary(context), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF25D366),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF25D366).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF25D366).withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF25D366),
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Successfully Connected!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getTextPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your sheet is now connected to your WhatsApp group',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.getTextSecondary(context),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Active Notifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
        ),

        const SizedBox(height: 12),

        if (_notifyOnTaskChanges) _buildActiveNotification('Task Updates'),
        if (_notifyOnEventChanges) _buildActiveNotification('Event Updates'),
        if (_notifyOnSheetUpdates) _buildActiveNotification('Sheet Updates'),
        if (_dailySummary) _buildActiveNotification('Daily Summary'),
      ],
    );
  }

  Widget _buildActiveNotification(String type) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceVariant(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_rounded, color: Color(0xFF25D366), size: 16),
          const SizedBox(width: 8),
          Text(
            type,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.getTextPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.getSurface(context),
        border: Border(
          top: BorderSide(color: AppTheme.getBorder(context), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _isConnected ? _buildConnectedActions() : _buildSetupActions(),
      ),
    );
  }

  Widget _buildConnectedActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _isConnected = false;
                _currentStep = 0;
              });

              // Notify parent about disconnection
              widget.onConnectionChanged(false);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Disconnect'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }

  Widget _buildSetupActions() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Previous'),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          flex: _currentStep > 0 ? 1 : 2,
          child: ElevatedButton(
            onPressed: _canProceed() ? _handleNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(_currentStep == 1 ? 'Connect' : 'Next'),
          ),
        ),
      ],
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return true; // Always can proceed from step 1 (bot setup is manual)
      case 1:
        return _notifyOnTaskChanges ||
            _notifyOnEventChanges ||
            _notifyOnSheetUpdates ||
            _dailySummary;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Final step - simulate connection
      setState(() {
        _isConnected = true;
      });

      // Notify parent about connection change
      widget.onConnectionChanged(true);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WhatsApp integration activated successfully!'),
          backgroundColor: Color(0xFF25D366),
        ),
      );
    }
  }

  Widget _buildWhatsAppIcon(double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle (always WhatsApp green in header)
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Color(0xFF25D366),
            shape: BoxShape.circle,
          ),
        ),
        // Phone icon in white
        Icon(Icons.phone_rounded, size: size * 0.6, color: Colors.white),
      ],
    );
  }
}
