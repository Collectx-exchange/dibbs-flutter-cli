import 'package:dibbs_flutter_cli/src/modules/start/select_option.dart';

String createDataSourceCallPrompt() {
  final value = typeValue(
    'Do you want to generate a new data source call? If so, type the data source name followed by its type like: "name_remote" or "name_local"',
  );
  return value;
}
