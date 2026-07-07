import 'package:flutter/material.dart';
import '../../core/services/account_service.dart';
import '../../screens/auth/login_page.dart';

/// Dialog for switching between multiple accounts
class AccountSwitchDialog extends StatefulWidget {
  const AccountSwitchDialog({super.key});

  @override
  State<AccountSwitchDialog> createState() => _AccountSwitchDialogState();
}

class _AccountSwitchDialogState extends State<AccountSwitchDialog> {
  List<Account> accounts = [];
  String? currentAccountId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final accs = await AccountService.getAllAccounts();
    final currentId = await AccountService.getCurrentAccountId();
    setState(() {
      accounts = accs;
      currentAccountId = currentId;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return AlertDialog(
      title: const Text('Switch Account'),
      content: SizedBox(
        width: double.maxFinite,
        child: accounts.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No saved accounts',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  final isCurrent = account.id == currentAccountId;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCurrent
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: Text(
                        account.initials,
                        style: TextStyle(
                          color: isCurrent
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      account.name,
                      style: TextStyle(
                        fontWeight: isCurrent ? FontWeight.bold : null,
                      ),
                    ),
                    subtitle: Text('${account.email} • ${account.role}'),
                    trailing: isCurrent
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () async {
                      if (!isCurrent) {
                        await AccountService.switchAccount(account.id);
                        if (context.mounted) {
                          Navigator.of(context).pop(true);
                        }
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _showAddAccountDialog(context);
          },
          child: const Text('Add Account'),
        ),
        if (accounts.length > 1)
          TextButton(
            onPressed: () async {
              final confirm = await _showRemoveAccountConfirm(context);
              if (confirm == true && context.mounted) {
                await _removeCurrentAccount();
                if (context.mounted) {
                  Navigator.of(context).pop(true);
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
      ],
    );
  }

  Future<bool?> _showRemoveAccountConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Account'),
        content: const Text(
          'Are you sure you want to remove this account from the device? You can always add it again later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeCurrentAccount() async {
    if (currentAccountId != null) {
      await AccountService.removeAccount(currentAccountId!);
    }
  }

  void _showAddAccountDialog(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }
}

/// Shows the account switch dialog
Future<bool?> showAccountSwitchDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const AccountSwitchDialog(),
  );
}
