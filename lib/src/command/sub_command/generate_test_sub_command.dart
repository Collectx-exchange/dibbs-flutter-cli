import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/modules/generate.dart';

import '../command_base.dart';

class GenerateTestSubCommand extends CommandBase {
  @override
  final name = 'test';
  @override
  final description = 'Creates a Test file';

  @override
  Future<void> run() async {
    final argResults = this.argResults;
    if (argResults == null || argResults.rest.isEmpty) {
      throw UsageException('value not passed for a module command', usage);
    } else {
      await Generate.test(argResults.rest.first);
    }
    super.run();
  }
}

class GenerateTestAbbrSubCommand extends GenerateTestSubCommand {
  @override
  final name = 't';
}
