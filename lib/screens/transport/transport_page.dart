import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/transport.dart';
import '../settings/settings_page.dart';

class TransportPage extends StatefulWidget {
  final String role;

  const TransportPage({super.key, required this.role});

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  TransportInfo? transport;
  bool isLoading = true;
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
    final repo = RepositoryProvider.of(context).transportRepository;
    final info = await repo.getTransportInfo();
    if (mounted) setState(() { transport = info; isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'School Transport',
              subtitle: 'Bus & route information',
              onSettingsPressed: () => showSettingsSheet(context),
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (transport == null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_bus_filled_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('No transport assigned', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildInfoCard(context, [
                    _InfoItem(icon: Icons.route, label: 'Route', value: transport!.routeName),
                    _InfoItem(icon: Icons.directions_bus, label: 'Bus Number', value: transport!.busNumber),
                    _InfoItem(icon: Icons.pin_drop, label: 'Pickup Point', value: transport!.pickupPoint),
                    _InfoItem(icon: Icons.badge, label: 'Vehicle No.', value: transport!.vehicleNumber),
                  ]),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, [
                    _InfoItem(icon: Icons.person, label: 'Driver', value: transport!.driverName),
                    _InfoItem(icon: Icons.phone, label: 'Phone', value: transport!.driverPhone),
                  ]),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, [
                    _InfoItem(icon: Icons.login, label: 'Pickup Time', value: transport!.pickupTime),
                    _InfoItem(icon: Icons.logout, label: 'Drop Time', value: transport!.dropTime),
                  ]),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<_InfoItem> items) {
    final borderRadius = BorderRadius.circular(24);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: List.generate(items.length * 2 - 1, (index) {
            if (index.isOdd) return const Divider(height: 1);
            final item = items[index ~/ 2];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(item.icon, color: Theme.of(context).colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item.label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ),
                  Text(item.value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem({required this.icon, required this.label, required this.value});
}
