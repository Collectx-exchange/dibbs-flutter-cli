
import 'command_base.dart';
import 'sub_command/generate_controller.dart';
import 'sub_command/generate_data_source_sub_command.dart';
import 'sub_command/generate_entity_sub_command.dart';
import 'sub_command/generate_page_sub_command.dart';
import 'sub_command/generate_repository_sub_command.dart';
import 'sub_command/generate_test_sub_command.dart';
import 'sub_command/generate_use_case_sub_command.dart';
import 'sub_command/generate_widget_sub_command.dart';

class GenerateCommand extends CommandBase {
  @override
  final name = 'generate';
  @override
  final description =
      'Creates a module, page, widget or repository according to the option.';
  final abbr = 'g';

  GenerateCommand() {
    addSubcommand(GeneratePageSubCommand());
    addSubcommand(GeneratePageAbbrSubCommand());
    addSubcommand(GenerateWidgetSubCommand());
    addSubcommand(GenerateWidgetAbbrSubCommand());
    addSubcommand(GenerateControllerSubCommand());
    addSubcommand(GenerateControllerAbbrSubCommand());
    addSubcommand(GenerateRepositorySubCommand());
    addSubcommand(GenerateRepositoryAbbrSubCommand());
    addSubcommand(GenerateTestSubCommand());
    addSubcommand(GenerateTestAbbrSubCommand());
    addSubcommand(GenerateDataSourceSubCommand());
    addSubcommand(GenerateDataSourceAbbrSubCommand());
    addSubcommand(GenerateEntitySubCommand());
    addSubcommand(GenerateEntityAbbrSubCommand());
    addSubcommand(GenerateUseCaseSubCommand());
    addSubcommand(GenerateUseCaseAbbrSubCommand());
  }
}

class GenerateCommandAbbr extends GenerateCommand {
  @override
  final name = 'g';
}
