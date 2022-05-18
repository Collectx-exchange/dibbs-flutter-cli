import 'package:dibbs_flutter_cli/src/modules/graphql_mock_generator/operation_type_definition_visitor.dart';
import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:recase/recase.dart';

import '../../modules/graphql_mock_generator/util/utils.dart';

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
import '${nameSnaked}_local_data_source.dart';

class ${objectGenerate.name}LocalDataSourceImplementation implements ${objectGenerate.name}LocalDataSource {

  ${objectGenerate.name}LocalDataSourceImplementation();
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

String dataSourceAbstractionCallGenerator(ObjectGenerate objectGenerate) {
  final name = objectGenerate.name.camelCase;
  final graphQlJsonMockEntity = objectGenerate.additionalInfo as GraphQLJsonMockEntity;
  final arguments = graphQlJsonMockEntity.arguments?.map((argument) {
        final argumentType = dartPropertyName(argument.type);
        final argumentName = argument.name.camelCase;
        return '${argument.isRequired ? 'required $argumentType' : '$argumentType?'} $argumentName';
      }).toList() ??
      [];

  return '''
  
  Future<QueryResult> $name({${arguments.join(',')},});
}
  ''';
}

String dataSourceImplementationCallGenerator(ObjectGenerate objectGenerate) {
  final name = objectGenerate.name.camelCase;
  final graphQlJsonMockEntity = objectGenerate.additionalInfo as GraphQLJsonMockEntity;
  final operationType = graphQlJsonMockEntity.operationType.toLowerCase();
  final functionArguments = graphQlJsonMockEntity.arguments?.map((argument) {
        final argumentType = dartPropertyName(argument.type);
        final argumentName = ReCase(argument.name).camelCase;
        return '${argument.isRequired ? 'required $argumentType' : '$argumentType?'} $argumentName';
      }).toList() ??
      [];
  final operationArguments = graphQlJsonMockEntity.arguments?.map((argument) {
        final argumentName = ReCase(argument.name).camelCase;
        return ' $argumentName: $argumentName';
      }).toList() ??
      [];

  final operationClassName = '${name.pascalCase}${operationType.pascalCase}';
  final argumentsClassName = '${name.pascalCase}Arguments';
  final argumentsClassSignature =
      '$argumentsClassName(${operationArguments.isNotEmpty ? '${operationArguments.join(',')},' : ''})';

  return '''
  
  @override
  Future<QueryResult> $name({${functionArguments.join(',')}}){
    final $operationType = $operationClassName(${operationArguments.isNotEmpty ? 'variables: $argumentsClassSignature,' : ''});
    return _graphQLClient.${operationType == 'mutation' ? 'mutate' : operationType.toLowerCase()}(
      ${operationType.pascalCase}Options(document: ${operationType.toLowerCase()}.document, variables: ${operationType.toLowerCase()}.getVariablesMap()),
    );
  }
}
  ''';
}

String dataSourceCallUnitTest(ObjectGenerate objectGenerate, String dataSourceName) {
  final name = objectGenerate.name.camelCase;
  final graphQlJsonMockEntity = objectGenerate.additionalInfo as GraphQLJsonMockEntity;
  final operationType = graphQlJsonMockEntity.operationType.toLowerCase();
  var operationArguments = '';
  graphQlJsonMockEntity.arguments?.forEach((argument) {
    final argumentName = ReCase(argument.name).camelCase;
    operationArguments += "$argumentName: ${fillDartPropertyByType(argument.type)}, ";
  });
  return '''
  
  test('$name should return a QueryResult', () async {
    //arrange
    when(() => graphQlClient.${operationType == 'mutation' ? 'mutate' : operationType.toLowerCase()}(any())).thenAnswer((_) async => successfulResult);
    //act
    final result = await ${dataSourceName.camelCase}.${name.camelCase}($operationArguments);
    //assert
    expect(result, isA<QueryResult>());
  });
    
}
  ''';
}
