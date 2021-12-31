class ObjectGenerate {
  final String name;
  final String packageName;
  final String? import;
  final String? type;
  final String? module;
  final String? pathModule;
  final dynamic additionalInfo;

  ObjectGenerate({
    this.additionalInfo,
    required this.name,
    required this.packageName,
    this.pathModule,
    this.module,
    this.import,
    this.type,
  });
}
