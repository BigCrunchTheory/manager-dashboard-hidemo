import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../services/api_service.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _query = '';
  bool _asc = true;
  final _api = ApiService();
  bool _loading = true;
  List<LocationItem> _items = [];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  _loadCards();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<LocationItem> _filtered() {
  Iterable<LocationItem> data = _items.isNotEmpty ? _items : demoLocations;
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

  Future<void> _loadCards() async {
    setState((){ _loading = true; });
    try {
      final cards = await _api.fetchLocationCards();
      // map LocationCard -> LocationItem
      final mapped = cards.map((c) {
        final stationsCount = c.stationsInfo.length;
        final online = c.stationsInfo.any((s) => s.currentOnlineStatus == 1);
        final name = c.address.isNotEmpty ? c.address : c.locationId;
        return LocationItem(name: name, stations: stationsCount, status: online ? Status.online : Status.offline);
      }).toList();
      setState((){ _items = mapped; });
    } catch (e) {
      // keep demo data
    } finally {
      setState((){ _loading = false; });
    }
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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
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
