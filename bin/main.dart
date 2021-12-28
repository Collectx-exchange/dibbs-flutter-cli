import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/dibbs_flutter_cli.dart';

void main(List<String> arguments) {
  final runner = configureCommand(arguments);

  var hasCommand = runner.commands.keys.any((x) => arguments.contains(x));

  if (hasCommand) {
    executeCommand(runner, arguments);
  } else {
    var parser = ArgParser();
    parser = runner.argParser;
    var results = parser.parse(arguments);
    executeOptions(results, arguments, runner);
  }
}

void executeOptions(
    ArgResults results, List<String> arguments, CommandRunner runner) {
  if (results.wasParsed('help') || arguments.isEmpty) {
    printDibbsCli();
    print(runner.usage);
  }

  if (results.wasParsed('version')) {
    version();
  }
}

void executeCommand(CommandRunner runner, List<String> arguments) {
  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
  });
}

CommandRunner configureCommand(List<String> arguments) {
  var runner =
      CommandRunner('dibbs', 'CLI package manager and template for Flutter.')
        ..addCommand(RunCommand())
        ..addCommand(GenerateCommand())
        ..addCommand(GenerateCommandAbbr())
        ..addCommand(UpgradeCommand())
        ..addCommand(RevertCommand());

  runner.argParser.addFlag('version', abbr: 'v', negatable: false);
  return runner;
}
