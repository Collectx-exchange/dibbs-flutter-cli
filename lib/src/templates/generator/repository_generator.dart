import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:dibbs_flutter_cli/src/utils/utils.dart';
import 'package:recase/recase.dart';

String repositoryGeneratorModular(ObjectGenerate obj) => '''
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';

class ${obj.name}Repository extends Disposable {

  Future fetchPost(Dio client) async {
    final response =
        await client.get('https://jsonplaceholder.typicode.com/posts/1');
    return response.data;
  }


  //dispose will be called automatically
  @override
  void dispose() {
    
  }

}
  ''';

String repositoryGenerator(ObjectGenerate objectGenerate) {
  return '''
abstract class ${objectGenerate.name}Repository {
  // TODO Write methods of ${objectGenerate.name}Repository
}
''';
}

String repositoryImplGenerator(ObjectGenerate objectGenerate) {
  final nameSnaked = ReCase(objectGenerate.name).snakeCase;
  final haveIndexMapper = existsFile('data/mappers/index.dart');
  final haveLocalDataSource = existsFile(
      "data/data_sources/$nameSnaked/${nameSnaked}_local_data_source.dart");
  final haveRemoteDataSource = existsFile(
      "data/data_sources/$nameSnaked/${nameSnaked}_remote_data_source.dart");
  final importMapper = haveIndexMapper
      ? "import 'package:${objectGenerate.packageName}/data/mappers/index.dart';"
      : '';
  final importLocalDataSource = haveLocalDataSource
      ? "import 'package:${objectGenerate.packageName}/data/data_sources/$nameSnaked/${nameSnaked}_local_data_source.dart';"
      : '';
  final importRemoteDataSource = haveRemoteDataSource
      ? "import 'package:${objectGenerate.packageName}/data/data_sources/$nameSnaked/${nameSnaked}_remote_data_source.dart';"
      : '';
  return '''
import 'package:injectable/injectable.dart';
import 'package:${objectGenerate.packageName}/domain/repositories/$nameSnaked/${nameSnaked}_repository.dart';
$importLocalDataSource
$importRemoteDataSource
$importMapper

@Injectable(as: ${objectGenerate.name}Repository)
class ${objectGenerate.name}RepositoryImpl implements ${objectGenerate.name}Repository {
  ${haveLocalDataSource ? "final ${objectGenerate.name}LocalDataSource _local;" : ""}
  ${haveRemoteDataSource ? "final ${objectGenerate.name}RemoteDataSource _remote;" : ""}

  const ${objectGenerate.name}RepositoryImpl(${haveRemoteDataSource ? "this._remote" : ""}${haveRemoteDataSource && haveLocalDataSource ? ", " : ""}${haveLocalDataSource ? "this._local" : ""});
}
''';
}
