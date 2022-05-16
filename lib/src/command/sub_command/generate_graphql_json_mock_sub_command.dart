import 'dart:io';

import 'package:args/command_runner.dart';

import '../../../dibbs_flutter_cli.dart';

class GenerateGraphQLJsonMockSubCommand extends Command {
  @override
  String get description => 'Creates a new json mock for a given graphql document';

  @override
  String get name => 'graph_ql_json_mock';

  GenerateGraphQLJsonMockSubCommand();

  @override
  Future<void> run() async {
    final argResults = this.argResults;
    Directory currentPath = Directory.current;
    if (argResults == null || argResults.rest.isEmpty) {
      throw UsageException('value not passed for GraphQL Json Mock command', usage);
    } else {
      final path = '${currentPath.path}/${argResults.rest.first}';

      await Generate.graphQlJsonMock(docPath: path, path: argResults.rest.first);
    }
  }
}

class GenerateGraphQLJsonMockAbbrSubCommand extends GenerateGraphQLJsonMockSubCommand {
  @override
  final name = 'gql';
}
