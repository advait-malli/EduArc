class TransportInfo {
  final String id;
  final String routeName;
  final String busNumber;
  final String driverName;
  final String driverPhone;
  final String pickupPoint;
  final String pickupTime;
  final String dropTime;
  final String vehicleNumber;

  TransportInfo({
    required this.id,
    required this.routeName,
    required this.busNumber,
    required this.driverName,
    required this.driverPhone,
    required this.pickupPoint,
    required this.pickupTime,
    required this.dropTime,
    required this.vehicleNumber,
  });

  factory TransportInfo.fromJson(Map<String, dynamic> json) {
    return TransportInfo(
      id: json['id'] ?? '',
      routeName: json['routeName'] ?? '',
      busNumber: json['busNumber'] ?? '',
      driverName: json['driverName'] ?? '',
      driverPhone: json['driverPhone'] ?? '',
      pickupPoint: json['pickupPoint'] ?? '',
      pickupTime: json['pickupTime'] ?? '',
      dropTime: json['dropTime'] ?? '',
      vehicleNumber: json['vehicleNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeName': routeName,
      'busNumber': busNumber,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'pickupPoint': pickupPoint,
      'pickupTime': pickupTime,
      'dropTime': dropTime,
      'vehicleNumber': vehicleNumber,
    };
  }
}
