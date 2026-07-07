import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/user.dart';

class ProfilePage extends StatefulWidget {
  final String role;

  const ProfilePage({super.key, required this.role});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  Map<String, String> _profile = {};
  bool _isLoading = true;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final repo = RepositoryProvider.of(context).userRepository;
    final user = await repo.getCurrentUser();
    final profile = await repo.getUserProfile();
    if (mounted) setState(() { _user = user; _profile = profile; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'My Profile',
              subtitle: 'View and update your profile',
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              child: const Icon(Icons.person, size: 50, color: Colors.white),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit, size: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildProfileItem(context, Icons.person_outline, 'Name', _user?.name ?? ''),
                      _buildProfileItem(context, Icons.email_outlined, 'Email', _user?.email ?? ''),
                      _buildProfileItem(context, Icons.phone_outlined, 'Phone', _profile['phone'] ?? ''),
                      _buildProfileItem(context, Icons.school_outlined, 'Class', _user?.className ?? ''),
                      _buildProfileItem(context, Icons.calendar_today_outlined, 'Date of Birth', _profile['dateOfBirth'] ?? ''),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            // Save profile changes
                          },
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
