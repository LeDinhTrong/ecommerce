import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/district_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/district_repo.dart';

class DistrictProvider extends ChangeNotifier {
  final DistrictRepo districtRepo;

  DistrictProvider({@required this.districtRepo});

  List<ResultDistrictModel> districtModelList = [];

  Future<void> getDistrict(DistrictModel provinceData) async {
    ApiResponse apiResponse =
        await districtRepo.getDistrictList(provinceData.toJson());
    if (apiResponse.response.data['code'] == 200) {
      districtModelList = List<ResultDistrictModel>.from(apiResponse
          .response.data['data']
          .map((model) => ResultDistrictModel.fromJson(model)));
      notifyListeners();
    } else {
      throw Exception(apiResponse.response.data['message']);
    }
    notifyListeners();
  }
}
