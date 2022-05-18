import 'dart:convert';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import "package:gql/ast.dart" as ast;
import 'package:gql/ast.dart';
import "package:gql/language.dart" as lang;

import '../object_type_definition_visitor.dart';
import 'operation_type_definition_visitor.dart';

JsonEncoder encoder = JsonEncoder.withIndent('  ');

void main() async {
  final entity = await generateGraphQLJsonMock(docPath: 'lib/asset_detail.graphql');
  print(encoder.convert(entity.data));
}

Future<GraphQLJsonMockEntity> generateGraphQLJsonMock({required String docPath}) async {
  final libPath = docPath.substring(0, docPath.indexOf('lib/'));
  final dummyGlob = Glob('../schema.graphql');
  final glob = Glob('$libPath/lib/graphql/schema.graphql');

  final List<DocumentNode> schema;

  try {
    schema = await glob
        .list()
        .asyncMap(
          (event) async => lang.parseString(
            await File(event.path).readAsString(),
            url: event.path,
          ),
        )
        .toList();
  } on Exception catch (_) {
    throw Exception("Failed when trying to read the schema.graphql file");
  }

  final List<ast.DocumentNode> doc;
  final List<ast.DocumentNode> dummyDoc;

  try {
    doc = await Glob(docPath)
        .list()
        .asyncMap(
          (event) async => lang.parseString(
            await File(event.path).readAsString(),
            url: event.path,
          ),
        )
        .toList();

    /*dummyDoc = await Glob('lib/asset_detail.graphql')
        .list()
        .asyncMap(
          (event) async => lang.parseString(
            await File(event.path).readAsString(),
            url: event.path,
          ),
        )
        .toList();*/
  } on Exception catch (_) {
    throw Exception("Failed when trying to read the $docPath file");
  }

  final schemaTypeVisitor = SchemaVisitor();
  final operationTypeVisitor = OperationTypeDefinitionVisitor(schemaTypeVisitor);
  schema.first.accept(schemaTypeVisitor);
  doc.first.accept(operationTypeVisitor);
  //dummyDoc.first.accept(operationTypeVisitor);
  return operationTypeVisitor.data;
}
