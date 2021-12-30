import 'package:dibbs_flutter_cli/src/enums/data_source_enum.dart';
import 'package:dibbs_flutter_cli/src/templates/generator/prompts/choose_data_source.dart';
import 'package:dibbs_flutter_cli/src/templates/templates.dart' as templates;
import 'package:dibbs_flutter_cli/src/utils/file_utils.dart' as file_utils;

Future<void> dataSource(String name,
    {bool haveTest = true, String usage = ''}) async {
  final dataSource = await chooseDataSource();

  if (dataSource == DataSource.onlyLocal) {
    await _generateLocalDataSource(name, haveTest);
  } else if (dataSource == DataSource.onlyRemote) {
    await _generateRemoteDataSource(name, haveTest);
  } else {
    await _generateLocalDataSource(name, haveTest);
    await _generateRemoteDataSource(name, haveTest);
  }
}

Future _generateRemoteDataSource(String name, bool haveTest) async {
  await file_utils.createFile(
    'core/data/data_sources/$name/remote',
    name,
    'remote_data_source_implementation',
    templates.remoteDataSourceImplementationGenerator,
    generatorTest: null,
  );
  await file_utils.createFile(
    'core/data/data_sources/$name/remote',
    name,
    'remote_data_source',
    templates.remoteDataSourceGenerator,
    generatorTest: haveTest ? templates.remoteDataSourceGeneratorTest : null,
  );
}

Future _generateLocalDataSource(String name, bool haveTest) async {
  await file_utils.createFile(
    'core/data/data_sources/$name/local',
    name,
    'local_data_source',
    templates.localDataSourceGenerator,
    generatorTest: null,
  );
  await file_utils.createFile(
    'core/data/data_sources/$name/local',
    name,
    'local_data_source_implementation',
    templates.localDataSourceImplementationGenerator,
    generatorTest: null,
  );
}
