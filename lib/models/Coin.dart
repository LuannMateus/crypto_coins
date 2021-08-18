class Coin {
  String baseId;
  String icon;
  String name;
  String initials;
  double price;
  DateTime timestamp;
  double hourChange;
  double dayChange;
  double weekChange;
  double monthChange;
  double yearChange;
  double totalPeriodChange;

  Coin({
    required this.baseId,
    required this.icon,
    required this.name,
    required this.initials,
    required this.price,
    required this.timestamp,
    required this.hourChange,
    required this.dayChange,
    required this.weekChange,
    required this.monthChange,
    required this.yearChange,
    required this.totalPeriodChange,
  });
}
