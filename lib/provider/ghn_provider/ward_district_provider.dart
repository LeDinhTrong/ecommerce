import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/ward_district.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/ward_repo.dart';

class WardDistrictProvider extends ChangeNotifier {
  final WardDistrictRepo wardDistrictRepo;

  WardDistrictProvider({@required this.wardDistrictRepo});

  List<ResultWardDistrictModel> wardModelList = [];

  Future<void> getWardDistrictList(WardDistrictModel wardData) async {
    ApiResponse apiResponse =
        await wardDistrictRepo.getWardDistrictList(wardData.toJson());
    if (apiResponse.response.data['code'] == 200) {
      wardModelList = List<ResultWardDistrictModel>.from(apiResponse
          .response.data['data']
          .map((model) => ResultWardDistrictModel.fromJson(model)));
      notifyListeners();
    } else {
      throw Exception(apiResponse.response.data['message']);
    }
    notifyListeners();
  }
}
