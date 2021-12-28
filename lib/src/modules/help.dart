import 'modules.dart';

void help() {
  printDibbsCli();
  print('''
Usage: snow [options]
Options:
	
- Start: start Create a basic structure for your project (make sure that you haven't any file in "lib" folder)
e.g.: snow start 

 - Install package(s): install [package name] [..]	
e.g.: snow i rxdart dio bloc_pattern

- Install dev package(s): install [package name] [..]
e.g.: snow i flutter_launcher_icons --dev

- Uninstall package: uninstall [package name] 
e.g.: snow uninstall dio

Uninstall dev package: uninstall [package name] --dev
e.g.: snow uninstall flutter_launcher_icons --dev  


- Generate:

Creates a module, page, widget or repository according to the option.
		
Options:

- module [module_name] Creates a new module
Ex.: snow g m manager/product/product

- page [module_name(optional)]/[pages(optional)]/[page_name]	
Creates a new page with your respective controller
Ex.: snow g p manager/product/pages/add_product

widget [module_name(optional)]/[widgets(optional)]/[widget_name] 
Creates a new widget with your respective controller
Ex.: snow g w manager/product/widgets/product_detail

repository [module_name(optional)]/[repositories(optional)]/[repository_name] 
Creates a new repository
Ex.: snow g r manager/product/repositories/product
		
Optional parameters:
	c this parameter prevent a creation of a useless "controller"
	snow g w product/widgets/product_buttom c
	or
	snow g p home/start/pages/product_detail c
	

For easier your life, can be used:
i for install
g for generate
r for repository
w for widget
p for page
m for module
''');
}
