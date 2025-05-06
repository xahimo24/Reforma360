/// Modelo simple usado por loginProvider
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, String> toJson() => {'email': email, 'password': password};
}
