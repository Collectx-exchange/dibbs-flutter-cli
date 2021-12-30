import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String localDataSourceGeneratorTest(ObjectGenerate objectGenerate) => '''
import 'package:${objectGenerate.packageName}/${objectGenerate.import?.replaceAll("lib/", "")}';
import 'package:${objectGenerate.packageName}/di/di.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ${objectGenerate.name}LocalDataSource dataSource;

  setUp(() {
    configureInjection();
    dataSource = getIt();
  });

  test('${objectGenerate.name} local_data_source test', () async {
    
  });
}
''';

String remoteDataSourceGeneratorTest(ObjectGenerate objectGenerate) => '''
import 'package:${objectGenerate.packageName}/${objectGenerate.import?.replaceAll("lib/", "")}';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../mocks/index.dart';

class GraphQLClientMock extends Mock implements GraphQLClient {}

class QueryOptionsMock extends Fake implements QueryOptions {}

class MutationOptionsMock extends Fake implements MutationOptions {}

void main() {
  late ${objectGenerate.name}RemoteDataSourceImplementation remoteDataSource;
  final graphQlClient = GraphQLClientMock();

  setUp(() {
    remoteDataSource = ${objectGenerate.name}RemoteDataSourceImplementation(graphQlClient);
    registerFallbackValue(QueryOptionsMock());
    registerFallbackValue(MutationOptionsMock());
  });

  final successfulResult = QueryResult(
    data: {'test': 'test'},
    source: QueryResultSource.network,
  );

  final failedResult = QueryResult(
    source: QueryResultSource.network,
    exception: OperationException(),
  );

  test('${objectGenerate.name} remote_data_source test', () async {
    
  });
}
''';
