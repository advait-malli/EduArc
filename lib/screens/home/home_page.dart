import 'package:flutter/material.dart';
import '../../core/utils/responsive_layout.dart';
import '../../widgets/common/primary_page_header.dart';
import '../../widgets/home/homework_card.dart';
import '../../widgets/home/timetable_card.dart';
import '../../widgets/home/calendar_card.dart';
import '../../widgets/home/news_card.dart';
import '../../widgets/home/timetable_calendar_card.dart';
import '../settings/settings_page.dart';

class HomePage extends StatefulWidget {
  final String role;

  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: SafeArea(
        child: isMobile
            ? CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: PrimaryPageHeader(
                      title: 'Home',
                      subtitle: 'Welcome back, ${widget.role}!',
                      onSettingsPressed: () => showSettingsSheet(context),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    sliver: _buildMobileLayout(context),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              )
            : _buildDesktopLayout(context),
       ),
     );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      children: [
        PrimaryPageHeader(
          title: 'Home',
          subtitle: 'Welcome back, ${widget.role}!',
          onSettingsPressed: () => showSettingsSheet(context),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            HomeworkCard(role: widget.role),
                            const SizedBox(height: 20),
                            const NewsCard(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 360,
                  child: const TimetableCalendarCard(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(
          height: 240,
          child: HomeworkCard(role: widget.role, scrollable: true),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: const NewsCard(scrollable: true),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: const TimetableCard(scrollable: true),
        ),
        const SizedBox(height: 16),
        const CalendarCard(),
        const SizedBox(height: 16),
      ]),
    );
  }
}
