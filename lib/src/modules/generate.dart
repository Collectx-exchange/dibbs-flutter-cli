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

class Generate {
  static Future<void> module(
    String path,
    bool createCompleteModule,
  ) async {
    var moduleType = createCompleteModule ? 'module_complete' : 'module';
    var templateModular = templates.getXBindingsGenerator;

    path = 'app/' + path;

    await file_utils.createFile(path, moduleType, templateModular);
    if (createCompleteModule) {
      await page(path, false);
    }
  }

  static Future<void> page(String path, bool controllerLess) async {
    path = 'app/' + path;

    await file_utils.createFile(
      '$path',
      'page',
      templates.statelessPageGenerator,
      generatorTest: templates.pageTestGenerator,
    );
    var name = basename(path);
    if (!controllerLess) {
      var type = 'controller';
      await controller('$path/$name', type);
    }
  }

  static Future<void> widget(String path, bool withController) async {
    path = 'app/' + path;

    await file_utils.createFile(
      '$path',
      'widget',
      templates.widgetGenerator,
      generatorTest: templates.widgetTestGenerator,
    );

    var name = basename(path);
    if (withController) {
      var type = 'controller';

      return controller('$path/$name', type, haveTest: true);
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
    String path, {
    bool haveTest = true,
    bool complete = false,
  }) async {
    final name = basename(path);

    if (complete) {
      await dataSource(name);
    }

    await file_utils.createFile(
      'domain/repositories/$name/$name',
      'repository',
      templates.repositoryGeneratorClean,
      generatorTest: null,
    );
    await file_utils.createFile(
      'data/repositories/$name',
      'repository_impl',
      templates.repositoryImplGeneratorClean,
      generatorTest:
          haveTest ? templates.repositoryImplTestGeneratorClean : null,
    );
  }

  static Future<void> controller(String path, String type,
      {bool haveTest = true}) async {
    final template = templates.getXControllerGenerator;
    final testTemplate = templates.getXControllerTestGenerator;

    path = 'app/' + path;

    await file_utils.createFile(
      path,
      type,
      template,
      generatorTest: haveTest ? testTemplate : null,
    );
  }

  static Future<void> dataSource(String name,
      {bool haveTest = true, String usage = ''}) async {
    var dataSource = await chooseDataSource();

    if (dataSource == DataSource.onlyLocal) {
      await file_utils.createFile(
        'data/data_sources/$name',
        'local_data_source',
        templates.localDataSourceGenerator,
        generatorTest: haveTest ? templates.localDataSourceGeneratorTest : null,
      );
    } else if (dataSource == DataSource.onlyRemote) {
      await file_utils.createFile(
        'data/data_sources/$name',
        'remote_data_source',
        templates.remoteDataSourceGenerator,
        generatorTest:
            haveTest ? templates.remoteDataSourceGeneratorTest : null,
      );
    } else {
      await file_utils.createFile(
        'data/data_sources/$name',
        'local_data_source',
        templates.localDataSourceGenerator,
        generatorTest: haveTest ? templates.localDataSourceGeneratorTest : null,
      );
      await file_utils.createFile(
        'data/data_sources/$name',
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
      'entity',
      templates.entityGenerator,
      generatorTest: null,
      additionalInfo: haveEquatable,
    );
    await file_utils.createFile(
      'data/mappers/$name',
      'mapper',
      templates.entityMapperGenerator,
      generatorTest: null,
      additionalInfo: haveEquatable,
    );
  }

  static Future<void> useCase(String name, {String usage = ''}) async {
    await file_utils.createFile(
      'domain/usecases/$name',
      'use_case',
      templates.useCaseGenerator,
      generatorTest: templates.useCaseTestGenerator,
    );
  }
}
