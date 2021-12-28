import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:recase/recase.dart';

String entityGenerator(ObjectGenerate objectGenerate) {
  bool haveEquatable = objectGenerate.additionalInfo;
  return '''
import 'package:flutter/foundation.dart';
${haveEquatable ? "import 'package:equatable/equatable.dart';" : ""}

@immutable
class ${objectGenerate.name}Entity ${haveEquatable ? "extends Equatable " : ""}{

  final String param;

  const ${objectGenerate.name}Entity();

  ${haveEquatable ? '''
  @override
  List<Object> get props => [param];
  ''' : ""}

  @override
  String toString() => '${objectGenerate.name}Info()'; // TODO Write toString of ${objectGenerate.name}
  
  ${objectGenerate.name}Entity copyWith({String param}) {
    return ${objectGenerate.name}Entity(
      param: param?? this.param
    );
  }

  ${!haveEquatable ? '''
  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ${objectGenerate.name}Entity; // TODO Write == operator of ${objectGenerate.name}
  }

  //@override
  //int get hashCode => property.hashCode; // TODO hashCode overrides of ${objectGenerate.name}
  ''' : ""}
}
''';
}

String entityMapperGenerator(ObjectGenerate objectGenerate) {
  final name = objectGenerate.name;
  final nameSnaked = ReCase(name).snakeCase;
  return '''
import 'dart:convert';

import 'package:${objectGenerate.packageName}/domain/entities/$nameSnaked/${nameSnaked}_entity.dart';

extension ${name}Mapper on ${name}Entity{

  Map<String, dynamic> toMap() {
    return {
      "param" : param
    };
  }

  ${name}Entity fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ${name}Entity(
      param: map["param"]
    );
  }

  String toJson() => json.encode(toMap());

  ${name}Entity fromJson(String source) => fromMap(json.decode(source));

}
''';
}
