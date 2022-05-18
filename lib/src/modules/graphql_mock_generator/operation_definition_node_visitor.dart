import 'package:gql/ast.dart';

class OperationDefinitionNodeVisitor extends RecursiveVisitor {
  late final String name;
  late final String operationTypeName;

  @override
  void visitOperationDefinitionNode(OperationDefinitionNode node) {
    name = node.name?.value ?? '';
    operationTypeName = node.type.name;
  }
}
