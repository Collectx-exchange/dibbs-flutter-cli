import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/modules/generate_page.dart';

import '../command_base.dart';

class GeneratePageSubCommand extends CommandBase {
  @override
  final name = 'page';
  @override
  final description = 'Creates a page';

  /* GeneratePageSubCommand() {
    argParser.addFlag('controller',
        abbr: 'c',
        negatable: false,
        help: 'Creates a page without controller file');
    argParser.addFlag(
      'i18n',
      abbr: 'i',
      negatable: false,
      help: 'Creates a page without i18n file',
    );
  }*/

  @override
  Future<FutureOr<void>> run() async {
    final argResults = this.argResults;
    final rest = argResults?.rest;
    if (argResults == null || rest == null || rest.isEmpty) {
      throw UsageException('value not passed for a module command', usage);
    } else {
      await page(
        rest.first,
      );
    }
    super.run();
  }
}

class GeneratePageAbbrSubCommand extends GeneratePageSubCommand {
  @override
  final name = 'p';
}
