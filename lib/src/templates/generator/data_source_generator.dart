import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:dibbs_flutter_cli/src/utils/utils.dart';

String localDataSourceGenerator(ObjectGenerate objectGenerate) {
  var haveHiveClient = existsFile('data/local/hive_client.dart');
  var importHive = haveHiveClient
      ? "import 'package:${objectGenerate.packageName}/data/local/hive_client.dart';"
      : '';
  return '''
import 'package:injectable/injectable.dart';
$importHive

@injectable
class ${objectGenerate.name}LocalDataSource {
  ${haveHiveClient ? "final HiveClient _hiveClient;" : ""}
  static const String box = "${objectGenerate.name}";

  const ${objectGenerate.name}LocalDataSource(${haveHiveClient ? "this._hiveClient" : ""});
}

''';
}

String remoteDataSourceGenerator(ObjectGenerate objectGenerate) {
  final haveIndexMapper = existsFile('data/mappers/index.dart');
  final importMapper = haveIndexMapper
      ? "import 'package:${objectGenerate.packageName}/data/mappers/index.dart';"
      : '';
  return '''
import 'package:injectable/injectable.dart';
$importMapper

@injectable
class ${objectGenerate.name}RemoteDataSource {
  const ${objectGenerate.name}RemoteDataSource();
}
''';
}
