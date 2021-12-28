import 'dart:io';

import 'package:dibbs_flutter_cli/src/enums/data_source_enum.dart';
import 'package:dibbs_flutter_cli/src/templates/generator/prompts/choose_data_source.dart';
import 'package:dibbs_flutter_cli/src/templates/templates.dart' as templates;
import 'package:dibbs_flutter_cli/src/utils/file_utils.dart' as file_utils;
import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:dibbs_flutter_cli/src/utils/output_utils.dart' as output;
import 'package:dibbs_flutter_cli/src/utils/utils.dart';
import 'package:path/path.dart';

import '../utils/utils.dart';
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
  }

  static Future<void> widget(
      String path, String name, bool withController) async {
    final path = 'app/' + name;

    await file_utils.createFile(
      '$path',
      name,
      'widget',
      templates.widgetGenerator,
      generatorTest: templates.widgetTestGenerator,
    );

    if (withController) {
      var type = 'controller';

      return controller('$path/$name', name, type, haveTest: true);
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
      return _generateTest(
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
  }

  static Future<void> repository(
    String path,
    String name, {
    bool haveTest = true,
    bool complete = false,
  }) async {
    if (complete) {
      await dataSource(name);
    }

    await file_utils.createFile(
      'domain/repositories/$name/$name',
      name,
      'repository',
      templates.repositoryGeneratorClean,
      generatorTest: null,
    );
    await file_utils.createFile(
      'data/repositories/$name',
      name,
      'repository_impl',
      templates.repositoryImplGeneratorClean,
      generatorTest:
          haveTest ? templates.repositoryImplTestGeneratorClean : null,
    );
  }

  static Future<void> dataSource(String name,
      {bool haveTest = true, String usage = ''}) async {
    final dataSource = await chooseDataSource();

    if (dataSource == DataSource.onlyLocal) {
      await file_utils.createFile(
        'data/data_sources/$name',
        name,
        'local_data_source',
        templates.localDataSourceGenerator,
        generatorTest: haveTest ? templates.localDataSourceGeneratorTest : null,
      );
    } else if (dataSource == DataSource.onlyRemote) {
      await file_utils.createFile(
        'data/data_sources/$name',
        name,
        'remote_data_source',
        templates.remoteDataSourceGenerator,
        generatorTest:
            haveTest ? templates.remoteDataSourceGeneratorTest : null,
      );
    } else {
      await file_utils.createFile(
        'data/data_sources/$name',
        name,
        'local_data_source',
        templates.localDataSourceGenerator,
        generatorTest: haveTest ? templates.localDataSourceGeneratorTest : null,
      );
      await file_utils.createFile(
        'data/data_sources/$name',
        name,
        'remote_data_source',
        templates.remoteDataSourceGenerator,
        generatorTest:
            haveTest ? templates.remoteDataSourceGeneratorTest : null,
      );
    }
  }

  static Future<void> entity(String name, {String usage = ''}) async {
    final haveEquatable = await checkDependency('equatable');
    await file_utils.createFile(
      'domain/entities/$name',
      name,
      'entity',
      templates.entityGenerator,
      generatorTest: null,
      additionalInfo: haveEquatable,
    );
    await file_utils.createFile(
      'data/mappers/$name',
      name,
      'mapper',
      templates.entityMapperGenerator,
      generatorTest: null,
      additionalInfo: haveEquatable,
    );
  }

  static Future<void> useCase(String name, {String usage = ''}) async {
    await file_utils.createFile(
      'domain/usecases/$name',
      name,
      'use_case',
      templates.useCaseGenerator,
      generatorTest: templates.useCaseTestGenerator,
    );
  }
}
