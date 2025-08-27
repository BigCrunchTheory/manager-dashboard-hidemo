import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data.dart';
import '../services/api_service.dart';
import 'locations_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _api = ApiService();
  bool _loading = true;
  int _percentOnline = 0;
  int _totalLocations = 0;
  String _filterLabel = 'All time';

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    setState(() { _loading = true; });
    try {
      final s = await _api.fetchSummary(preset: 'ALL_TIME');
      setState((){
        _percentOnline = s.averageLocationOnline;
        _totalLocations = s.totalLocationsCount;
        _filterLabel = 'All time';
      });
    } catch (e) {
      // keep demo fallback
      setState((){
        _percentOnline = (onlineShare(demoLocations) * 100).round();
        _totalLocations = demoLocations.length;
      });
    } finally {
      setState((){ _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentOnline = _percentOnline;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Manager Dashboard'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              children: [
                const SizedBox(height: 8),
                _SectionTitleWithFilter(
                  title: 'Summary',
                  trailing: _FilterPill(label: _filterLabel),
                ),
                const SizedBox(height: 8),
                _SummaryCard(percentOnline: percentOnline),
                const SizedBox(height: 24),
                const _SectionTitle(title: 'Locations'),
                const SizedBox(height: 8),
                _NavCard(
                  title: 'Total locations',
                  value: _totalLocations.toString(),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LocationsScreen()));
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Logout', style: TextStyle(decoration: TextDecoration.underline)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int percentOnline;
  const _SummaryCard({required this.percentOnline});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
  boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // left texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Average stations online:', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54)),
                const SizedBox(height: 6),
                Text('$percentOnline%', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Mar 2, 2025 - Mar 9, 2025', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black45)),
              ],
            ),
          ),
          // right pie
          SizedBox(
            height: 120,
            width: 120,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 0,
                sectionsSpace: 0,
                sections: [
                  PieChartSectionData(
                    value: percentOnline.toDouble(),
                    radius: 54,
                    color: cs.primary,
                    title: '',
                  ),
                  PieChartSectionData(
                    value: (100 - percentOnline).toDouble(),
                    radius: 54,
                    color: const Color(0xFFF6CFE0), // нежно-розовый сектор
                    title: '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  const _NavCard({required this.title, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text('$title:  $value', style: Theme.of(context).textTheme.titleMedium),
              ),
              const Icon(CupertinoIcons.chevron_right, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black87));
  }
}

class _SectionTitleWithFilter extends StatelessWidget {
  final String title;
  final Widget trailing;
  const _SectionTitleWithFilter({required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SectionTitle(title: title),
        const Spacer(),
        trailing,
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  const _FilterPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(CupertinoIcons.chevron_down, size: 14),
        ],
      ),
    );
  }
}
