import 'package:dibbs_flutter_cli/src/modules/graphql_mock_generator/util/utils.dart';
import "package:gql/ast.dart" as ast;
import 'package:gql/ast.dart';

import '../object_type_definition_visitor.dart';
import 'field_node_visitor.dart';
import 'operation_definition_node_visitor.dart';

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
    final arguments = node.variableDefinitions
        .map(
          (e) => Argument(
            name: e.variable.name.value,
            type: e.type.toName ?? '',
            isRequired: e.type.isNonNull,
            mockValue: fillPropertyByType(e.type.toName ?? '', null),
          ),
        )
        .toList();
    data = GraphQLJsonMockEntity(
        name: definitionNodeVisitor.name,
        data: map,
        operationType: definitionNodeVisitor.operationTypeName,
        arguments: arguments);
  }
}

class GraphQLJsonMockEntity {
  final String name;
  final String operationType;
  final Map<String, dynamic> data;
  final List<Argument>? arguments;

  const GraphQLJsonMockEntity({
    required this.name,
    required this.data,
    required this.operationType,
    this.arguments,
  });
}

class Argument {
  final String name;
  final String type;
  final bool isRequired;
  final dynamic mockValue;

  const Argument({
    required this.name,
    required this.type,
    required this.isRequired,
    required this.mockValue,
  });
}
