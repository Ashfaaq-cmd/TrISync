import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _dailyQuoteTextKey = 'dailyQuoteText';
  static const _dailyQuoteDateKey = 'dailyQuoteDate';

  bool _initialized = false;

  // Initialise plugin
  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onTap,
    );

    // Request Android 13+ permission
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  void _onTap(NotificationResponse response) {
    // Notification tapped — could navigate to home; handled via app logic
    debugPrint('Notification tapped: ${response.payload}');
  }

  // ── Fetch quote from ZenQuotes
  Future<String> _fetchQuote() async {
    try {
      final res = await http
          .get(Uri.parse('https://zenquotes.io/api/random'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;
        final q = data[0] as Map<String, dynamic>;
        final text = q['q'] as String;
        final author = q['a'] as String;
        return '"$text" — $author';
      }
    } catch (_) {
      // Fall through to default
    }
    // Fallback motivational messages if API is unreachable
    const fallbacks = [
      'Every metre in the pool, every km on the bike, every step on the run counts. Keep going!',
      'Triathlon is not about being better than someone else — it\'s about being better than you used to be.',
      'Pain is temporary. Finishing is forever. Train hard today!',
      'Swim strong. Ride smart. Run brave. You\'ve got this!',
      'The only bad workout is the one that didn\'t happen.',
    ];
    fallbacks.shuffle();
    return fallbacks.first;
  }

  Future<String> getDailyQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final storedQuote = prefs.getString(_dailyQuoteTextKey);
    final storedDate = prefs.getString(_dailyQuoteDateKey);

    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';

    if (storedQuote != null && storedDate == todayKey) {
      return storedQuote;
    }

    final quote = await _fetchQuote();
    await prefs.setString(_dailyQuoteTextKey, quote);
    await prefs.setString(_dailyQuoteDateKey, todayKey);
    return quote;
  }

  // ── Schedule daily notification at a given time
  Future<void> scheduleDailyReminder({int hour = 7, int minute = 0}) async {
    await init();

    final quote = await _fetchQuote();

    // Cancel any existing daily reminder before rescheduling
    await _plugin.cancel(1);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    // If that time has already passed today, schedule for tomorrow
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'trisync_daily',
      'Daily Training Reminder',
      channelDescription:
          'Motivational daily reminder for your triathlon training',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF0077B6),
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.zonedSchedule(
      1,
      '🏊 TriSync — Training Reminder',
      quote,
      scheduled,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // repeats daily
      payload: 'daily_reminder',
    );

    debugPrint(
      'Daily reminder scheduled for ${scheduled.hour}:${scheduled.minute.toString().padLeft(2, '0')}',
    );
  }

  // One-shot "workout logged" congratulation
  Future<void> showWorkoutLoggedNotification(String discipline) async {
    await init();

    const androidDetails = AndroidNotificationDetails(
      'trisync_workout',
      'Workout Logged',
      channelDescription: 'Confirmation when a workout is saved',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF0077B6),
    );
    const iosDetails = DarwinNotificationDetails();

    await _plugin.show(
      2,
      '✅ Workout Saved!',
      '$discipline session logged. Keep stacking those sessions!',
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: 'workout_logged',
    );
  }

  // ── Badge earned notification ────────────────────────────
  Future<void> showBadgeEarnedNotification(String badgeTitle) async {
    await init();

    const androidDetails = AndroidNotificationDetails(
      'trisync_badge',
      'Badge Earned',
      channelDescription: 'Notification when a new badge is unlocked',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFFFB703),
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );

    await _plugin.show(
      3,
      '🏅 Badge Unlocked!',
      'You just earned the "$badgeTitle" badge. Incredible work!',
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: 'badge_earned',
    );
  }

  // Cancel all notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
