class User {
  final String name;
  final String? email;
  final String? mobile;
  final String? countryCode;
  final String? residingCountry;
  final String? department;
  final String? designation;

  User({
    required this.name,
    this.email,
    this.mobile,
    this.countryCode,
    this.residingCountry,
    this.department,
    this.designation,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'],
      mobile: json['mobile'],
      countryCode: json['country_code'],
      residingCountry: json['residing_country'],
      department: json['department'],
      designation: json['designation'],
    );
  }
}
