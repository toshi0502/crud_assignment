class Customer {
  String pan;
  String fullName;
  String email;
  String mobile;
  List<Address> addresses;

  Customer(
      {required this.pan,
      required this.fullName,
      required this.email,
      required this.mobile,
      required this.addresses});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      pan: json['pan'],
      fullName: json['fullName'],
      email: json['email'],
      mobile: json['mobile'],
      addresses:
          (json['addresses'] as List).map((i) => Address.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pan': pan,
      'fullName': fullName,
      'email': email,
      'mobile': mobile,
      'addresses': addresses.map((e) => e.toJson()).toList(),
    };
  }
}

class Address {
  String addressLine1;
  String? addressLine2;
  String postcode;
  String state;
  String city;

  Address(
      {required this.addressLine1,
      this.addressLine2,
      required this.postcode,
      required this.state,
      required this.city});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      postcode: json['postcode'],
      state: json['state'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'postcode': postcode,
      'state': state,
      'city': city,
    };
  }
}
