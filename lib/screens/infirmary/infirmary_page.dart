import 'package:flutter/material.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../core/repositories/repository_provider.dart';
import '../../core/models/infirmary.dart';
import '../settings/settings_page.dart';

class InfirmaryPage extends StatefulWidget {
  final String role;

  const InfirmaryPage({super.key, required this.role});

  @override
  State<InfirmaryPage> createState() => _InfirmaryPageState();
}

class _InfirmaryPageState extends State<InfirmaryPage> {
  List<InfirmaryVisit> visits = [];
  HealthProfile? healthProfile;
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
    final repo = RepositoryProvider.of(context).infirmaryRepository;
    final v = await repo.getVisits();
    final hp = await repo.getHealthProfile();
    if (mounted) setState(() { visits = v; healthProfile = hp; isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PrimaryPageHeader(
              title: 'Infirmary',
              subtitle: 'Health records & visits',
              onSettingsPressed: () => showSettingsSheet(context),
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          else ...[
            if (healthProfile != null)
              SliverToBoxAdapter(child: _buildHealthProfile(healthProfile!)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    const Text('Visit History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    FilledButton.tonal(
                      onPressed: _showReportVisitSheet,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.add, size: 18), SizedBox(width: 4), Text('Report Visit')],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (visits.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_hospital_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('No visits recorded', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildVisitCard(visits[index], index),
                    childCount: visits.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ],
      ),
    );
  }

  Widget _buildHealthProfile(HealthProfile profile) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              const Text('Health Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Blood: ${profile.bloodGroup}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (profile.allergies.isNotEmpty) ...[
            _profileRow(Icons.warning_amber, 'Allergies', profile.allergies.join(', ')),
            const SizedBox(height: 8),
          ],
          if (profile.medications.isNotEmpty) ...[
            _profileRow(Icons.medication, 'Medications', profile.medications.join(', ')),
            const SizedBox(height: 8),
          ],
          _profileRow(Icons.person, 'Emergency Contact', profile.emergencyContact),
          const SizedBox(height: 8),
          _profileRow(Icons.phone, 'Emergency Phone', profile.emergencyPhone),
        ],
      ),
    );
  }

  Widget _profileRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
      ],
    );
  }

  Widget _buildVisitCard(InfirmaryVisit visit, int index) {
    final isFirst = index == 0;
    final isLast = index == visits.length - 1;
    BorderRadius borderRadius;
    if (isFirst && isLast) {
      borderRadius = BorderRadius.circular(24);
    } else if (isFirst) {
      borderRadius = const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10));
    } else if (isLast) {
      borderRadius = const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24));
    } else {
      borderRadius = BorderRadius.circular(10);
    }

    final color = visit.isActive ? Colors.orange : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: borderRadius),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(visit.isActive ? Icons.warning : Icons.check_circle, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(visit.reason, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('${_formatDate(visit.date)} • ${visit.nurseName}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(visit.status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            if (visit.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(visit.description, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            ],
            if (visit.medication != null && visit.medication!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.medication, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(visit.medication!, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ],
            if (visit.followUp != null && visit.followUp!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.follow_the_signs, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(visit.followUp!, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showReportVisitSheet() {
    final reasonCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final medicationCtrl = TextEditingController();
    final followUpCtrl = TextEditingController();
    bool submitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.local_hospital, color: Theme.of(context).colorScheme.primary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Report Visit', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          Text('Notify the school nurse', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: reasonCtrl,
                  decoration: InputDecoration(
                    labelText: 'Reason for visit',
                    hintText: 'e.g., Headache, Stomach ache',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.sick),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe your symptoms',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 12, top: 12),
                      child: Icon(Icons.description),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: medicationCtrl,
                  decoration: InputDecoration(
                    labelText: 'Medication (optional)',
                    hintText: 'Any medication taken',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.medication),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: followUpCtrl,
                  decoration: InputDecoration(
                    labelText: 'Follow-up (optional)',
                    hintText: 'Any follow-up instructions',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.follow_the_signs),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: () => Navigator.pop(ctx),
                        style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: submitting ? null : () async {
                          if (reasonCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a reason')),
                            );
                            return;
                          }
                          setSheetState(() => submitting = true);
                          try {
                            await RepositoryProvider.of(context).infirmaryRepository.reportVisit(
                              reason: reasonCtrl.text,
                              description: descCtrl.text,
                              medication: medicationCtrl.text.isNotEmpty ? medicationCtrl.text : null,
                              followUp: followUpCtrl.text.isNotEmpty ? followUpCtrl.text : null,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            await _loadData();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Visit reported successfully')),
                              );
                            }
                          } catch (e) {
                            setSheetState(() => submitting = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed: $e')),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                        child: submitting
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Report'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
