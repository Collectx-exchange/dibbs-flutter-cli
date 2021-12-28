import 'dart:async';

import '../../dibbs_flutter_cli.dart';

class UpgradeCommand extends CommandBase {
  @override
  final name = 'upgrade';
  @override
  final description = 'Upgrade the Dibbs Flutter CLI version';

  @override
  FutureOr<void> run() {
    upgrade();
  }
}
