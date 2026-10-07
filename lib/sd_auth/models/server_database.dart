import 'package:flutter/foundation.dart';

@immutable
class ServerDatabase {
  const ServerDatabase({
    this.id,
    this.uid,
    this.warehouseName,
    this.limitStore,
    required this.databaseName,
    required this.backendApi,
  });

  factory ServerDatabase.fromJson(Map<String, Object?> map) {
    return ServerDatabase(
      id: map['id'] as int?,
      uid: map['uid'] as String?,
      warehouseName: map['warehouse_name'] as String?,
      limitStore: switch (map['limit_store']) {
        int value => value,
        num value => value.toInt(),
        String value => int.tryParse(value),
        _ => null,
      },
      databaseName: map['database_name'] as String,
      backendApi: map['backend_api'] as String,
    );
  }

  final int? id;
  final String? uid;
  final String? warehouseName;
  final int? limitStore;
  final String databaseName;
  final String backendApi;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerDatabase &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          uid == other.uid &&
          warehouseName == other.warehouseName &&
          limitStore == other.limitStore &&
          databaseName == other.databaseName &&
          backendApi == other.backendApi);

  @override
  int get hashCode =>
      id.hashCode ^
      uid.hashCode ^
      warehouseName.hashCode ^
      limitStore.hashCode ^
      databaseName.hashCode ^
      backendApi.hashCode;

  @override
  String toString() {
    return 'ServerDatabase{'
        ' id: $id,'
        ' uid: $uid,'
        ' warehouseName: $warehouseName,'
        ' limitStore: $limitStore,'
        ' databaseName: $databaseName,'
        ' ip: $backendApi, '
        '}';
  }

  ServerDatabase copyWith({
    int? id,
    ValueGetter<String?>? uid,
    ValueGetter<String?>? warehouseName,
    ValueGetter<int?>? limitStore,
    String? databaseName,
    String? backendApi,
  }) {
    return ServerDatabase(
      id: id ?? this.id,
      uid: uid != null ? uid() : this.uid,
      warehouseName: warehouseName != null ? warehouseName() : this.warehouseName,
      limitStore: limitStore != null ? limitStore() : this.limitStore,
      databaseName: databaseName ?? this.databaseName,
      backendApi: backendApi ?? this.backendApi,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'uid': uid,
      'warehouse_name': warehouseName,
      'limit_store': limitStore,
      'database_name': databaseName,
      'backend_api': backendApi,
    };
  }
}
