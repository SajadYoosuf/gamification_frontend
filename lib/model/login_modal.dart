class LoginModal{
  String? Email;
  String? Password;
  Map<String, dynamic> toJson() {
    return {
      'Email': Email,
      'Password': Password,
    };
  }
}
