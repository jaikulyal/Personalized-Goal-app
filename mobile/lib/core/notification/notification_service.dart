import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'goal_action_reminders';
  static const String _channelName = 'Goal & Action Reminders';
  static const String _channelDescription =
      'Reminders for goals and scheduled actions.';

  bool _initialized = false;

  // ------------------------------------------------------------
  // INITIALIZE
  // ------------------------------------------------------------

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    // Initialize timezone database.
    tz.initializeTimeZones();

    // Use the device's local timezone.
    //
    // The timezone package defaults to UTC unless a local location
    // is explicitly selected. For the current Android-first version
    // of the app, we use Asia/Kolkata.
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannel();

    _initialized = true;
  }

  // ------------------------------------------------------------
  // NOTIFICATION CHANNEL
  // ------------------------------------------------------------

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(channel);
  }

  // ------------------------------------------------------------
  // PERMISSIONS
  // ------------------------------------------------------------

  Future<void> requestPermissions() async {
    await initialize();

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) {
      return;
    }

    // Android 13+
    await androidPlugin.requestNotificationsPermission();

    // Exact scheduled notifications.
    await androidPlugin.requestExactAlarmsPermission();
  }

  // ------------------------------------------------------------
  // SCHEDULE ACTION REMINDER
  // ------------------------------------------------------------

  Future<void> scheduleActionReminder({
    required String actionId,
    required String actionTitle,
    required DateTime scheduledDate,
  }) async {
    await initialize();

    // Do not schedule notifications for dates already in the past.
    if (!scheduledDate.isAfter(DateTime.now())) {
      return;
    }

    final notificationId = _notificationId(actionId);

    final scheduledTime = tz.TZDateTime.from(scheduledDate, tz.local);

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      id: notificationId,
      title: 'Action reminder',
      body: actionTitle,
      scheduledDate: scheduledTime,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: actionId,
    );
  }

  // ------------------------------------------------------------
  // CANCEL ACTION REMINDER
  // ------------------------------------------------------------

  Future<void> cancelActionReminder(String actionId) async {
    await initialize();

    await _plugin.cancel(id: _notificationId(actionId));
  }

  // ------------------------------------------------------------
  // CANCEL ALL
  // ------------------------------------------------------------

  Future<void> cancelAll() async {
    await initialize();

    await _plugin.cancelAll();
  }

  // ------------------------------------------------------------
  // NOTIFICATION ID
  // ------------------------------------------------------------

  int _notificationId(String id) {
    return id.hashCode & 0x7fffffff;
  }

  // ------------------------------------------------------------
  // NOTIFICATION TAP
  // ------------------------------------------------------------

  void _onNotificationTapped(NotificationResponse response) {
    final actionId = response.payload;

    if (actionId == null || actionId.isEmpty) {
      return;
    }

    // We will connect this to GoalDetailScreen later.
    //
    // For now, the notification simply delivers the action ID.
    //
    // Future flow:
    //
    // Notification tapped
    //       ↓
    // Find action
    //       ↓
    // Find goal
    //       ↓
    // Open GoalDetailScreen
  }
}
