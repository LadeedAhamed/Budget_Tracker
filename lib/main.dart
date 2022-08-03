import 'package:budget_tracking_app/services/local_storage_service.dart';
import 'package:budget_tracking_app/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home.dart';
import 'view_model/budget_view_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final localStorageService = LocalStorageService();
  await localStorageService.initializeHive(); 
  final sharedPreferences =await SharedPreferences.getInstance();
   return runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeServices>(
            create: (_) => ThemeServices(sharedPreferences)
          ),
          ChangeNotifierProvider<BudgetViewModel>(create: (_) => BudgetViewModel()),
        ],
        child: Builder(
          builder: (BuildContext context) {
            final themeServices = Provider.of<ThemeServices>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Budget Tracker App',
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color.fromARGB(255, 181, 63, 89),
                      brightness: themeServices.darkTheme
                          ? Brightness.dark
                          : Brightness.light)),
              home: const SafeArea(child: Home()),
            );
          },
        ));
  }
}
