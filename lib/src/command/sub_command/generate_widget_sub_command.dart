import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/modules/generate.dart';

import '../command_base.dart';

class GenerateWidgetSubCommand extends CommandBase {
  @override
  final name = 'widget';
  @override
  final description = 'Creates a widget';

  GenerateWidgetSubCommand() {
    argParser.addFlag('controller',
        abbr: 'c',
        negatable: false,
        help: 'Creates a page with controller file');
  }

  @override
  Future<FutureOr<void>> run() async {
    final argResults = this.argResults;
    if (argResults == null || argResults.rest.isEmpty) {
      throw UsageException('value not passed for a module command', usage);
    } else {
      await Generate.widget(
        argResults.rest.first,
        argResults.rest.first,
        argResults['controller'],
      );
    }
    super.run();
  }
}

class GenerateWidgetAbbrSubCommand extends GenerateWidgetSubCommand {
  @override
  final name = 'w';
}
