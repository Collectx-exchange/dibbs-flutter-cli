import 'package:dibbs_flutter_cli/src/modules/graphql_mock_generator/util/utils.dart';
import 'package:flinq/flinq.dart';
import "package:gql/ast.dart" as ast;
import 'package:gql/ast.dart';

import '../object_type_definition_visitor.dart';
import 'util/builders.dart';

class FieldNodeVisitor extends ast.SimpleVisitor<Map<String, dynamic>> {
  late final SchemaVisitor schemaTypeVisitor;

  FieldNodeVisitor(this.schemaTypeVisitor);

  @override
  Map<String, dynamic>? visitFieldNode(ast.FieldNode node,
      {Map<String, dynamic>? map, TypeNode? typeNode}) {
    final objectTypeDefinitionNode = schemaTypeVisitor.objectTypeDefinitionByName(
      name: node.name.value,
      typeNode: typeNode,
    );

    map ??= <String, dynamic>{};

    /// Check if map already contains the node
    if (!keyExists(map, node.name.value)) map.addAll({node.name.value: {}});

    ///Check if node has children
    if (node.selectionSet != null) {
      node.selectionSet!.selections.forEach((element) {
        ast.FieldNode? fieldNode;
        ast.InlineFragmentNode? inlineFragmentNode;
        String typeName = '';

        if (element is ast.InlineFragmentNode) {
          if (element.typeCondition?.on.name.value == "DibbsError") {
            return;
          }
          inlineFragmentNode = element;

          typeName = getTypeName(inlineFragmentNode.typeCondition?.on);

          if (inlineFragmentNode.typeCondition?.on != null) {
            typeNode = inlineFragmentNode.typeCondition?.on;
          }

          inlineFragmentNode.selectionSet.selections.forEach((element) {
            final fieldNode = element as ast.FieldNode;

            final fieldDefinitionNode = objectTypeDefinitionNode.fields
                .firstOrNullWhere((element) => element.name.value == fieldNode.name.value);

            ///Get node type
            if (fieldDefinitionNode != null) {
              typeNode = fieldDefinitionNode.type;
            }

            ///Get type name
            typeName = getTypeName(typeNode);

            ///Check if value is enum
            final enumType = schemaTypeVisitor.enumDefinitionNodes.firstOrNullWhere(
              (element) => element.name.value == typeName,
            );

            if (map![node.name.value] != null && map![node.name.value] is Map) {
              final data = buildMapForFieldNode(
                  fieldNode: fieldNode,
                  typeNode: typeNode,
                  typeName: typeName,
                  enumType: enumType,
                  objectTypeDefinitionNode: objectTypeDefinitionNode);
              (map![node.name.value] as Map).addAll(data);
            } else {
              map = addDeeply(
                map: map!,
                key: node.name.value,
                childKey: fieldNode.name.value,
                value: buildValueForFieldNode(
                  fieldNode: fieldNode,
                  enumType: enumType,
                  typeNode: typeNode,
                ),
                typeNode: typeNode,
              );
            }

            if (fieldNode.selectionSet != null) {
              visitFieldNode(fieldNode, map: map, typeNode: typeNode);
            }
          });
        } else if (element is ast.FieldNode) {
          fieldNode = element;

          final fieldDefinitionNode = objectTypeDefinitionNode.fields
              .firstOrNullWhere((element) => element.name.value == fieldNode?.name.value);

          ///Get node type
          if (fieldDefinitionNode != null) {
            typeNode = fieldDefinitionNode.type;
          }

          ///Get type name
          typeName = getTypeName(typeNode);

          ///Check if value is enum
          final enumType = schemaTypeVisitor.enumDefinitionNodes.firstOrNullWhere(
            (element) => element.name.value == typeName,
          );

          if (map![node.name.value] != null && map![node.name.value] is Map) {
            final data = buildMapForFieldNode(
                fieldNode: fieldNode,
                typeNode: typeNode,
                typeName: typeName,
                enumType: enumType,
                objectTypeDefinitionNode: objectTypeDefinitionNode);
            (map![node.name.value] as Map).addAll(data);
          } else {
            map = addDeeply(
              map: map!,
              key: node.name.value,
              childKey: fieldNode.name.value,
              value: buildValueForFieldNode(
                fieldNode: fieldNode,
                enumType: enumType,
                typeNode: typeNode,
              ),
              typeNode: typeNode,
            );
          }

          if (fieldNode.selectionSet != null) {
            visitFieldNode(fieldNode, map: map, typeNode: typeNode);
          }
        }
      });
    }

    return map;
  }

  Map<String, dynamic>? visitInlineFragmentNod(ast.InlineFragmentNode node,
      {Map<String, dynamic>? map, TypeNode? typeNode}) {
    node.selectionSet.selections.forEach((element) {
      final fieldNode = element as ast.FieldNode;
      if (fieldNode.selectionSet != null) {
        visitFieldNode(fieldNode, map: map, typeNode: typeNode);
      }
    });
    return map;
  }
}

class OperationDefinitionNodeVisitor extends ast.RecursiveVisitor {
  late final String name;

  @override
  void visitOperationDefinitionNode(ast.OperationDefinitionNode node) {
    name = node.name?.value ?? '';
  }
}
