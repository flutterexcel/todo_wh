import 'package:flutter/cupertino.dart';

class todoProvider extends ChangeNotifier {
  bool isTaskCompleted = false;
  bool checkComplition(bool b) {
    b = !b;
    isTaskCompleted = b;
    notifyListeners();
    print('INN notifyListner');

    return isTaskCompleted;
  }

  resetBool(bool b) {
    checkComplition(true);
    notifyListeners();
  }
}
