class AtlasUser {
  final String uid; //document ref ID.
  final String email;
  final String firstName;
  final String lastName;
  final String username;

  AtlasUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
  });
}
