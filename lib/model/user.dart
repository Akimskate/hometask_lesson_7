class User {
  final int id;
  final String name;
  final int age;

  User({
    this.id = -1,
    required this.name,
    required this.age,
  });

  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(
        id: data['id'],
        name: data['name'],
        age: data['age'],
      );
  Map<String, dynamic> toDatabaseJson() => {
        "id": id,
        "name": name,
        "age": age,
      };

  @override
  String toString() {
    return '$name, $age';
  }
}
