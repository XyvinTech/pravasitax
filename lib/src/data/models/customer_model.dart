class Customer {
  final String name;
  final String? email;
  final String? mobile;
  final String? countryCode;
  final String? residingCountry;

  Customer({
    required this.name,
    this.email,
    this.mobile,
    this.countryCode,
    this.residingCountry,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '',
      email: json['email'],
      mobile: json['mobile'],
      countryCode: json['country_code'],
      residingCountry: json['residing_country'],
    );
  }
}
