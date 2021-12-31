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

import '../utils/utils.dart';
import 'generate_data_sources.dart';
import 'generate_page.dart';

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
    await _formatFiles;
  }

  static Future<void> widget(
      String path, String name, bool withController) async {
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

    await _formatFiles;
  }

  static Future<void> test(String path) async {
    path = 'app/' + path;

    if (path.contains('.dart')) {
      var entity = File(libPath(path));
      if (!entity.existsSync()) {
        output.error('File $path not exist');
        exit(1);
      }
      await _generateTest(
          entity,
          File(libPath(path)
              .replaceFirst('lib/', 'test/')
              .replaceFirst('.dart', '_test.dart')));
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
              file.path
                  .replaceFirst('lib/', 'test/')
                  .replaceFirst('.dart', '_test.dart'),
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
    final module = file_utils.findModule(entity.path);
    final nameModule = module == null ? null : basename(module.path);

    if (name.contains('_repository.dart')) {
      entityTest.createSync(recursive: true);
      output.msg('File test ${entityTest.path} created');
      entityTest.writeAsStringSync(
        templates.repositoryTestGenerator(
          ObjectGenerate(
            name: formatName(name.replaceFirst('_repository.dart', '')),
            packageName: await getNamePackage(),
            import: entity.path,
            module: nameModule == null ? null : formatName(nameModule),
            pathModule: module?.path,
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
            module: nameModule == null ? null : formatName(nameModule),
            pathModule: module?.path,
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
            module: nameModule == null ? null : formatName(nameModule),
            pathModule: module?.path ?? "",
          ),
        ),
      );
    }
    await _formatFiles;
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
    await _formatFiles;
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
    await _formatFiles;
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
    await _formatFiles;
  }

  static Future<bool> get _formatFiles async {
    final finished = Completer<bool>();
    final process = await Process.start(
      'flutter',
      [
        'format',
        '--line-length 100',
        './lib/app/',
        './lib/core/',
        './lib/main.dart',
        './lib/main_dev.dart',
        './lib/init_core_modules.dart',
        './test'
      ],
      runInShell: true,
    );
    process.stdout.transform(utf8.decoder).listen(
          print,
          cancelOnError: false,
          onDone: () => finished.complete(true),
          onError: (e) => finished.complete(true),
        );
    return finished.future;
  }
}
