import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghtk_model/create_ghtk_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghtk_model/preview_ghtk_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghtk_repo/create_ghtk_repo.dart';

class CreateGHTKProvider extends ChangeNotifier {
  final CreateGHTKRepo createGHTKRepo;

  CreateGHTKProvider({@required this.createGHTKRepo});

  ResultPreviewGHTKModel resultPreviewGHTKModel;

  Future<void> createGHTK(CreateGHTKModel createGHTKModel) async {
    ApiResponse apiResponse =
        await createGHTKRepo.createGHTK(createGHTKModel.toJson());
    if (apiResponse.response.data['success'] == true) {
      print(
          "=============== ${apiResponse.response.data['message']} ===============");
    } else {
      throw Exception(apiResponse.response.data['message']);
    }
    notifyListeners();
  }
}
