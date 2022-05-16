import "package:gql/ast.dart" as ast;
import 'package:gql/ast.dart';

import '../object_type_definition_visitor.dart';
import 'field_node_visitor.dart';

class OperationTypeDefinitionVisitor extends RecursiveVisitor {
  late final SchemaVisitor schemaTypeVisitor;
  late final ast.FieldNode node;

  OperationTypeDefinitionVisitor(this.schemaTypeVisitor);

  late final GraphQLJsonMockEntity data;

  @override
  void visitOperationDefinitionNode(ast.OperationDefinitionNode node) {
    super.visitOperationDefinitionNode(node);
    this.node = node.selectionSet.selections.first as ast.FieldNode;
    final fieldVisitor = FieldNodeVisitor(schemaTypeVisitor);
    final definitionNodeVisitor = OperationDefinitionNodeVisitor();
    node.accept(definitionNodeVisitor);
    final map = fieldVisitor.visitFieldNode(this.node) ?? {};
    data = GraphQLJsonMockEntity(name: definitionNodeVisitor.name, data: map);
  }
}

class GraphQLJsonMockEntity {
  final String name;
  final Map<String, dynamic> data;

  const GraphQLJsonMockEntity({required this.name, required this.data});
}
