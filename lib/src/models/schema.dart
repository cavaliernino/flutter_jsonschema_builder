import 'dart:developer';

import 'package:flutter/foundation.dart';
import '../models/models.dart';
// Esto transforma el JSON a Modelos

enum SchemaType {
  string,
  number,
  boolean,
  integer,
  object,
  array,
}
SchemaType schemaTypeFromString(String value) {
  return SchemaType.values.where((e) => describeEnum(e) == value).first;
}

class Schema {
  Schema({
    required this.id,
    required this.type,
    this.title = 'no-title',
    this.description,
    this.parentIdKey,
  });

  factory Schema.fromJson(
    Map<String, dynamic> json, {
    String id = kNoIdKey,
    Schema? parent,
  }) {
    Schema schema;

    switch (schemaTypeFromString(json['type'])) {
      case SchemaType.object:
        schema = SchemaObject.fromJson(id, json, parent: parent);
        break;

      case SchemaType.array:
        schema = SchemaArray.fromJson(id, json, parent: parent);

        break;

      default:
        schema = SchemaProperty.fromJson(id, json, parent: parent);
        break;
    }

    return schema;
  }

  // props
  String id;
  String title;
  String? description;
  SchemaType type;

  // util props
  String? parentIdKey;

  /// it lets us know the key in the formData Map {key}
  String get idKey {
    print('----');
    print('idKey[$id] | parentIdKey[$parentIdKey]');

    if (parentIdKey != null && parentIdKey != (kGenesisIdKey)) {
      print('😱 😱 resultado es ${_appendId(parentIdKey!, id)} ');

      if (this is SchemaProperty &&
          (this as SchemaProperty).format == PropertyFormat.dataurl) {
        return parentIdKey!;
      }

      return _appendId(parentIdKey!, id);
    }
    print('😱 resultado es $id');

    return id;
  }

  String _appendId(String path, String id) {
    final key = id != kNoIdKey ? '$path.$id' : path;

    return key;
  }

  Schema copyWith({
    required String id,
    String? parentIdKey,
  }) {
    return Schema(
      id: id,
      type: type,
      title: title,
      description: description,
      parentIdKey: parentIdKey ?? this.parentIdKey,
    );
  }
}
