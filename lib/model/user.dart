
class User {
  String? name;
  String? email;

  User(this.name, this.email);

  Map<String, dynamic> toFireStore() {

    return {
     'name': name, 'email': email
    };
  }

  User.fromFireStore(Map<String, dynamic>? mp) {
    name=mp?['name'];
    email=mp?['email'];

  }

}
