class SignUpInput {
  SignUpInput({this.phoneNumber, this.name, this.address});

  int? phoneNumber;
  String? name;
  String? address;

  Map<String, dynamic> toMap() => {
        "password": "qwertyuiop",
        "phoneNum": phoneNumber,
        "username": name,
        "roleType": "DRIVER",
        "address": address,
      };

  factory SignUpInput.fromMap(Map<String, dynamic> json) => SignUpInput(
      // email: json["email"],
      // password: json["password"],
      // phone: json["phoneNumber"],
      // name: json["name"]

      );
}
