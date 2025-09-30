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
