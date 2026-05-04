import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/workout.dart';
import '../models/badge_model.dart';
import '../services/notification_service.dart';

class LogWorkoutScreen extends StatefulWidget {
  const LogWorkoutScreen({super.key});

  @override
  State<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends State<LogWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  Discipline _selectedDiscipline = Discipline.run;
  bool _isSaving = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _distanceController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateDistance(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter a distance';
    final d = double.tryParse(value);
    if (d == null) return 'Enter a valid number';
    if (d <= 0) return 'Distance must be greater than 0';
    if (_selectedDiscipline == Discipline.swim && d > 50000) {
      return 'Max 50,000 m';
    }
    if (_selectedDiscipline != Discipline.swim && d > 500) return 'Max 500 km';
    return null;
  }

  String? _validateDuration(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter duration';
    final d = int.tryParse(value);
    if (d == null) return 'Enter a whole number';
    if (d <= 0) return 'Duration must be greater than 0';
    if (d > 1440) return 'Max 1440 minutes (24 hours)';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final workout = WorkoutEntry(
      id: const Uuid().v4(),
      discipline: _selectedDiscipline,
      distance: double.parse(_distanceController.text.trim()),
      durationMinutes: int.parse(_durationController.text.trim()),
      notes: _notesController.text.trim(),
      date: DateTime.now(),
    );

    final workoutProvider = context.read<WorkoutProvider>();
    final badgeProvider = context.read<BadgeProvider>();

    await workoutProvider.addWorkout(workout);
    await badgeProvider.addXpFromWorkout(workout);
    await badgeProvider.evaluate(workoutProvider.workouts);

    if (!mounted) return;

    // Fire workout-logged notification
    await NotificationService.instance.showWorkoutLoggedNotification(
      _selectedDiscipline.label,
    );

    // Show badge dialog + notification if a new badge was earned
    if (badgeProvider.newlyEarned != null) {
      final AppBadge earned = badgeProvider.newlyEarned!;
      badgeProvider.clearNewlyEarned();

      // Push notification for badge
      await NotificationService.instance.showBadgeEarnedNotification(
        earned.title,
      );

      _showBadgeDialog(earned);
    }

    if (badgeProvider.newlyLevelUp != null) {
      final level = badgeProvider.newlyLevelUp!;
      badgeProvider.clearNewlyLevelUp();
      await _showLevelUpDialog(level);
    }

    setState(() {
      _isSaving = false;
      _showSuccess = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _showSuccess = false;
        _distanceController.clear();
        _durationController.clear();
        _notesController.clear();
      });
    }
  }

  void _showBadgeDialog(AppBadge badge) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Lottie.asset(
                'assets/animations/Confetti.json',
                repeat: false,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: badge.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: badge.color.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(badge.icon, color: badge.iconColor, size: 44),
            ),
            const SizedBox(height: 16),
            const Text(
              'Badge Earned!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: badge.color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Awesome!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLevelUpDialog(int level) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: Lottie.asset(
                'assets/animations/level_up.json',
                repeat: false,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Lottie.asset(
                    'assets/animations/Confetti.json',
                    repeat: false,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Level Up!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You reached Level $level.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Keep Going',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Log Workout',
          style: TextStyle(
            color: Color(0xFF023E8A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _showSuccess ? _SuccessView() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Discipline selector
            const Text(
              'Discipline',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: Discipline.values.map((d) {
                final isSelected = _selectedDiscipline == d;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDiscipline = d),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        right: d != Discipline.run ? 10 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0077B6)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0077B6)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            d.icon,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF023E8A),
                            size: 26,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            d.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF023E8A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Distance field
            _label('Distance (${_selectedDiscipline.distanceUnit})'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _distanceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: _validateDistance,
              decoration: _inputDeco(
                hint: _selectedDiscipline == Discipline.swim
                    ? 'e.g. 750'
                    : 'e.g. 5.0',
                icon: Icons.straighten,
              ),
            ),

            const SizedBox(height: 16),

            // Duration field
            _label('Duration (minutes)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateDuration,
              decoration: _inputDeco(hint: 'e.g. 45', icon: Icons.timer),
            ),

            const SizedBox(height: 16),

            // Notes field
            _label('Notes (optional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              maxLength: 200,
              decoration: _inputDeco(
                hint: 'How did it feel? Any comments...',
                icon: Icons.notes,
              ),
            ),

            const SizedBox(height: 28),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text(
                        'Save Workout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color(0xFF023E8A),
    ),
  );

  InputDecoration _inputDeco({required String hint, required IconData icon}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: const Color(0xFF0077B6)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0077B6), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      );
}

//  Success view shown after saving
class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF0077B6).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 60,
              color: Color(0xFF0077B6),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Workout Saved!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF023E8A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep it up — every session counts.',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
