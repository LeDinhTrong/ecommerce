import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghtk_model/preview_ghtk_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghtk_repo/preview_ghtk_repo.dart';

class PreviewGHTKProvider extends ChangeNotifier {
  final PreviewGHTKRepo previewGHTKRepo;

  PreviewGHTKProvider({@required this.previewGHTKRepo});

  ResultPreviewGHTKModel resultPreviewGHTKModel;

  Future<void> getPreviewGHTK(PreviewGHTKModel previewGHTKModel) async {
    ApiResponse apiResponse =
        await previewGHTKRepo.getPreviewGHTK(previewGHTKModel.toJson());
    if (apiResponse.response.data['success'] == true) {
      resultPreviewGHTKModel = await ResultPreviewGHTKModel.fromJson(
          apiResponse.response.data['fee']);
      notifyListeners();
    } else {
      throw Exception(apiResponse.response.data['message']);
    }
    notifyListeners();
  }
}
