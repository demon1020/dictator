// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Document extends _Document
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Document(
    int id,
    String name, {
    String? path,
    String? data,
    String? status,
    DateTime? timestamp,
    bool isSelected = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Document>({
        'isSelected': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'path', path);
    RealmObjectBase.set(this, 'data', data);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'timestamp', timestamp);
    RealmObjectBase.set(this, 'isSelected', isSelected);
  }

  Document._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get path => RealmObjectBase.get<String>(this, 'path') as String?;
  @override
  set path(String? value) => RealmObjectBase.set(this, 'path', value);

  @override
  String? get data => RealmObjectBase.get<String>(this, 'data') as String?;
  @override
  set data(String? value) => RealmObjectBase.set(this, 'data', value);

  @override
  String? get status => RealmObjectBase.get<String>(this, 'status') as String?;
  @override
  set status(String? value) => RealmObjectBase.set(this, 'status', value);

  @override
  DateTime? get timestamp =>
      RealmObjectBase.get<DateTime>(this, 'timestamp') as DateTime?;
  @override
  set timestamp(DateTime? value) =>
      RealmObjectBase.set(this, 'timestamp', value);

  @override
  bool get isSelected => RealmObjectBase.get<bool>(this, 'isSelected') as bool;
  @override
  set isSelected(bool value) => RealmObjectBase.set(this, 'isSelected', value);

  @override
  Stream<RealmObjectChanges<Document>> get changes =>
      RealmObjectBase.getChanges<Document>(this);

  @override
  Document freeze() => RealmObjectBase.freezeObject<Document>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Document._);
    return const SchemaObject(ObjectType.realmObject, Document, 'Document', [
      SchemaProperty('id', RealmPropertyType.int),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('path', RealmPropertyType.string, optional: true),
      SchemaProperty('data', RealmPropertyType.string, optional: true),
      SchemaProperty('status', RealmPropertyType.string, optional: true),
      SchemaProperty('timestamp', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('isSelected', RealmPropertyType.bool),
    ]);
  }
}
