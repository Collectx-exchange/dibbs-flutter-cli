import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:dibbs_flutter_cli/src/utils/utils.dart';
import 'package:recase/recase.dart';

String repositoryTestGenerator(ObjectGenerate obj) => '''
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:${obj.packageName}/${obj.import?.replaceFirst("lib/", "").replaceAll("\\", "/")}';

class MockClient extends Mock implements Dio {}

void main() {
  ${obj.name}Repository repository;
 // MockClient client;

  setUp(() {
  // repository = ${obj.name}Repository();
  // client = MockClient();
  });

  group('${obj.name}Repository Test', () {
 //  test("First Test", () {
 //    expect(repository, isInstanceOf<${obj.name}Repository>());
 //  });

   test('returns a Post if the http call completes successfully', () async {
 //    when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
 //        .thenAnswer((_) async =>
 //            Response(data: {'title': 'Test'}, statusCode: 200));
 //    Map<String, dynamic> data = await repository.fetchPost(client);
 //    expect(data['title'], 'Test');
   });

  });
}
  ''';

String repositoryImplTestGenerator(ObjectGenerate objectGenerate) {
  final nameSnaked = ReCase(objectGenerate.name).snakeCase;

  final hasLocalDataSource = existsFile(
      "core/data/data_sources/$nameSnaked/local/${nameSnaked}_local_data_source.dart");
  final hasRemoteDataSource = existsFile(
      "core/data/data_sources/$nameSnaked/remote/${nameSnaked}_remote_data_source.dart");

  return '''
import 'package:${objectGenerate.packageName}/core/data/helpers/app_logger.dart';
import 'package:${objectGenerate.packageName}/core/data/model/app_exception.dart';
import 'package:${objectGenerate.packageName}/core/domain/managers/user_manager.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:${objectGenerate.packageName}/${objectGenerate.import?.replaceAll("lib/", "")}';

import '../../../../mocks/index.dart';
import '../../../../setup_repositories.dart';

${hasRemoteDataSource ? 'class ${objectGenerate.name}RemoteDataSourceSpy extends Mock implements ${objectGenerate.name}RemoteDataSource {}' : ''}

${hasLocalDataSource ? 'class ${objectGenerate.name}LocalDataSourceSpy extends Mock implements ${objectGenerate.name}LocalDataSource {}' : ''}

class UserManagerMock extends Mock implements UserManager {}

void main() {

  ${hasRemoteDataSource ? 'final remoteDataSource = ${objectGenerate.name}RemoteDataSourceSpy();' : ''}
  ${hasLocalDataSource ? 'final localDataSource = ${objectGenerate.name}LocalDataSourceSpy();' : ''}
  ${objectGenerate.name}RepositoryImplementation repository;

  setUp(() {
    initialRepositoriesSetup;
    repository = ${objectGenerate.name}RepositoryImplementation(${hasRemoteDataSource ? 'remoteDataSource' : ''}${hasRemoteDataSource && hasLocalDataSource ? ',' : ''} ${hasLocalDataSource ? 'localDataSource' : ''});
  });

  test('${objectGenerate.name} repository implementation test', () async {
    //arrange
    
    //act
    
    //assert
  });
}

''';
}
