import 'package:connectivity/connectivity.dart';

class NetworkService{
  static Future<bool> checkDataConnectivity()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
     return false;
    }
    else{
      return true;
    }
  }
}