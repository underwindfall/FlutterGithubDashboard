class UserModel {
  final String name;
  final String avatarUrl;

  UserModel(this.name, this.avatarUrl);

  bool isValid() {
    return name != null;
  }

  @override
  String toString() => 'UserModel($name)';

  factory UserModel.fromJson(Map<String, dynamic> json) {
//    if (json = null) {
//      return null;
//    } else {
    return new UserModel(
      // ignore: argument_type_not_assignable

      // ignore: argument_type_not_assignable
        json['name'],
        // ignore: argument_type_not_assignable
        json['avatar_url']
    );
//    }
  }
}


