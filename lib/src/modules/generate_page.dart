import 'package:dibbs_flutter_cli/src/enums/create_page_enums.dart';
import 'package:dibbs_flutter_cli/src/templates/generator/prompts/new_feature_prompt.dart';
import 'package:dibbs_flutter_cli/src/templates/templates.dart' as templates;
import 'package:dibbs_flutter_cli/src/utils/file_utils.dart' as file_utils;

Future<void> page(String name) async {
  final pageNavigation = await choosePageNavigation;
  final root = 'app/pages/';

  //ToDo(): Create/Add test template
  switch (pageNavigation) {
    case PageNavigation.withArguments:
      await file_utils.createFile(
        root + name,
        name,
        'page',
        templates.pageGeneratorGetXWithArguments,
        generatorTest: null,
      );
      await file_utils.createFile(
        root + name + '/arguments/',
        name,
        'arguments',
        templates.pageArgumentsGenerator,
        generatorTest: null,
      );
      break;
    case PageNavigation.withoutArguments:
      await file_utils.createFile(
        root + name,
        name,
        'page',
        templates.pageGeneratorGetX,
        generatorTest: null,
      );
      break;
  }

  final createViewModel = await chooseCreatingViewModel;

  if (createViewModel)
    await file_utils.createFile(
      root + name + '/view_model/',
      name,
      'view_model',
      templates.viewModelGenerator,
      generatorTest: null,
    );

  final createAdapter = await chooseCreatingAdapter;

  //ToDo(): Create/Add test template
  if (createAdapter)
    await file_utils.createFile(
      root + name + '/adapter/',
      name,
      'adapter',
      templates.adapterGenerator,
      generatorTest: null,
    );

  await controller(root + name, name, 'controller');
  await bindings(root + name + '/bindings/', name, 'bindings');
}

//ToDo(): Create/Add test template
Future<void> controller(String path, String name, String type,
    {bool haveTest = true}) async {
  final template = templates.getXControllerGenerator;
  //final testTemplate = templates.getXControllerTestGenerator;

  await file_utils.createFile(
    path,
    name,
    type,
    template,
    generatorTest: null,
  );
}

Future<void> bindings(
  String path,
  String name,
  String type,
) async {
  var templateGetXBindings = templates.getXBindingsGenerator;

  await file_utils.createFile(
    path,
    name,
    type,
    templateGetXBindings,
    generatorTest: null,
  );
}
