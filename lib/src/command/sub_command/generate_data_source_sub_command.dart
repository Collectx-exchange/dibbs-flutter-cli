import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/modules/generate_data_sources.dart';

import '../command_base.dart';

class GenerateDataSourceSubCommand extends CommandBase {
  @override
  final name = 'data_source';
  @override
  final description = 'Creates the Data Sources files';

  GenerateDataSourceSubCommand() {
    argParser.addFlag('notest',
        abbr: 'n', negatable: false, help: 'no create file test');
  }

  @override
  Future<void> run() async {
    final argResults = this.argResults;
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      throw UsageException('value not passed for Data Source command', usage);
    } else {
      await dataSource(rest.first,
          haveTest: argResults != null && !argResults['notest'], usage: usage);
    }
    super.run();
  }
}

class GenerateDataSourceAbbrSubCommand extends GenerateDataSourceSubCommand {
  @override
  final name = 'ds';
}
