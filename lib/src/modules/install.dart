import 'dart:io';

import 'package:dibbs_flutter_cli/src/modules/update.dart';
import 'package:dibbs_flutter_cli/src/services/pub_service.dart';
import 'package:dibbs_flutter_cli/src/utils/output_utils.dart' as output;
import 'package:dibbs_flutter_cli/src/utils/utils.dart';

Future<void> install(List<String> packs, bool isDev,
    {bool haveTwoLines = false,
    String? directory,
    bool isOverride = false}) async {
  var spec = await getPubSpec(
      directory: directory == null ? null : Directory(directory));
  var yaml =
      File(directory == null ? 'pubspec.yaml' : '$directory/pubspec.yaml');
  var node = yaml.readAsLinesSync();
  var indexDependency = node.indexWhere((t) => t.contains('dependencies:')) + 1;
  var indexDependencyDev =
      node.indexWhere((t) => t.contains('dev_dependencies:')) + 1;
  var indexDependencyOverrides =
      node.indexWhere((t) => t.contains('dependency_overrides:')) + 1;
  var isAlter = false;
  haveTwoLines = haveTwoLines;
  var dependencies = isDev
      ? spec.devDependencies
      : isOverride
          ? spec.dependencyOverrides
          : spec.dependencies;

  for (var pack in packs) {
    var packName = '';
    var version = '';

    if (pack.contains(':')) {
      packName = pack.split(':')[0];
      version = pack.split(':').length > 1
          ? pack.split(':')[1] +
              ':' +
              pack.split(':').sublist(2).reduce((a, b) => a + ':' + b)
          : pack.split(':')[1];
    } else {
      packName = pack;
    }

    if (dependencies != null &&
        dependencies.containsKey(packName) &&
        !haveTwoLines) {
      await update([packName], isDev);
      continue;
    }

    try {
      if (!haveTwoLines) {
        version = await PubService().getPackage(packName, version);
        node.insert(
            isDev
                ? indexDependencyDev
                : isOverride
                    ? indexDependencyOverrides
                    : indexDependency,
            "  $packName: ^$version");
      } else if (dependencies != null && !dependencies.containsKey(packName)) {
        node.insert(
            isDev
                ? indexDependencyDev
                : isOverride
                    ? indexDependencyOverrides
                    : indexDependency,
            "  $packName: \n    $version");
      }
      output.success("$packName:$version Added in pubspec");
      isAlter = true;
    } catch (e) {
      output.error('Version or package not found');
    }
    if (isAlter) {
      yaml.writeAsStringSync(node.join('\n'));
    }
  }
}
