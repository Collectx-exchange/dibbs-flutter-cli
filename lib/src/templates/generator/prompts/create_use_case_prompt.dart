import 'package:dibbs_flutter_cli/src/enums/create_use_case_enums.dart';
import 'package:dibbs_flutter_cli/src/modules/start/select_option.dart';

Future<UseCaseParams> get createUseCasePrompt async {
  final selected = selectOption('What kind of Use Case do you want to generate?', [
    'With Params (default)',
    'Without Params',
  ]);

  switch (selected) {
    case 0:
      return UseCaseParams.withParams;
    case 1:
      return UseCaseParams.withoutParams;
    default:
      return UseCaseParams.withParams;
  }
}