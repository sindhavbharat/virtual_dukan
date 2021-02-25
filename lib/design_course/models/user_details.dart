class UserDetails {
  final int id;
  final String name, profileUrl;

  UserDetails({this.id, this.name, this.profileUrl});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      name: json['name'],
      profileUrl: json['profile_image'],
    );
  }
}
