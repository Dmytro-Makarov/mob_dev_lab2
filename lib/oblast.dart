

class Oblast {
  int? id;
  final String name;
  final int population;
  final double area; //km^2
  final String oblastCenter;

  Oblast({
    this.id,
    required this.name,
    required this.population,
    required this.area,
    required this.oblastCenter,
  });

  // Convert an Oblast into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'name': name,
      'population': population,
      'area': area,
      'oblastCenter': oblastCenter,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  // Implement toString to make it easier to see information about
  // each oblast when using the print statement.
  @override
  String toString() {
    return 'Oblast{id: $id, name: $name, population: $population, area: $area, oblastCenter: $oblastCenter}';
  }
}