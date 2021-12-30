import 'package:dibbs_flutter_cli/src/modules/start/select_option.dart';

Future<bool> chooseCreateDataSource() async {
  final selected = selectOption(
    'Do you want to create new data source files?',
    ['Yes (default)', 'No'],
  );

  switch (selected) {
    case 0:
      return true;
    case 1:
      return false;
    default:
      return true;
  }
}
