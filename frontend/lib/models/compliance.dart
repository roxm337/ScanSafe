class Compliance {
  final bool compliant;
  final List<Map<String, String>> issues;
  final String? advice;

  Compliance({required this.compliant, required this.issues, this.advice});

  factory Compliance.fromJson(Map<String, dynamic> json) {
    return Compliance(
      compliant: json['compliant'] ?? true,
      issues: List<Map<String, String>>.from(json['issues'] ?? []),
      advice: json['advice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compliant': compliant,
      'issues': issues,
      'advice': advice,
    };
  }
}
