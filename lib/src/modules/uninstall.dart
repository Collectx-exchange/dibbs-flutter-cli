import 'dart:io';

import 'package:dibbs_flutter_cli/src/utils/output_utils.dart' as output;
import 'package:dibbs_flutter_cli/src/utils/utils.dart';

Future uninstall(List<String> packs, bool isDev,
    [bool showErrors = true, String? directory]) async {
  var spec = await getPubSpec(
      directory: directory == null ? null : Directory(directory));
  var dependencies = isDev ? spec.devDependencies : spec.dependencies;
  var yaml =
      File(directory == null ? 'pubspec.yaml' : '$directory/pubspec.yaml');
  var node = yaml.readAsLinesSync();
  var isAlter = false;

  for (var pack in packs) {
    if (dependencies == null) return false;
    if (!dependencies.containsKey(pack)) {
      if (showErrors) {
        output.error('Package is not installed');
      }
      continue;
    }
    isAlter = true;
    var index = node.indexWhere((t) => t.contains("  $pack:"));
    var nextNode = node[index + 1];
    while (nextNode.contains('     ') ||
        nextNode.contains("    ") ||
        nextNode.contains("      ") ||
        nextNode.contains("       ")) {
      node.removeAt(index + 1);
      nextNode = node[index + 1];
    }
    node.removeAt(index);

    output.success("Removed $pack from pubspec");
  }

  if (isAlter) {
    yaml.writeAsStringSync(node.join('\n'));
  }
}
