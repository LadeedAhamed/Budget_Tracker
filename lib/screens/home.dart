import 'package:budget_tracking_app/pages/add_budget_dialog.dart';
import 'package:budget_tracking_app/pages/home_page.dart';
import 'package:budget_tracking_app/pages/profile_page.dart';
import 'package:budget_tracking_app/view_model/budget_view_model.dart';
import 'package:budget_tracking_app/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];
  List<Widget> pages = const [HomePage(), ProfilePage()];
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeServices>(context,);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              themeService.darkTheme = !themeService.darkTheme;
            },
            icon: Icon(themeService.darkTheme ? Icons.light_mode : Icons.dark_mode)),
        title: const Text('Budget Tracker'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AddBudgetDialog(budgetToAdd: (budget) {
                        final budgetService = Provider.of<BudgetViewModel>(context,listen: false);
                        budgetService.budget = budget;
                        Navigator.pop(context);
                      });
                    });
              },
              icon: const Icon(Icons.attach_money)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
      body: pages[_currentPageIndex],
    );
  }
}
