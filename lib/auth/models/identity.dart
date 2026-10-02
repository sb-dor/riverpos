sealed class Identity {
  Identity();

  int get id;

  String get fullName;
}

class User extends Identity {
  User({
    required this.id,
    this.warehouseId,
    this.warehouseName,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, Object?> json) {
    return User(
      id: json['id'] as int,
      warehouseId: json['warehouse_id'] as int?,
      warehouseName: json['warehouse_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }

  @override
  final int id;
  final int? warehouseId;

  final String? warehouseName;
  final String? firstName;
  final String? lastName;

  @override
  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
