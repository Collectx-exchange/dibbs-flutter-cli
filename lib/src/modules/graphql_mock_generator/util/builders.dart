import 'package:gql/ast.dart';

import 'utils.dart';

Map buildMapForFieldNode({
  required FieldNode? fieldNode,
  required String typeName,
  required TypeNode? typeNode,
  required EnumTypeDefinitionNode? enumType,
  required ObjectTypeDefinitionNode objectTypeDefinitionNode,
}) {
  final key = fieldNode?.name.value;
  final property = fieldNode?.selectionSet != null
      ? typeNode is ListTypeNode
          ? []
          : {}
      : fillPropertyByType(typeName, enumType);
  return {
    key: key == "__typename" ? objectTypeDefinitionNode.name.value : property,
  };
}

dynamic buildValueForFieldNode({
  required FieldNode? fieldNode,
  EnumTypeDefinitionNode? enumType,
  TypeNode? typeNode,
}) {
  return fieldNode?.selectionSet != null
      ? typeNode is ListTypeNode
          ? []
          : {}
      : fillPropertyByType(
          typeNode.toName ?? '',
          enumType,
        );
}

dynamic buildValueForInlineFragmentNode(
    {required InlineFragmentNode? inlineFragmentNode,
    required NamedTypeNode? namedTypeNode,
    EnumTypeDefinitionNode? enumType,
    TypeNode? typeNode}) {
  return inlineFragmentNode?.selectionSet != null
      ? typeNode is ListTypeNode
          ? []
          : {}
      : fillPropertyByType(
          (typeNode as NamedTypeNode).name.value,
          enumType,
        );
}
