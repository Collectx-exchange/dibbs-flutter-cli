import 'package:gql/ast.dart';

class VariableDefinitionNodeVisitor extends RecursiveVisitor {
  late List<VariableDefinitionNode> variables;

  @override
  void visitVariableDefinitionNode(VariableDefinitionNode node) {
    super.visitVariableDefinitionNode(node);
  }
}
