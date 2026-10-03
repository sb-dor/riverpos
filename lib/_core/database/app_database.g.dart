// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TempOrdersTableTable extends TempOrdersTable
    with TableInfo<$TempOrdersTableTable, TempOrdersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TempOrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceMeta = const VerificationMeta(
    'invoice',
  );
  @override
  late final GeneratedColumn<String> invoice = GeneratedColumn<String>(
    'invoice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, uuid, invoice];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'temp_orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TempOrdersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('invoice')) {
      context.handle(
        _invoiceMeta,
        invoice.isAcceptableOrUnknown(data['invoice']!, _invoiceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TempOrdersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TempOrdersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      ),
      invoice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice'],
      ),
    );
  }

  @override
  $TempOrdersTableTable createAlias(String alias) {
    return $TempOrdersTableTable(attachedDatabase, alias);
  }
}

class TempOrdersTableData extends DataClass
    implements Insertable<TempOrdersTableData> {
  final int id;
  final String? uuid;
  final String? invoice;
  const TempOrdersTableData({required this.id, this.uuid, this.invoice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || uuid != null) {
      map['uuid'] = Variable<String>(uuid);
    }
    if (!nullToAbsent || invoice != null) {
      map['invoice'] = Variable<String>(invoice);
    }
    return map;
  }

  TempOrdersTableCompanion toCompanion(bool nullToAbsent) {
    return TempOrdersTableCompanion(
      id: Value(id),
      uuid: uuid == null && nullToAbsent ? const Value.absent() : Value(uuid),
      invoice: invoice == null && nullToAbsent
          ? const Value.absent()
          : Value(invoice),
    );
  }

  factory TempOrdersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TempOrdersTableData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String?>(json['uuid']),
      invoice: serializer.fromJson<String?>(json['invoice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String?>(uuid),
      'invoice': serializer.toJson<String?>(invoice),
    };
  }

  TempOrdersTableData copyWith({
    int? id,
    Value<String?> uuid = const Value.absent(),
    Value<String?> invoice = const Value.absent(),
  }) => TempOrdersTableData(
    id: id ?? this.id,
    uuid: uuid.present ? uuid.value : this.uuid,
    invoice: invoice.present ? invoice.value : this.invoice,
  );
  TempOrdersTableData copyWithCompanion(TempOrdersTableCompanion data) {
    return TempOrdersTableData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      invoice: data.invoice.present ? data.invoice.value : this.invoice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TempOrdersTableData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('invoice: $invoice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, invoice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TempOrdersTableData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.invoice == this.invoice);
}

class TempOrdersTableCompanion extends UpdateCompanion<TempOrdersTableData> {
  final Value<int> id;
  final Value<String?> uuid;
  final Value<String?> invoice;
  const TempOrdersTableCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.invoice = const Value.absent(),
  });
  TempOrdersTableCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.invoice = const Value.absent(),
  });
  static Insertable<TempOrdersTableData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? invoice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (invoice != null) 'invoice': invoice,
    });
  }

  TempOrdersTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? uuid,
    Value<String?>? invoice,
  }) {
    return TempOrdersTableCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      invoice: invoice ?? this.invoice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (invoice.present) {
      map['invoice'] = Variable<String>(invoice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TempOrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('invoice: $invoice')
          ..write(')'))
        .toString();
  }
}

class $TempOrderItemsTableTable extends TempOrderItemsTable
    with TableInfo<$TempOrderItemsTableTable, TempOrderItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TempOrderItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
    'qty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    productName,
    price,
    qty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'temp_order_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TempOrderItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TempOrderItemsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TempOrderItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      ),
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      ),
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      ),
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty'],
      ),
    );
  }

  @override
  $TempOrderItemsTableTable createAlias(String alias) {
    return $TempOrderItemsTableTable(attachedDatabase, alias);
  }
}

class TempOrderItemsTableData extends DataClass
    implements Insertable<TempOrderItemsTableData> {
  final int id;
  final int? orderId;
  final int? productId;
  final String? productName;
  final double? price;
  final double? qty;
  const TempOrderItemsTableData({
    required this.id,
    this.orderId,
    this.productId,
    this.productName,
    this.price,
    this.qty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || orderId != null) {
      map['order_id'] = Variable<int>(orderId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    if (!nullToAbsent || productName != null) {
      map['product_name'] = Variable<String>(productName);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || qty != null) {
      map['qty'] = Variable<double>(qty);
    }
    return map;
  }

  TempOrderItemsTableCompanion toCompanion(bool nullToAbsent) {
    return TempOrderItemsTableCompanion(
      id: Value(id),
      orderId: orderId == null && nullToAbsent
          ? const Value.absent()
          : Value(orderId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      productName: productName == null && nullToAbsent
          ? const Value.absent()
          : Value(productName),
      price: price == null && nullToAbsent
          ? const Value.absent()
          : Value(price),
      qty: qty == null && nullToAbsent ? const Value.absent() : Value(qty),
    );
  }

  factory TempOrderItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TempOrderItemsTableData(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int?>(json['orderId']),
      productId: serializer.fromJson<int?>(json['productId']),
      productName: serializer.fromJson<String?>(json['productName']),
      price: serializer.fromJson<double?>(json['price']),
      qty: serializer.fromJson<double?>(json['qty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int?>(orderId),
      'productId': serializer.toJson<int?>(productId),
      'productName': serializer.toJson<String?>(productName),
      'price': serializer.toJson<double?>(price),
      'qty': serializer.toJson<double?>(qty),
    };
  }

  TempOrderItemsTableData copyWith({
    int? id,
    Value<int?> orderId = const Value.absent(),
    Value<int?> productId = const Value.absent(),
    Value<String?> productName = const Value.absent(),
    Value<double?> price = const Value.absent(),
    Value<double?> qty = const Value.absent(),
  }) => TempOrderItemsTableData(
    id: id ?? this.id,
    orderId: orderId.present ? orderId.value : this.orderId,
    productId: productId.present ? productId.value : this.productId,
    productName: productName.present ? productName.value : this.productName,
    price: price.present ? price.value : this.price,
    qty: qty.present ? qty.value : this.qty,
  );
  TempOrderItemsTableData copyWithCompanion(TempOrderItemsTableCompanion data) {
    return TempOrderItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      price: data.price.present ? data.price.value : this.price,
      qty: data.qty.present ? data.qty.value : this.qty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TempOrderItemsTableData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('price: $price, ')
          ..write('qty: $qty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderId, productId, productName, price, qty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TempOrderItemsTableData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.price == this.price &&
          other.qty == this.qty);
}

class TempOrderItemsTableCompanion
    extends UpdateCompanion<TempOrderItemsTableData> {
  final Value<int> id;
  final Value<int?> orderId;
  final Value<int?> productId;
  final Value<String?> productName;
  final Value<double?> price;
  final Value<double?> qty;
  const TempOrderItemsTableCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.price = const Value.absent(),
    this.qty = const Value.absent(),
  });
  TempOrderItemsTableCompanion.insert({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.price = const Value.absent(),
    this.qty = const Value.absent(),
  });
  static Insertable<TempOrderItemsTableData> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<double>? price,
    Expression<double>? qty,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (price != null) 'price': price,
      if (qty != null) 'qty': qty,
    });
  }

  TempOrderItemsTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? orderId,
    Value<int?>? productId,
    Value<String?>? productName,
    Value<double?>? price,
    Value<double?>? qty,
  }) {
    return TempOrderItemsTableCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      qty: qty ?? this.qty,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TempOrderItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('price: $price, ')
          ..write('qty: $qty')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TempOrdersTableTable tempOrdersTable = $TempOrdersTableTable(
    this,
  );
  late final $TempOrderItemsTableTable tempOrderItemsTable =
      $TempOrderItemsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tempOrdersTable,
    tempOrderItemsTable,
  ];
}

typedef $$TempOrdersTableTableCreateCompanionBuilder =
    TempOrdersTableCompanion Function({
      Value<int> id,
      Value<String?> uuid,
      Value<String?> invoice,
    });
typedef $$TempOrdersTableTableUpdateCompanionBuilder =
    TempOrdersTableCompanion Function({
      Value<int> id,
      Value<String?> uuid,
      Value<String?> invoice,
    });

class $$TempOrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $TempOrdersTableTable> {
  $$TempOrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoice => $composableBuilder(
    column: $table.invoice,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TempOrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TempOrdersTableTable> {
  $$TempOrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoice => $composableBuilder(
    column: $table.invoice,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TempOrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TempOrdersTableTable> {
  $$TempOrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get invoice =>
      $composableBuilder(column: $table.invoice, builder: (column) => column);
}

class $$TempOrdersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TempOrdersTableTable,
          TempOrdersTableData,
          $$TempOrdersTableTableFilterComposer,
          $$TempOrdersTableTableOrderingComposer,
          $$TempOrdersTableTableAnnotationComposer,
          $$TempOrdersTableTableCreateCompanionBuilder,
          $$TempOrdersTableTableUpdateCompanionBuilder,
          (
            TempOrdersTableData,
            BaseReferences<
              _$AppDatabase,
              $TempOrdersTableTable,
              TempOrdersTableData
            >,
          ),
          TempOrdersTableData,
          PrefetchHooks Function()
        > {
  $$TempOrdersTableTableTableManager(
    _$AppDatabase db,
    $TempOrdersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TempOrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TempOrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TempOrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> uuid = const Value.absent(),
            Value<String?> invoice = const Value.absent(),
          }) => TempOrdersTableCompanion(id: id, uuid: uuid, invoice: invoice),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> uuid = const Value.absent(),
                Value<String?> invoice = const Value.absent(),
              }) => TempOrdersTableCompanion.insert(
                id: id,
                uuid: uuid,
                invoice: invoice,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TempOrdersTableTable, TempOrdersTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $TempOrdersTableTable,
                    TempOrdersTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TempOrdersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TempOrdersTableTable,
      TempOrdersTableData,
      $$TempOrdersTableTableFilterComposer,
      $$TempOrdersTableTableOrderingComposer,
      $$TempOrdersTableTableAnnotationComposer,
      $$TempOrdersTableTableCreateCompanionBuilder,
      $$TempOrdersTableTableUpdateCompanionBuilder,
      (
        TempOrdersTableData,
        BaseReferences<
          _$AppDatabase,
          $TempOrdersTableTable,
          TempOrdersTableData
        >,
      ),
      TempOrdersTableData,
      PrefetchHooks Function()
    >;
typedef $$TempOrderItemsTableTableCreateCompanionBuilder =
    TempOrderItemsTableCompanion Function({
      Value<int> id,
      Value<int?> orderId,
      Value<int?> productId,
      Value<String?> productName,
      Value<double?> price,
      Value<double?> qty,
    });
typedef $$TempOrderItemsTableTableUpdateCompanionBuilder =
    TempOrderItemsTableCompanion Function({
      Value<int> id,
      Value<int?> orderId,
      Value<int?> productId,
      Value<String?> productName,
      Value<double?> price,
      Value<double?> qty,
    });

class $$TempOrderItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TempOrderItemsTableTable> {
  $$TempOrderItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TempOrderItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TempOrderItemsTableTable> {
  $$TempOrderItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderId => $composableBuilder(
    column: $table.orderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TempOrderItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TempOrderItemsTableTable> {
  $$TempOrderItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);
}

class $$TempOrderItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TempOrderItemsTableTable,
          TempOrderItemsTableData,
          $$TempOrderItemsTableTableFilterComposer,
          $$TempOrderItemsTableTableOrderingComposer,
          $$TempOrderItemsTableTableAnnotationComposer,
          $$TempOrderItemsTableTableCreateCompanionBuilder,
          $$TempOrderItemsTableTableUpdateCompanionBuilder,
          (
            TempOrderItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $TempOrderItemsTableTable,
              TempOrderItemsTableData
            >,
          ),
          TempOrderItemsTableData,
          PrefetchHooks Function()
        > {
  $$TempOrderItemsTableTableTableManager(
    _$AppDatabase db,
    $TempOrderItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TempOrderItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TempOrderItemsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TempOrderItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> orderId = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String?> productName = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<double?> qty = const Value.absent(),
              }) => TempOrderItemsTableCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                productName: productName,
                price: price,
                qty: qty,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> orderId = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String?> productName = const Value.absent(),
                Value<double?> price = const Value.absent(),
                Value<double?> qty = const Value.absent(),
              }) => TempOrderItemsTableCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                productName: productName,
                price: price,
                qty: qty,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $TempOrderItemsTableTable,
                    TempOrderItemsTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TempOrderItemsTableTable,
                    TempOrderItemsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TempOrderItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TempOrderItemsTableTable,
      TempOrderItemsTableData,
      $$TempOrderItemsTableTableFilterComposer,
      $$TempOrderItemsTableTableOrderingComposer,
      $$TempOrderItemsTableTableAnnotationComposer,
      $$TempOrderItemsTableTableCreateCompanionBuilder,
      $$TempOrderItemsTableTableUpdateCompanionBuilder,
      (
        TempOrderItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $TempOrderItemsTableTable,
          TempOrderItemsTableData
        >,
      ),
      TempOrderItemsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TempOrdersTableTableTableManager get tempOrdersTable =>
      $$TempOrdersTableTableTableManager(_db, _db.tempOrdersTable);
  $$TempOrderItemsTableTableTableManager get tempOrderItemsTable =>
      $$TempOrderItemsTableTableTableManager(_db, _db.tempOrderItemsTable);
}
