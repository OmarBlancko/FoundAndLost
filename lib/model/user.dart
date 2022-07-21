class AuthenticatedUser {
  late final String id;
  late final String name;
  late final String email;
  late final String password;
  late final String imageUrl;
  late final String? loginStatus;
  AuthenticatedUser({required this.id,required this.email,required this.password,required this.name,required this.imageUrl,this.loginStatus});
}