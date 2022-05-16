Future<String> _getVersion() async {
  return '1.0.5';
}

void version() async {
  printDibbsCli();
  print('CLI package manager and template for Flutter');
  print('');
  print("Dibbs Flutter CLI version: ${await _getVersion()}");
}

void printDibbsCli() {
  print('''
       ___ __    __        
  ____/ (_) /_  / /_  _____
 / __  / / __ \/ __ \/ ___/
/ /_/ / / /_/ / /_/ (__  ) 
\__,_/_/_.___/_.___/____/  
                                                                                                                        
''');
}
