import 'dart:convert';
import 'dart:io';

import 'package:dibbs_flutter_cli/src/modules/graphql_mock_generator/operation_type_definition_visitor.dart';
import 'package:dibbs_flutter_cli/src/utils/output_utils.dart' as output;
import 'package:dibbs_flutter_cli/src/utils/utils.dart';
import 'package:recase/recase.dart';

import 'local_save_log.dart';
import 'object_generate.dart';

JsonEncoder encoder = JsonEncoder.withIndent('  ');

Future<void> createFile(
  String path,
  String name,
  String type,
  Function(ObjectGenerate) generator, {
  Function(ObjectGenerate)? generatorTest,
  dynamic additionalInfo,
}) async {
  output.msg('Creating $type...');
  final package = await getNamePackage();

  path = path.replaceAll('\\', '/').replaceAll('\"', '');
  if (path.startsWith('/')) path = path.substring(1);
  if (path.endsWith('/')) path = path.substring(0, path.length - 1);

  path = libPath(path);

  Directory dir;
  if (type == 'repository' || type == 'usecase') {
    dir = Directory(path).parent;
  } else {
    dir = Directory(path);
  }

  final file = File('${dir.path}/${name}_${type.replaceAll("_complete", "")}.dart');
  final fileTest = File(
      '${dir.path.replaceFirst("lib/", "test/")}/${name}_${type.replaceAll("_complete", "")}_test.dart');

  if (file.existsSync()) {
    output.error('already exists a $type $name');
    exit(1);
  }

  if (fileTest.existsSync()) {
    output.error('already exists a $type $name test file');
    exit(1);
  }

  file.createSync(recursive: true);
  LocalSaveLog().add(file.path);
  output.msg('File ${file.path} created');

  file.writeAsStringSync(
    generator(
      ObjectGenerate(
        name: formatName(name),
        type: type,
        packageName: package,
        additionalInfo: additionalInfo,
      ),
    ),
  );

  if (generatorTest != null) {
    fileTest.createSync(recursive: true);
    LocalSaveLog().add(fileTest.path);

    output.msg('File test ${fileTest.path} created');
    if (type == 'widget' || type == 'page') {
      fileTest.writeAsStringSync(
        generatorTest(
          ObjectGenerate(
            name: formatName(name),
            packageName: package,
            import: file.path,
            module: null,
            pathModule: null,
            additionalInfo: additionalInfo,
          ),
        ),
      );
    } else {
      fileTest.writeAsStringSync(
        generatorTest(
          ObjectGenerate(
            name: formatName(name),
            packageName: package,
            import: file.path,
            module: null,
            pathModule: null,
            type: type,
            additionalInfo: additionalInfo,
          ),
        ),
      );
    }
  }

  output.success('$type created');
}

Future<void> createGraphQLJsonMockFile(
    {required String path,
    required String name,
    required String type,
    required Map<String, dynamic> data,
    required Function(ObjectGenerate) generator}) async {
  try {
    final file = File('$path/test/mocks/graphql_json_mocks.dart');
    final formattedName = '${ReCase(name).camelCase}Mock';

    if (!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync(
        generator(
          ObjectGenerate(
            name: formattedName,
            type: type,
            packageName: await getNamePackage(),
            additionalInfo: data,
          ),
        ),
      );
    } else {
      final content = file.readAsStringSync();
      if (content.contains(formattedName)) {
        output.error("A function $formattedName already exists in this file");
        return;
      } else {
        file.writeAsStringSync(
          generator(
            ObjectGenerate(
              name: formattedName,
              type: type,
              packageName: await getNamePackage(),
              additionalInfo: data,
            ),
          ),
          mode: FileMode.append,
        );
        output.success('$name created');
        output.success(encoder.convert(data));
      }
    }
  } on Exception catch (e) {
    output.error(e.toString());
  }
}

Future<void> createFunction(
  String abstractionPath,
  String implementationPath,
  String implementationTestPath,
  String formattedName,
  GraphQLJsonMockEntity entity,
  Function(ObjectGenerate) abstractionGenerator,
  Function(ObjectGenerate) implementationGenerator,
  Function(ObjectGenerate, String name) implementationTestGenerator,
) async {
  output.msg('Creating function ${entity.name}...');
  final package = await getNamePackage();

  final abstractionFile = File(abstractionPath);
  final implementationFile = File(implementationPath);
  final implementationTestFile = File(implementationTestPath);

  if (!abstractionFile.existsSync()) {
    output.error('Data Source Abstraction file not found');
    exit(1);
  }

  if (!implementationFile.existsSync()) {
    output.error('Data Source Implementation file not found');
    exit(1);
  }

  LocalSaveLog().add(abstractionFile.path);
  LocalSaveLog().add(implementationFile.path);

  var abstractionFileContent = abstractionFile.readAsStringSync();
  abstractionFileContent = abstractionFileContent.replaceRange(
    abstractionFileContent.lastIndexOf('}'),
    abstractionFileContent.length,
    '',
  );

  abstractionFile.writeAsStringSync(
    abstractionFileContent +
        abstractionGenerator(
          ObjectGenerate(
            name: ReCase(entity.name).camelCase,
            type: '',
            packageName: package,
            additionalInfo: entity,
          ),
        ),
    mode: FileMode.write,
  );

  var implementationFileContent = implementationFile.readAsStringSync();
  implementationFileContent = implementationFileContent.replaceRange(
    implementationFileContent.lastIndexOf('}'),
    implementationFileContent.length,
    '',
  );

  implementationFile.writeAsStringSync(
    implementationFileContent +
        implementationGenerator(
          ObjectGenerate(
            name: ReCase(entity.name).camelCase,
            type: '',
            packageName: package,
            additionalInfo: entity,
          ),
        ),
    mode: FileMode.write,
  );

  if (implementationTestFile.existsSync()) {
    var implementationTestContent = implementationTestFile.readAsStringSync();
    implementationTestContent = implementationTestContent.replaceRange(
      implementationTestContent.lastIndexOf('}'),
      implementationTestContent.length,
      '',
    );

    implementationTestFile.writeAsStringSync(
      implementationTestContent +
          implementationTestGenerator(
            ObjectGenerate(
              name: ReCase(entity.name).camelCase,
              type: '',
              packageName: package,
              additionalInfo: entity,
            ),
            formattedName,
          ),
      mode: FileMode.write,
    );
  }

  formatFiles([implementationFile, abstractionFile, implementationTestFile]);

  output.success('Function created');
}

void formatFiles(List<File> files) {
  Process.runSync(
      'flutter',
      [
        'format',
        ...files
            .where((file) => file.path.split('.').last == 'dart')
            .map<String>((file) => file.absolute.path)
            .toList()
      ],
      runInShell: true);
}

void createStaticFile(String path, String content) {
  try {
    var file = File(path)
      ..createSync(recursive: true)
      ..writeAsStringSync(content);
    LocalSaveLog().add(file.path);

    output.success('${file.path} created');
  } catch (e) {
    output.error(e);
    exit(1);
  }
}
