import 'package:flinq/flinq.dart';
import 'package:gql/ast.dart';

import 'graphql_mock_generator/util/utils.dart';

/// Visits all operation definition nodes recursively
class SchemaVisitor extends RecursiveVisitor {
  /// Stores all operation definition nodes
  Iterable<ObjectTypeDefinitionNode> typeDefinitionNodes = [];
  Iterable<FieldDefinitionNode> fieldDefinitionNodes = [];
  Iterable<EnumTypeDefinitionNode> enumDefinitionNodes = [];
  Iterable<ScalarTypeDefinitionNode> scalarTypeDefinitionNodes = [];
  Iterable<UnionTypeDefinitionNode> unionTypeDefinitionNodes = [];

  @override
  void visitFieldDefinitionNode(FieldDefinitionNode node) {
    fieldDefinitionNodes = fieldDefinitionNodes.followedBy([node]);
    super.visitFieldDefinitionNode(node);
  }

  @override
  void visitEnumTypeDefinitionNode(EnumTypeDefinitionNode node) {
    enumDefinitionNodes = enumDefinitionNodes.followedBy([node]);
    super.visitEnumTypeDefinitionNode(node);
  }

  @override
  void visitUnionTypeDefinitionNode(UnionTypeDefinitionNode node) {
    unionTypeDefinitionNodes = unionTypeDefinitionNodes.followedBy([node]);
    super.visitUnionTypeDefinitionNode(node);
  }

  @override
  void visitObjectTypeDefinitionNode(
    ObjectTypeDefinitionNode node,
  ) {
    typeDefinitionNodes = typeDefinitionNodes.followedBy([node]);
    super.visitObjectTypeDefinitionNode(node);
  }

  /// Gets operation type definition node by operation name
  ObjectTypeDefinitionNode objectTypeDefinitionByName({required String name, TypeNode? typeNode}) {
    final fieldDefinitionNode = typeNode.toName != null
        ? fieldDefinitionNodes.firstWhere((element) => element.type.toName == typeNode.toName)
        : fieldDefinitionNodes.firstWhere((element) => element.name.value == name);

    final type = fieldDefinitionNode.type;
    final typeName = getTypeName(type);

    final unionTypes =
        unionTypeDefinitionNodes.firstOrNullWhere((element) => element.name.value == typeName);

    if (unionTypes != null && unionTypes.types.isNotEmpty) {
      return typeDefinitionNodes
          .firstWhere((element) => element.name.value == unionTypes.types.first.name.value);
    }

    final typeDefinitionNode = typeDefinitionNodes.firstWhere(
      (element) => element.name.value == typeName,
    );

    return typeDefinitionNode;
  }

  String getFieldDefinitionName(String name) {
    final fieldDefinitionNode =
        fieldDefinitionNodes.firstWhere((element) => element.name.value == name);
    return (fieldDefinitionNode.type as NamedTypeNode).name.value;
  }
}

class VisitDocumentNode extends RecursiveVisitor {
  @override
  void visitDocumentNode(DocumentNode node) {
    super.visitDocumentNode(node);
  }
}

class VisitScalarNode extends SimpleVisitor<ScalarTypeDefinitionNode> {
  @override
  ScalarTypeDefinitionNode? visitScalarTypeDefinitionNode(ScalarTypeDefinitionNode node) {
    return node;
  }
}
