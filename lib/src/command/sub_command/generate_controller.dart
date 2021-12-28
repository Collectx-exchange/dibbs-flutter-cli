import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/modules/generate_page.dart';

import '../command_base.dart';

class GenerateControllerSubCommand extends CommandBase {
  @override
  final name = 'controller';
  @override
  final description = 'Creates a controller';

  GenerateControllerSubCommand() {
    argParser.addFlag(
      'notest',
      abbr: 'n',
      negatable: false,
      help: 'no create file test',
    );
  }

  @override
  Future<void> run() async {
    final argResults = this.argResults;
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      throw UsageException('value not passed for a module command', usage);
    } else {
      await controller(
        'app/pages/' + rest.first,
        rest.first,
        'controller',
        haveTest: argResults != null && !argResults['notest'],
      );
    }
    super.run();
  }
}

class GenerateControllerAbbrSubCommand extends GenerateControllerSubCommand {
  @override
  final name = 'c';
}
