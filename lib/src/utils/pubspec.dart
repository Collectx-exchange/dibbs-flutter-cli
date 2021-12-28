import 'dart:convert';
import 'dart:io';

import 'package:dibbs_flutter_cli/src/utils/output_utils.dart' as output;
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:yaml/yaml.dart';

class PubSpec {
  final String? name;
  final Map? dependencies;
  final Map? devDependencies;
  final Map? dependencyOverrides;

  PubSpec(
      {this.devDependencies,
      this.dependencies,
      this.dependencyOverrides,
      this.name});

  static Future<PubSpec> load(Directory dir) async {
    try {
      final file = dir
          .listSync()
          .firstWhere((i) => i.path.contains('pubspec.yaml')) as File;

      YamlMap doc = loadYaml(file.readAsStringSync());

      return PubSpec(
          name: doc['name'],
          dependencies: Map.from(doc['dependencies']),
          devDependencies: Map.from(doc['dev_dependencies']),
          dependencyOverrides: <String, dynamic>{});
    } catch (e) {
      output.error('No valid project found in this folder.');
      output.title("If you haven't created your project yet create with:");

      print('');
      print('snow create myproject');
      print('');

      output.title('Or enter your project folder with to use snow: ');

      print('');
      print('cd myproject && snow start');
      print('');

      exit(1);
    }
  }

  PubSpec copy(
      {Map? devDependencies,
      Map? dependencies,
      String? name,
      Map? dependencyOverrides}) {
    return PubSpec(
      devDependencies: devDependencies ?? this.devDependencies,
      dependencies: dependencies ?? this.dependencies,
      dependencyOverrides: dependencyOverrides ?? this.dependencyOverrides,
      name: name ?? this.name,
    );
  }

  void bumpVersion(String path, String version) {
    PubspecYaml pubSpecYaml =
        File("${path}pubspec.yaml").readAsStringSync().toPubspecYaml();

    File('${path}pubspec.yaml').writeAsStringSync(pubSpecYaml.toString(),
        mode: FileMode.write, encoding: utf8);
  }
}
