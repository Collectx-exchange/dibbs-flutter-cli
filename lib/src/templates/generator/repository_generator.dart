import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:dibbs_flutter_cli/src/utils/utils.dart';
import 'package:recase/recase.dart';

String repositoryGenerator(ObjectGenerate objectGenerate) {
  return '''
abstract class ${objectGenerate.name}Repository {
  // TODO Write methods of ${objectGenerate.name}Repository
}
''';
}

String repositoryImplGenerator(ObjectGenerate objectGenerate) {
  final nameSnaked = ReCase(objectGenerate.name).snakeCase;
  final haveAdaptersIndex = existsFile('core/data/adapters/index.dart');
  final haveLocalDataSource = existsFile(
      "core/data/data_sources/$nameSnaked/local/${nameSnaked}_local_data_source.dart");
  final haveRemoteDataSource = existsFile(
      "core/data/data_sources/$nameSnaked/remote/${nameSnaked}_remote_data_source.dart");
  final importMapper = haveAdaptersIndex
      ? "import 'package:${objectGenerate.packageName}/core/data/adapters/index.dart';"
      : '';
  final importLocalDataSource = haveLocalDataSource
      ? "import 'package:${objectGenerate.packageName}/core/data/data_sources/$nameSnaked/local/${nameSnaked}_local_data_source.dart';"
      : '';
  final importRemoteDataSource = haveRemoteDataSource
      ? "import 'package:${objectGenerate.packageName}/core/data/data_sources/$nameSnaked/remote/${nameSnaked}_remote_data_source.dart';"
      : '';
  return '''
import 'package:${objectGenerate.packageName}/core/domain/repositories/$nameSnaked/${nameSnaked}_repository.dart';
$importLocalDataSource
$importRemoteDataSource
$importMapper

class ${objectGenerate.name}RepositoryImplementation implements ${objectGenerate.name}Repository {
  ${haveLocalDataSource ? "final ${objectGenerate.name}LocalDataSource _localDataSource;" : ""}
  ${haveRemoteDataSource ? "final ${objectGenerate.name}RemoteDataSource _remoteDataSource;" : ""}

  const ${objectGenerate.name}RepositoryImplementation(${haveRemoteDataSource ? "this._remoteDataSource" : ""}${haveRemoteDataSource && haveLocalDataSource ? ", " : ""}${haveLocalDataSource ? "this._localDataSource" : ""});
}
''';
}
