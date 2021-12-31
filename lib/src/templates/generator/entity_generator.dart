import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String entityGenerator(ObjectGenerate objectGenerate) {
  bool haveEquatable = objectGenerate.additionalInfo;
  return '''
import 'package:flutter/foundation.dart';
${haveEquatable ? "import 'package:equatable/equatable.dart';" : ""}

@immutable
class ${objectGenerate.name}Entity ${haveEquatable ? "extends Equatable " : ""}{

  final String param;

  const ${objectGenerate.name}Entity({required this.param});

  ${haveEquatable ? '''
  @override
  List<Object> get props => [param];
  ''' : ""}

  @override
  String toString() => '${objectGenerate.name}Info()'; // TODO Write toString of ${objectGenerate.name}
  
  ${objectGenerate.name}Entity copyWith({String? param}) {
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
