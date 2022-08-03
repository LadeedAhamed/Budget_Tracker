import 'package:budget_tracking_app/model/transaction_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  static const String transactionBoxKey = "transactionsBox";
  static const String balanceBoxKey = "balanceBox";
  static const String budgetBoxKey = "budgetBoxKey";

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  Future<void> initializeHive() async {
  await Hive.initFlutter();
  
    if (!Hive.isAdapterRegistered(1)) { 
      Hive.registerAdapter(TransactionItemAdapter());
    }

  await Hive.openBox<double>(budgetBoxKey);
  await Hive.openBox<double>(balanceBoxKey);
  await Hive.openBox<TransactionItem>(transactionBoxKey);
  
}

void saveTransactionItem(TransactionItem transaction) {
    Hive.box<TransactionItem>(transactionBoxKey).add(transaction);
    saveBalance(transaction); 
  }

  List<TransactionItem> getAllTransactions() {
    return Hive.box<TransactionItem>(transactionBoxKey).values.toList();
  }

  double getBudget(){
  return Hive.box<double>(budgetBoxKey).get("budget") ?? 2000.0;
 }

 Future<void> saveBudget(double budget){
  return Hive.box<double>(budgetBoxKey).put("budget", budget);
   }

  // double getBalance(){
  //   return Hive.box<double>(balanceBoxKey).get("balance") ??0.0;
  // }

  Future<void> saveBalance(TransactionItem item) async {
    final balanceBox = Hive.box<double>(balanceBoxKey);
    final currentBalance = balanceBox.get("balance") ?? 0.0;
    if (item.isExpense) {
      balanceBox.put("balance", currentBalance + item.amount);
    } else {
      balanceBox.put("balance", currentBalance - item.amount);
    }
  }

  double getBalance(){
    return Hive.box<double>(balanceBoxKey).get("balance") ??0.0;
  }

  void deleteTransactionItem(TransactionItem transaction) {
    // Get a list of our transactions
    final transactions = Hive.box<TransactionItem>(transactionBoxKey);
    // Create a map out of it
    final Map<dynamic, TransactionItem> map = transactions.toMap();
    dynamic desiredKey;
    // For each key in the map, we check if the transaction is the same as the one we want to delete
    map.forEach((key, value) {
      if (value.itemTitle == transaction.itemTitle) desiredKey = key;
    });
    // If we found the key, we delete it
    transactions.delete(desiredKey);
    // And we update the balance
    saveBalanceOnDelete(transaction);
  }

    Future<void> saveBalanceOnDelete(TransactionItem item) async {
    final balanceBox = Hive.box<double>(balanceBoxKey);
    final currentBalance = balanceBox.get("balance") ?? 0.0;
    if (item.isExpense) {
      balanceBox.put("balance", currentBalance - item.amount);
    } else {
      balanceBox.put("balance", currentBalance + item.amount);
    }
  }
}


 

