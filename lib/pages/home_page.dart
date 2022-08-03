import 'package:budget_tracking_app/pages/add_transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../model/transaction_item.dart';
import '../view_model/budget_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AddTransactionDialog(itemToAdd: (transactionItem) {
                  final budgetService =
                      Provider.of<BudgetViewModel>(context, listen: false);
                  budgetService.addItem(transactionItem);
                  // setState(() {
                  //   items.add(transactionItem);
                  //  });
                });
              });
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: screenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Consumer<BudgetViewModel>(
                      builder: (context, value, child) {
                    final balance = value.getBalance();
                    final budget = value.getBudget();
                    double percentage = balance / budget;

                    if (percentage < 0) {
                      percentage = 0;
                    }
                    if (percentage > 1) {
                      percentage = 1;
                    }
                    return CircularPercentIndicator(
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 48.0),
                              "\$" + balance.toString().split(".")[0]),
                          const Text(
                            "Balance",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Budget: \$" + budget.toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      radius: screenSize.width / 2,
                      lineWidth: 10,
                      percent: percentage,
                      progressColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.white,
                    );
                  }),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  "Items",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<BudgetViewModel>(
                  builder: (context, value, child) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.items.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return TransactionCard(item: value.items[index]);
                        }));
                  },
                )
                // List.generate(
                //     items.length,
                //     (index) => TransactionCard(
                //           item: items[index],
                //         )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionItem item;
  const TransactionCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Text("Delete item"),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            final budgetViewModel =
                                Provider.of<BudgetViewModel>(context,
                                    listen: false);
                            budgetViewModel.deleteItem(item);
                            Navigator.pop(context);
                          },
                          child: const Text("Yes")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("No"))
                    ],
                  ),
                ),
              );
            })),
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  offset: const Offset(0, 25),
                  blurRadius: 50,
                )
              ],
            ),
            padding: const EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Text(
                  item.itemTitle,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  (!item.isExpense ? "+ " : "- ") + item.amount.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
