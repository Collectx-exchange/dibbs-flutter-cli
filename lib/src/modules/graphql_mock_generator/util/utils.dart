import 'package:deep_collection/deep_collection.dart';
import 'package:gql/ast.dart';

dynamic fillPropertyByType(String type, EnumTypeDefinitionNode? enumType) {
  if (enumType != null) {
    return enumType.values.first.name.value;
  }

  switch (type) {
    case "UUID4":
      return "id";
    case "GraphQlBigNumber":
      return '123456789';
    case "Int":
      return 123;
    case "ImageUrl":
      return "https://img.dibbscdn.com/4f2827a0-d556-4b82-88bc-4d0661126672";
    case "String":
      return "string";
    case "UnixTimeSeconds":
      return 111111;
    case "UnixTimeMilliSeconds":
      return 111111;
    case "Upload":
      return "Upload";
    case "StringLowerCase":
      return "stringLowerCase";
    case "StringUpperCase":
      return "STRING_UPPER_CASE";
    case "Markdown":
      return "<p>Markdown</p>";
    case "Boolean":
      return true;
    case "JSONObject":
    default:
      return {};
  }
}

bool keyExists(Map<String, dynamic> object, String searchedKey) {
  var exists = object.containsKey(searchedKey);

  if (!exists) {
    final keys = object.keys;
    exists = keys.where((element) => keyExists(object, element)).isNotEmpty;
  }

  return exists;
}

Map<String, dynamic> addDeeply({
  required dynamic map,
  required String key,
  required String? childKey,
  required dynamic value,
  TypeNode? typeNode,
}) {
  return Map<String, dynamic>.fromIterable(map.keys,
      key: (k) => k,
      value: (k) {
        if (map[k] != null) {
          if (map[k] is List && (map[k] as List).isNotEmpty && key != k) {
            return (map[k] as List).first as Map;
          }

          if (k == key) {
            if (map[k] is Map) {
              (map[k] as Map).addEntries(
                {childKey: value}.entries,
              );
            } else if (map[k] is List) {
              final list = (map[k] as List);
              if (list.isNotEmpty) {
                if (list.first is Map) {
                  final child = (list.first as Map);
                  child.addEntries({childKey: value}.entries);
                  map[k] = [child];
                }
              } else {
                map[k] = [
                  {childKey: value}
                ];
              }
            }
            return map[k];
          }
          if (!(map[k] is Map)) return map;
          return addDeeply(
            map: map[k],
            key: key,
            childKey: childKey,
            value: value,
            typeNode: typeNode,
          );
        }
        return map[k];
      });
}

Map<String, dynamic> deepSearchByKey(
    {required Map map, required String key, required dynamic value, TypeNode? typeNode}) {
  return Map<String, dynamic>.fromIterable(map.keys,
      key: (k) => k,
      value: (k) {
        if (value is Map) {
          if (map.deepIntersectionByKey(value).isNotEmpty) {
            return map[k];
          }
        }

        if (map[k] != null && map[k] is Map) {
          if (k == key) {
            (map[k] as Map).addAll(value);
            return map[k];
          }
          return deepSearchByKey(map: map[k], key: key, value: value, typeNode: typeNode);
        }
        return map[k];
      });
}

String getTypeName(TypeNode? type) {
  var typeName = '';

  if (type == null) return typeName;
  if (type is NamedTypeNode) {
    typeName = type.name.value;
  } else if (type is ListTypeNode) {
    typeName = (type.type as NamedTypeNode).name.value;
  }
  return typeName;
}

extension TypeNodeExtension on TypeNode? {
  String? get toName {
    if (this == null) {
      return null;
    } else if (this is ListTypeNode) {
      return ((this as ListTypeNode).type as NamedTypeNode).name.value;
    } else if (this is NamedTypeNode) {
      return (this as NamedTypeNode).name.value;
    } else {
      return null;
    }
  }
}
