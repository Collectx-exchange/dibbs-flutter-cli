import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:recase/recase.dart';

String localDataSourceGenerator(ObjectGenerate objectGenerate) {
  return '''
abstract class ${objectGenerate.name}LocalDataSource {
  // TODO Write methods of ${objectGenerate.name}DataSource
}
''';
}

String localDataSourceImplementationGenerator(ObjectGenerate objectGenerate) {
  final nameSnaked = ReCase(objectGenerate.name).snakeCase;

  return '''
import 'package:${objectGenerate.packageName}/core/data/helpers/storage_keys.dart';
import 'package:${objectGenerate.packageName}/core/local/dibbs_preferences.dart';
import '${nameSnaked}_local_data_source.dart';

class ${objectGenerate.name}LocalDataSourceImplementation implements ${objectGenerate.name}LocalDataSource {

  final SecureLocalStorage _localStorage;
  final DibbsPreferences _preferences;

  ${objectGenerate.packageName}LocalDataSourceImplementation(
    this._localStorage,
    this._preferences,
  );
}
''';
}

String remoteDataSourceGenerator(ObjectGenerate objectGenerate) {
  return '''
abstract class ${objectGenerate.name}RemoteDataSource {
  // TODO Write methods of ${objectGenerate.name}DataSource
}
''';
}

String remoteDataSourceImplementationGenerator(ObjectGenerate objectGenerate) {
  final nameSnaked = ReCase(objectGenerate.name).snakeCase;

  return '''

import 'package:graphql/client.dart';
import '${nameSnaked}_remote_data_source.dart';

class ${objectGenerate.name}RemoteDataSourceImplementation implements ${objectGenerate.name}RemoteDataSource {

  final GraphQLClient _graphQLClient;

  ${objectGenerate.name}RemoteDataSourceImplementation(this._graphQLClient);
}
''';
}
