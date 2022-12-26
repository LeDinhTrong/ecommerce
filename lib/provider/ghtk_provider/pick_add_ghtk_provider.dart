import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghtk_model/pick_add_ghtk_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghtk_repo/pick_add_ghtk_repo.dart';

class PickAddGHTKProvider extends ChangeNotifier {
  final PickAddGHTKRepo pickAddGHTKRepo;

  PickAddGHTKProvider({@required this.pickAddGHTKRepo});

  List<PickAddModel> _pickAddModel;
  List<PickAddModel> get pickAddModel => _pickAddModel;

  Future<void> getPickAddGHTK() async {
    ApiResponse apiResponse = await pickAddGHTKRepo.getPickAddGHTK();
    if (apiResponse.response.data['success'] == true) {
      _pickAddModel = [];
      _pickAddModel = List<PickAddModel>.from(apiResponse.response.data['data']
          .map((model) => PickAddModel.fromJson(model)));
    } else {
      throw Exception(apiResponse.response.data['message']);
    }
    notifyListeners();
  }
}
