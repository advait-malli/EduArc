import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/account_service.dart';
import '../../screens/auth/login_page.dart';
import '../../screens/notifications/notifications_page.dart';
import '../../screens/settings/settings_page.dart';
import 'account_switch_dialog.dart';

class PrimaryPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? inlineAction;
  final bool showDefaultActions;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onAccountPressed;

  const PrimaryPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.inlineAction,
    this.showDefaultActions = true,
    this.onSettingsPressed,
    this.onAccountPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        16,
        isMobile ? 16 : 24,
        12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
                if (inlineAction != null) inlineAction!,
              ],
            ),
          ),
          if (showDefaultActions)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsPage(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: onSettingsPressed ??
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                      },
                ),
                FutureBuilder<Account?>(
                  future: AccountService.getCurrentAccount(),
                  builder: (context, snapshot) {
                    final account = snapshot.data;
                    return PopupMenuButton<String>(
                      icon: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: account != null
                            ? Text(
                                account.initials,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              )
                            : const Icon(Icons.person, size: 20),
                      ),
                      onSelected: (value) async {
                        if (value == 'switch_account') {
                          final switched = await showAccountSwitchDialog(context);
                          if (switched == true && context.mounted) {
                            // Account switched, reload may be needed
                          }
                        } else if (value == 'logout') {
                          await AuthService.logout();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                            (route) => false,
                          );
                        } else if (onAccountPressed != null) {
                          onAccountPressed!();
                        }
                      },
                      itemBuilder: (context) => [
                        if (account != null) ...[
                          PopupMenuItem(
                            enabled: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  account.email,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                        ],
                        const PopupMenuItem(
                          value: 'switch_account',
                          child: Row(
                            children: [
                              Icon(Icons.swap_horiz, size: 20),
                              SizedBox(width: 8),
                              Text('Switch Account'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Logout', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
