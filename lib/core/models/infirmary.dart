class InfirmaryVisit {
  final String id;
  final DateTime date;
  final String reason;
  final String description;
  final String nurseName;
  final String? medication;
  final String? followUp;
  final String status;

  InfirmaryVisit({
    required this.id,
    required this.date,
    required this.reason,
    required this.description,
    required this.nurseName,
    this.medication,
    this.followUp,
    required this.status,
  });

  bool get isActive => status == 'Active';

  factory InfirmaryVisit.fromJson(Map<String, dynamic> json) {
    return InfirmaryVisit(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      reason: json['reason'] ?? '',
      description: json['description'] ?? '',
      nurseName: json['nurseName'] ?? '',
      medication: json['medication'],
      followUp: json['followUp'],
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'reason': reason,
      'description': description,
      'nurseName': nurseName,
      'medication': medication,
      'followUp': followUp,
      'status': status,
    };
  }
}

class HealthProfile {
  final String bloodGroup;
  final List<String> allergies;
  final List<String> medications;
  final String emergencyContact;
  final String emergencyPhone;

  HealthProfile({
    required this.bloodGroup,
    required this.allergies,
    required this.medications,
    required this.emergencyContact,
    required this.emergencyPhone,
  });

  factory HealthProfile.fromJson(Map<String, dynamic> json) {
    return HealthProfile(
      bloodGroup: json['bloodGroup'] ?? '',
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((a) => a.toString())
              .toList() ??
          [],
      medications: (json['medications'] as List<dynamic>?)
              ?.map((m) => m.toString())
              .toList() ??
          [],
      emergencyContact: json['emergencyContact'] ?? '',
      emergencyPhone: json['emergencyPhone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'medications': medications,
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
    };
  }
}
