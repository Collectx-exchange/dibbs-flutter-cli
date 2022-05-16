import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import "package:gql/ast.dart" as ast;
import 'package:gql/ast.dart';
import "package:gql/language.dart" as lang;

import '../object_type_definition_visitor.dart';
import 'operation_type_definition_visitor.dart';

void main() {
  generateGraphQLJsonMock(
      docPath:
          '/Users/denisviana/AndroidStudioProjects/dibbs_flutter_cli/lib/feature_toggle.graphql');
}

Future<GraphQLJsonMockEntity> generateGraphQLJsonMock({required String docPath}) async {
  final libPath = docPath.substring(0, docPath.indexOf('lib/'));
  final dummyGlob = Glob('lib/schema.graphql');
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
  } on Exception catch (_) {
    throw Exception("Failed when trying to read the $docPath file");
  }

  final dummyDoc = lang.parseString(
    r"""
      query MarketSellPresets(
        $pair: StringUpperCase!
        $customPercentageInput: Float
        $maxCardAmount: Float!
      ) {
        market_sell_presets(
          pair: $pair
          custom_percentage_input: $customPercentageInput
          max_card_amount: $maxCardAmount
        ) {
          __typename
          ... on EstimateSellArray {
            __typename
            array {
              average_card_price_sold
              card_fraction_sold
              estimate_row_id
              fee
              inventory_percentage_sold
              is_invalid
              post_sale_card_price
              price_change
              price_impact
              usd_amount_received
            }
          }
          ... on DibbsError {
            __typename
            error_code
          }
        }
      }
    """,
  );

  final schemaTypeVisitor = SchemaVisitor();
  final operationTypeVisitor = OperationTypeDefinitionVisitor(schemaTypeVisitor);
  schema.first.accept(schemaTypeVisitor);
  doc.first.accept(operationTypeVisitor);
  //dummyDoc.accept(operationTypeVisitor);
  return operationTypeVisitor.data;
}
