import 'dart:convert';

import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

JsonEncoder encoder = JsonEncoder.withIndent('  ');

String graphQlJsonMockGenerator(ObjectGenerate obj) => '''

Map<String,dynamic> get ${obj.name} => 
  ${encoder.convert(obj.additionalInfo).replaceAll("\"", "\'")};

''';
