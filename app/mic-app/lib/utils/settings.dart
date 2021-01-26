import 'package:flutter/foundation.dart';

enum PredictorType { ENDTOEND, DOMAINFEATURES }

class Settings with ChangeNotifier {
  double _threshold = 0;
  PredictorType _predictorType = PredictorType.ENDTOEND;

  double get threshold => _threshold;

  void setThreshold(double threshold) {
    _threshold = threshold;

    notifyListeners();
  }

  PredictorType get predictorType => _predictorType;

  void setPredictorType(PredictorType predictorType){
    _predictorType = predictorType;

    notifyListeners();
  }
}
