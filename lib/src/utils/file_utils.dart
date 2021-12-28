import 'dart:io';

import 'package:dibbs_flutter_cli/src/utils/output_utils.dart' as output;
import 'package:dibbs_flutter_cli/src/utils/utils.dart';
import 'package:path/path.dart';

import 'local_save_log.dart';
import 'object_generate.dart';

Future<void> createFile(
  String path,
  String name,
  String type,
  Function(ObjectGenerate) generator, {
  Function(ObjectGenerate)? generatorTest,
  dynamic additionalInfo,
}) async {
  output.msg('Creating $type...');
  final package = await getNamePackage();

  path = path.replaceAll('\\', '/').replaceAll('\"', '');
  if (path.startsWith('/')) path = path.substring(1);
  if (path.endsWith('/')) path = path.substring(0, path.length - 1);

  path = libPath(path);

  Directory dir;
  if (type == 'repository' || type == 'usecase') {
    dir = Directory(path).parent;
  } else {
    dir = Directory(path);
  }

  final file =
      File('${dir.path}/${name}_${type.replaceAll("_complete", "")}.dart');
  final fileTest = File(
      '${dir.path.replaceFirst("lib/", "test/")}/${name}_${type.replaceAll("_complete", "")}_test.dart');

  if (file.existsSync()) {
    output.error('already exists a $type $name');
    exit(1);
  }

  if (fileTest.existsSync()) {
    output.error('already exists a $type $name test file');
    exit(1);
  }

  file.createSync(recursive: true);
  LocalSaveLog().add(file.path);
  output.msg('File ${file.path} created');

  file.writeAsStringSync(
    generator(
      ObjectGenerate(
        name: formatName(name),
        type: type,
        packageName: package,
        additionalInfo: additionalInfo,
      ),
    ),
  );

  File? module;
  String? nameModule;

  if (generatorTest != null) {
    fileTest.createSync(recursive: true);
    LocalSaveLog().add(fileTest.path);

    output.msg('File test ${fileTest.path} created');
    if (type == 'widget' || type == 'page') {
      fileTest.writeAsStringSync(
        generatorTest(
          ObjectGenerate(
            name: formatName(name),
            packageName: package,
            import: file.path,
            module: nameModule != null ? formatName(nameModule) : null,
            pathModule: module?.path,
            additionalInfo: additionalInfo,
          ),
        ),
      );
    } else {
      fileTest.writeAsStringSync(
        generatorTest(
          ObjectGenerate(
            name: formatName(name),
            packageName: package,
            import: file.path,
            module: nameModule != null ? formatName(nameModule) : null,
            pathModule: module?.path ?? "",
            type: type,
            additionalInfo: additionalInfo,
          ),
        ),
      );
    }
  }

  output.success('$type created');
}

void formatFiles(List<File> files) {
  Process.runSync(
      'flutter',
      [
        'format',
        ...files
            .where((file) => file.path.split('.').last == 'dart')
            .map<String>((file) => file.absolute.path)
            .toList()
      ],
      runInShell: true);
}

Future<File> addModule(String nameCap, String path) async {
  int index;
  var module = findModule(path);

  if (module == null) {
    output.error('Module not found');
    exit(1);
  }

  LocalSaveLog().add(module.path, true);
  final file = File(module.path);
  var node = (await file.readAsString()).split('\n');
  var packageName = await getNamePackage();
  var import =
      'package:$packageName/${path.replaceFirst("lib/", "").replaceAll("\\", "/")}'
          .replaceAll('$packageName/$packageName', packageName);
  node.insert(0, "  import '$import';");

  index = node.indexWhere((t) => t.contains('binds => ['));
  node[index] = node[index]
      .replaceFirst('binds => [', 'binds => [Bind((i) => $nameCap()),');

  await file.writeAsString(node.join('\n'));
  output.success('${module.path} modified');

  return file;
}

FileSystemEntity? findModule(String path) {
  var dir = Directory(path);
  var loop = true;
  var count = 0;
  FileSystemEntity? module;
  do {
    module = search(dir);
    dir = dir.parent;
    loop = module == null && basename(dir.path) != 'lib' && count < 10;
    count++;
  } while (loop);
  if (module == null) return null;
  module = File(module.path.replaceAll('\\', '/'));
  return module;
}

FileSystemEntity? search(Directory dir) {
  try {
    var a = dir
        .listSync()
        .firstWhere((f) => f is File && f.path.contains('_module.dart'));

    print(' Teste' + a.toString());
    return dir
        .listSync()
        .firstWhere((f) => f is File && f.path.contains('_module.dart'));
  } catch (e) {
    return null;
  }
}

void createStaticFile(String path, String content) {
  try {
    var file = File(path)
      ..createSync(recursive: true)
      ..writeAsStringSync(content);
    LocalSaveLog().add(file.path);

    output.success('${file.path} created');
  } catch (e) {
    output.error(e);
    exit(1);
  }
}
