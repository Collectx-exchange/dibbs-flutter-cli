import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dibbs_flutter_cli/src/enums/create_use_case_enums.dart';
import 'package:dibbs_flutter_cli/src/templates/generator/prompts/create_data_source.dart';
import 'package:dibbs_flutter_cli/src/templates/generator/prompts/create_use_case_prompt.dart';
import 'package:dibbs_flutter_cli/src/templates/templates.dart' as templates;
import 'package:dibbs_flutter_cli/src/utils/file_utils.dart' as file_utils;
import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:dibbs_flutter_cli/src/utils/output_utils.dart' as output;
import 'package:dibbs_flutter_cli/src/utils/utils.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';

import '../utils/utils.dart';
import 'generate_data_sources.dart';
import 'generate_page.dart';
import 'graphql_mock_generator/generate_graphql_json_mocks.dart';

JsonEncoder encoder = JsonEncoder.withIndent('  ');

class Generate {
  static Future<void> feature(
    String name,
    bool createCompleteFeature,
  ) async {
    var featureType = createCompleteFeature ? 'feature_complete' : 'feature';
    var templateGetXBindings = templates.getXBindingsGenerator;

    final path = 'app/' + name;

    await file_utils.createFile(path, name, featureType, templateGetXBindings);
    if (createCompleteFeature) {
      await page(name);
    }
  }

  static Future<void> widget(String path, String name, bool withController) async {
    final path = 'app/' + name;

    await file_utils.createFile(
      '$path',
      name,
      'widget',
      templates.widgetGenerator,
      generatorTest: null,
    );

    if (withController) {
      var type = 'controller';

      await controller('$path/$name', name, type, haveTest: true);
    }
  }

  static Future<void> test(String path) async {
    path = 'app/' + path;

    if (path.contains('.dart')) {
      var entity = File(libPath(path));
      if (!entity.existsSync()) {
        output.error('File $path not exist');
        exit(1);
      }
      await _generateTest(entity,
          File(libPath(path).replaceFirst('lib/', 'test/').replaceFirst('.dart', '_test.dart')));
    } else {
      var entity = Directory(libPath(path));
      if (!entity.existsSync()) {
        output.error('Directory $path not exist');
        exit(1);
      }

      for (var file in entity.listSync()) {
        if (file is File) {
          await _generateTest(
            file,
            File(
              file.path.replaceFirst('lib/', 'test/').replaceFirst('.dart', '_test.dart'),
            ),
          );
        }
      }
    }
  }

  static Future<void> _generateTest(File entity, File entityTest) async {
    if (entityTest.existsSync()) {
      output.error('Test already exists');
      exit(1);
    }

    final name = basename(entity.path);

    if (name.contains('_repository.dart')) {
      entityTest.createSync(recursive: true);
      output.msg('File test ${entityTest.path} created');
      entityTest.writeAsStringSync(
        templates.repositoryTestGenerator(
          ObjectGenerate(
            name: formatName(name.replaceFirst('_repository.dart', '')),
            packageName: await getNamePackage(),
            import: entity.path,
            module: null,
            pathModule: null,
          ),
        ),
      );
    } else if (name.contains('_page.dart')) {
      entityTest.createSync(recursive: true);
      output.msg('File test ${entityTest.path} created');
      entityTest.writeAsStringSync(
        templates.pageTestGenerator(
          ObjectGenerate(
            name: formatName(name.replaceFirst('_page.dart', '')),
            packageName: await getNamePackage(),
            import: entity.path,
            module: null,
            pathModule: null,
          ),
        ),
      );
    } else if (name.contains('_controller.dart')) {
      entityTest.createSync(recursive: true);
      output.msg('File test ${entityTest.path} created');
      entityTest.writeAsStringSync(
        templates.getXControllerTestGenerator(
          ObjectGenerate(
            name: formatName(name.replaceFirst('_controller.dart', '')),
            type: 'controller',
            packageName: await getNamePackage(),
            import: entity.path,
            module: null,
            pathModule: null,
          ),
        ),
      );
    }
  }

  static Future<void> repository(
    String path,
    String name, {
    bool haveTest = true,
    bool complete = false,
  }) async {
    final createDataSource = await chooseCreateDataSource();
    if (createDataSource) {
      await dataSource(name);
    }

    await file_utils.createFile(
      'core/domain/repositories/$name/$name',
      name,
      'repository',
      templates.repositoryGenerator,
      generatorTest: null,
    );
    await file_utils.createFile(
      'core/data/repositories/$name',
      name,
      'repository_implementation',
      templates.repositoryImplGenerator,
      generatorTest: haveTest ? templates.repositoryImplTestGenerator : null,
    );
  }

  static Future<void> entity(String name, {String usage = ''}) async {
    final haveEquatable = await checkDependency('equatable');
    await file_utils.createFile(
      'core/domain/entity/$name',
      name,
      'entity',
      templates.entityGenerator,
      generatorTest: null,
      additionalInfo: haveEquatable,
    );
  }

  static Future<void> useCase(String name, {String usage = ''}) async {
    final createUseCase = await createUseCasePrompt;

    switch (createUseCase) {
      case UseCaseParams.withParams:
        await file_utils.createFile(
          'core/domain/use_cases/$name',
          name,
          'use_case',
          templates.useCaseWithParamsGenerator,
          generatorTest: templates.useCaseTestGenerator,
        );
        break;
      case UseCaseParams.withoutParams:
        await file_utils.createFile(
          'core/domain/use_cases/$name',
          name,
          'use_case',
          templates.useCaseGenerator,
          generatorTest: templates.useCaseTestGenerator,
        );
        break;
    }
  }

  static Future<void> graphQlJsonMock({required String docPath, required String path}) async {
    output.msg('Creating GraphQL Json Mock for file $docPath');
    try {
      final rootPath = docPath.substring(0, docPath.indexOf('/lib'));
      mainDirectory = rootPath;
      final entity = await generateGraphQLJsonMock(docPath: docPath);

      final file = File('$rootPath/test/mocks/graphql_json_mocks.dart');
      final name = '${ReCase(entity.name).camelCase}Mock';

      if (!file.existsSync()) {
        file.createSync(recursive: true);
        file.writeAsStringSync(
          templates.graphQlJsonMockGenerator(
            ObjectGenerate(
              name: name,
              type: 'mock',
              packageName: await getNamePackage(),
              additionalInfo: entity.data,
            ),
          ),
        );
      } else {
        final content = file.readAsStringSync();
        if (content.contains(name)) {
          output.error("A function $name already exists in this file");
          return;
        } else {
          file.writeAsStringSync(
            templates.graphQlJsonMockGenerator(
              ObjectGenerate(
                name: name,
                type: 'mock',
                packageName: await getNamePackage(),
                additionalInfo: entity.data,
              ),
            ),
            mode: FileMode.append,
          );
          output.success('$name created');
          output.success(encoder.convert(entity.data));
        }
      }
    } on Exception catch (e) {
      output.error(e.toString());
    }
  }
}

void main() async {
  final docPath =
      '/Users/denisviana/AndroidStudioProjects/dibbs_flutter_cli/lib/feature_toggle.graphql';
  output.msg('Creating GraphQL Json Mock for file $docPath');
  try {
    final rootPath = docPath.substring(0, docPath.indexOf('/lib'));
    mainDirectory = rootPath;
    final entity = await generateGraphQLJsonMock(docPath: docPath);

    final file = File('$rootPath/test/mocks/graphql_json_mocks.dart');

    if (!file.existsSync()) {
      final name = '${ReCase(entity.name).camelCase}Mock';
      file.createSync(recursive: true);
      file.writeAsStringSync(
        templates.graphQlJsonMockGenerator(
          ObjectGenerate(
            name: name,
            type: 'mock',
            packageName: await getNamePackage(),
            additionalInfo: entity.data,
          ),
        ),
      );
    } else {
      final content = file.readAsStringSync();
      final name = '${ReCase(entity.name).camelCase}Mock';
      if (content.contains(name)) {
        output.error("A function $name already exists in this file");
        return;
      } else {
        file.writeAsStringSync(
          templates.graphQlJsonMockGenerator(
            ObjectGenerate(
              name: name,
              type: 'mock',
              packageName: await getNamePackage(),
              additionalInfo: entity.data,
            ),
          ),
          mode: FileMode.append,
        );
      }
    }
  } on Exception catch (e) {
    output.error(e.toString());
  }
}
