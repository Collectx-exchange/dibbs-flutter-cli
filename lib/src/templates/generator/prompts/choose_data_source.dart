import 'package:dibbs_flutter_cli/src/enums/data_source_enum.dart';
import 'package:dibbs_flutter_cli/src/modules/start/select_option.dart';

Future<DataSource> chooseDataSource() async {

  final selected = selectOption(
    'What kind of data source do you want to generate?',
    ['Local and Remote (default)', 'Only Local', 'Only Remote'],
  );

  switch (selected) {
    case 0:
      return DataSource.localAndRemote;
    case 1:
      return DataSource.onlyLocal;
    case 2:
      return DataSource.onlyRemote;
    default:
      return DataSource.localAndRemote;
  }
}
