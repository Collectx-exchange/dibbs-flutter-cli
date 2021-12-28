import 'package:dibbs_flutter_cli/src/enums/create_page_enums.dart';
import 'package:dibbs_flutter_cli/src/templates/generator/prompts/new_feature_prompt.dart';
import 'package:dibbs_flutter_cli/src/templates/templates.dart' as templates;
import 'package:dibbs_flutter_cli/src/utils/file_utils.dart' as file_utils;

Future<void> page(String path) async {

  final pageNavigation = await choosePageNavigation;

  //ToDo(): Create/Add test template
  switch (pageNavigation) {
    case PageNavigation.withArguments:
      await file_utils.createFile(
        'app/pages/' + path,
        'page',
        templates.pageGeneratorGetXWithArguments,
        generatorTest: templates.pageTestGenerator,
      );
      await file_utils.createFile(
        '$path/arguments/' + path,
        'arguments',
        templates.pageArgumentsGenerator,
        generatorTest: null,
      );
      break;
    case PageNavigation.withoutArguments:
      await file_utils.createFile(
        '$path',
        'page',
        templates.pageGeneratorGetX,
        generatorTest: null,
      );
      break;
  }

  final createViewModel = await chooseCreatingViewModel;

  //ToDo(): Create/Add test template
  if (createViewModel)
    await file_utils.createFile(
      '$path/view_model/' + path,
      'view_model',
      templates.viewModelGenerator,
      generatorTest: null,
    );

  final createAdapter = await chooseCreatingAdapter;

  //ToDo(): Create/Add test template
  if (createAdapter)
    await file_utils.createFile(
      '$path/adapter/' + path,
      'adapter',
      templates.adapterGenerator,
      generatorTest: null,
    );

  await controller('$path/' + path, 'controller');
  await bindings('$path/bindings/' + path, 'bindings');
}

//ToDo(): Create/Add test template
Future<void> controller(String path, String type,
    {bool haveTest = true}) async {
  final template = templates.getXControllerGenerator;
  //final testTemplate = templates.getXControllerTestGenerator;

  await file_utils.createFile(
    path,
    type,
    template,
    generatorTest: null,
  );
}

Future<void> bindings(
  String path,
  String type,
) async {
  var templateGetXBindings = templates.getXBindingsGenerator;

  path = 'app/bindings/' + path;

  await file_utils.createFile(
    path,
    type,
    templateGetXBindings,
    generatorTest: null,
  );
}
