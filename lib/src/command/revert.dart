import 'dart:async';

import 'package:dibbs_flutter_cli/src/utils/local_save_log.dart';

import '../../dibbs_flutter_cli.dart';

class RevertCommand extends CommandBase {
  @override
  final name = 'revert';

  bool argsLength(int n) =>
      argResults != null && argResults!.arguments.length > n;
  @override
  final description = 'Revert last command';

  @override
  FutureOr<void> run() async {
    LocalSaveLog().removeLastLog();
  }
}
