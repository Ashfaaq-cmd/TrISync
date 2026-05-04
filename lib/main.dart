import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'app.dart';
import 'services/notification_service.dart';

void main() async {
  //Required before using any plugins
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise timezone data
  tz_data.initializeTimeZones();
  // Initialise notifications
  await NotificationService.instance.init();
  runApp(const TriSync());
}
