import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

/// Notifications screen showing all reminders and alerts
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final StorageService _storageService = StorageService();
  List<NotificationModel> _notifications = [];
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notifications = _showUnreadOnly
          ? _storageService.getUnreadNotifications()
          : _storageService.getAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _storageService.getUnreadNotifications().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // Filter toggle
          IconButton(
            icon: Icon(
              _showUnreadOnly
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
            onPressed: () {
              setState(() {
                _showUnreadOnly = !_showUnreadOnly;
                _loadNotifications();
              });
            },
            tooltip: _showUnreadOnly ? 'Show all' : 'Show unread only',
          ),
          // Mark all as read
          if (unreadCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: () async {
                await _storageService.markAllNotificationsAsRead();
                _loadNotifications();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications marked as read'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              tooltip: 'Mark all as read',
            ),
        ],
      ),
      body: Column(
        children: [
          // Stats banner
          if (unreadCount > 0)
            Container(
              padding: AppSpacing.paddingMD,
              color: AppColors.primary.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active,
                      color: AppColors.primary),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'You have $unreadCount unread notification${unreadCount > 1 ? 's' : ''}',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Notifications list
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: () async {
                _loadNotifications();
              },
              child: ListView.builder(
                padding: AppSpacing.paddingMD,
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return _buildNotificationItem(notification);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build notification item
  Widget _buildNotificationItem(NotificationModel notification) {
    final isRead = notification.isRead;
    final isPast = notification.scheduledTime.isBefore(DateTime.now());

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppRadius.radiusLG,
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        await _storageService.deleteNotification(notification.id);
        setState(() {
          _notifications.remove(notification);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification deleted'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        elevation: isRead ? 0 : 2,
        color: isRead
            ? Theme.of(context).cardColor.withOpacity(0.7)
            : Theme.of(context).cardColor,
        child: InkWell(
          onTap: () async {
            if (!isRead) {
              await _storageService.markNotificationAsRead(notification.id);
              _loadNotifications();
            }
          },
          borderRadius: AppRadius.radiusLG,
          child: Padding(
            padding: AppSpacing.paddingMD,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: AppIconSize.md,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: AppTextStyles.subtitle1.copyWith(
                                fontWeight:
                                isRead ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        notification.body,
                        style: AppTextStyles.body2.copyWith(
                          color: isRead
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(
                            isPast ? Icons.history : Icons.schedule,
                            size: AppIconSize.sm,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            _formatNotificationTime(notification.scheduledTime),
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          _buildTypeChip(notification.type),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build type chip
  Widget _buildTypeChip(NotificationType type) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _getNotificationColor(type).withOpacity(0.1),
        borderRadius: AppRadius.radiusSM,
        border: Border.all(color: _getNotificationColor(type)),
      ),
      child: Text(
        type.displayName,
        style: AppTextStyles.caption.copyWith(
          color: _getNotificationColor(type),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Get notification color based on type
  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return AppColors.info;
      case NotificationType.alert:
        return AppColors.error;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.info:
        return AppColors.info;
    }
  }

  /// Get notification icon based on type
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.alert:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.info:
        return Icons.info;
    }
  }

  /// Format notification time
  String _formatNotificationTime(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);

    if (difference.isNegative) {
      // Past notification
      final absDifference = difference.abs();
      if (absDifference.inMinutes < 60) {
        return '${absDifference.inMinutes}m ago';
      } else if (absDifference.inHours < 24) {
        return '${absDifference.inHours}h ago';
      } else if (absDifference.inDays < 7) {
        return '${absDifference.inDays}d ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(time);
      }
    } else {
      // Future notification
      if (difference.inMinutes < 60) {
        return 'in ${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return 'in ${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return 'in ${difference.inDays}d';
      } else {
        return DateFormat('MMM dd, yyyy - hh:mm a').format(time);
      }
    }
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _showUnreadOnly
                  ? Icons.notifications_off_outlined
                  : Icons.notifications_none,
              size: AppIconSize.xxl * 2,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              _showUnreadOnly
                  ? 'No unread notifications'
                  : 'No notifications yet',
              textAlign: TextAlign.center,
              style: AppTextStyles.headline3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _showUnreadOnly
                  ? 'You\'re all caught up!'
                  : 'Notifications for your trips will appear here',
              textAlign: TextAlign.center,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}