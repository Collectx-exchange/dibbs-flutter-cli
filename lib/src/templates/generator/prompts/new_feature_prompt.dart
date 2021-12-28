import 'package:dibbs_flutter_cli/src/enums/create_page_enums.dart';
import 'package:dibbs_flutter_cli/src/modules/start/select_option.dart';

Future<PageNavigation> get choosePageNavigation async {
  final selected = selectOption('What kind of navigation do you want to use?', [
    'With Arguments (default)',
    'Without Arguments',
  ]);

  switch (selected) {
    case 0:
      return PageNavigation.withArguments;
    case 1:
      return PageNavigation.withoutArguments;
    default:
      return PageNavigation.withArguments;
  }
}

Future<bool> get chooseCreatingViewModel async {
  final select = selectOption(
    'Do you want to create a view model?',
    [
      'Yes (default)',
      'No',
    ],
  );

  switch (select) {
    case 0:
      return true;
    case 1:
      return false;
    default:
      return true;
  }
}

Future<bool> get chooseCreatingAdapter async {
  final select = selectOption(
    'Do you want to create an adapter',
    [
      'Yes (default)',
      'No',
    ],
  );

  switch (select) {
    case 0:
      return true;
    case 1:
      return false;
    default:
      return true;
  }
}
