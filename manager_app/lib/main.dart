import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(const ManagerApp());

class ManagerApp extends StatelessWidget {
  const ManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      fontFamily: 'SF Pro',
      scaffoldBackgroundColor: const Color(0xFFF5F6F7),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3DDC84), // зелёный как в макете
        brightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Manager',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}

/// ===================== DATA =====================
enum Status { online, offline }

class LocationItem {
  final String name;
  final int stations;
  final Status status;

  const LocationItem({required this.name, required this.stations, required this.status});
}

final demoLocations = <LocationItem>[
  const LocationItem(name: "Famous Ben's Pizza 1", stations: 0, status: Status.offline),
  const LocationItem(name: "Comedy Shop", stations: 13, status: Status.offline),
  const LocationItem(name: "Japanese cafe", stations: 17, status: Status.offline),
  const LocationItem(name: "Seafood Restaurant", stations: 48, status: Status.offline),
  const LocationItem(name: "Fork & Flame", stations: 42, status: Status.offline),
  const LocationItem(name: "The Daily Bite", stations: 70, status: Status.online),
  const LocationItem(name: "Super Market", stations: 0, status: Status.offline),
  const LocationItem(name: "Coffeeshop", stations: 9, status: Status.offline),
  const LocationItem(name: "IHOP", stations: 67, status: Status.offline),
  const LocationItem(name: "Karizma Lounge", stations: 100, status: Status.online),
  const LocationItem(name: "Velvet Spoon", stations: 62, status: Status.online),
  const LocationItem(name: "Harvest & Hearth", stations: 34, status: Status.online),
  const LocationItem(name: "Nom Nom Nook", stations: 32, status: Status.online),
  const LocationItem(name: "Spice Theory", stations: 28, status: Status.online),
];

double onlineShare(List<LocationItem> list) {
  if (list.isEmpty) return 0;
  final online = list.where((e) => e.status == Status.online).length;
  return online / list.length;
}

/// ===================== DASHBOARD =====================
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final percentOnline = (onlineShare(demoLocations) * 100).round();
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Manager Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          const SizedBox(height: 8),
          _SectionTitleWithFilter(
            title: 'Summary',
            trailing: _FilterPill(label: 'All time'),
          ),
          const SizedBox(height: 8),
          _SummaryCard(percentOnline: percentOnline),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Locations'),
          const SizedBox(height: 8),
          _NavCard(
            title: 'Total locations',
            value: demoLocations.length.toString(),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 12, offset: const Offset(0, 4))],
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

/// ===================== LOCATIONS =====================
class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _query = '';
  bool _asc = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<LocationItem> _filtered() {
    Iterable<LocationItem> data = demoLocations;
    // tab filter
    if (_tab.index == 1) {
      data = data.where((e) => e.status == Status.offline);
    } else if (_tab.index == 2) {
      data = data.where((e) => e.status == Status.online);
    }
    // search
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      data = data.where((e) => e.name.toLowerCase().contains(q));
    }
    final list = data.toList()
      ..sort((a, b) => _asc ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(CupertinoIcons.back), onPressed: () => Navigator.pop(context)),
        title: const Text('Locations'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tab,
              indicator: BoxDecoration(
                color: const Color(0xFFEFF5F0),
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black54,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Offline'),
                Tab(text: 'Online'),
              ],
              onTap: (_) => setState(() {}),
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Filter',
            onPressed: _showFilterSheet,
            icon: const Icon(CupertinoIcons.line_horizontal_3_decrease),
          ),
          IconButton(
            tooltip: 'Sort',
            onPressed: () => setState(() => _asc = !_asc),
            icon: const Icon(CupertinoIcons.arrow_up_arrow_down),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.search, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter name/address or ID',
                        border: InputBorder.none,
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _filtered().length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final item = _filtered()[i];
                return _LocationTile(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(CupertinoIcons.checkmark_circle),
                title: const Text('Sort A → Z'),
                onTap: () {
                  setState(() => _asc = true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.xmark_circle),
                title: const Text('Sort Z → A'),
                onTap: () {
                  setState(() => _asc = false);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(CupertinoIcons.dot_radiowaves_left_right),
                title: const Text('Show All'),
                onTap: () {
                  _tab.index = 0;
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.wifi_exclamationmark),
                title: const Text('Show Offline only'),
                onTap: () {
                  _tab.index = 1;
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.wifi),
                title: const Text('Show Online only'),
                onTap: () {
                  _tab.index = 2;
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LocationTile extends StatelessWidget {
  final LocationItem item;
  const _LocationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isOnline = item.status == Status.online;
    final borderColor = isOnline ? const Color(0xFF26C281) : const Color(0xFFE86B6B);
    final textColor = isOnline ? const Color(0xFF26C281) : const Color(0xFFE86B6B);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          _Badge(number: item.stations, color: borderColor, textColor: textColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(item.name, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int number;
  final Color color;
  final Color textColor;
  const _Badge({required this.number, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        number.toString(),
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}
