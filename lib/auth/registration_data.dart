class RegistrationData {
  const RegistrationData({
    this.fullName = '',
    this.gender = '',
    this.birthDate,
    this.contactNumber = '',
    this.brgy = '',
    this.street = '',
    this.city = '',
    this.province = '',
    this.zip = '',
    this.email = '',
    this.username = '',
    this.password = '',
  });

  final String fullName;
  final String gender;
  final DateTime? birthDate;
  final String contactNumber;
  final String brgy;
  final String street;
  final String city;
  final String province;
  final String zip;
  final String email;
  final String username;
  final String password;

  RegistrationData copyWith({String? username, String? password}) {
    return RegistrationData(
      fullName: fullName,
      gender: gender,
      birthDate: birthDate,
      contactNumber: contactNumber,
      brgy: brgy,
      street: street,
      city: city,
      province: province,
      zip: zip,
      email: email,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}