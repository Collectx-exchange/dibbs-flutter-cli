import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/utils/file_utils.dart';
import 'package:dibbs_flutter_cli/src/utils/local_save_log.dart';

class CommandBase extends Command {
  String? invocationSuffix;

  @override
  String get invocation {
    final invocationSuffix = this.invocationSuffix;
    return invocationSuffix != null && invocationSuffix.isNotEmpty
        ? "${super.invocation} $invocationSuffix"
        : "${super.invocation}";
  }

  @override
  String get description => "";

  @override
  String get name => "";

  @override
  FutureOr<void> run() {
    formatFiles(LocalSaveLog().lastCreatedFiles(true));
  }
}
