import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    // تهيئة إعدادات الإشعارات
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelGroupKey: 'high_importance_channel',
          channelName: 'Basic Notification',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF600097),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        ),
      ],
      debug: true,
    );

    // طلب إذن الإشعارات إذا لم يكن ممنوحاً
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    // تعيين المستمعين للإشعارات
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
    );
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    /*final payload = receivedAction.payload ?? {};
    if(payload["navigate"] == true)
    {

    }*/
  }

  // تعديل هنا لإرسال إشعار مجدول يومياً
  static Future<void> showDailyNotificationAt1PM() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1, // يمكن استبداله بـ ID فريد لكل إشعار
        channelKey: 'high_importance_channel',
        title: 'Habit Tracking',
        body: 'Let\'s Achieve Your Habits',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 13, // 1 ظهرًا (بتوقيت 24 ساعة)
        minute: 0,
        second: 0,
        millisecond: 0,
        repeats: true, // تكرار يومي
      ),
    );
  }
}
