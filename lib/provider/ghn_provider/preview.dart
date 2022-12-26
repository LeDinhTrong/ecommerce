import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/preview_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/preview.dart';

class PreviewProvider extends ChangeNotifier {
  final PreviewRepo previewRepo;
  PreviewProvider({@required this.previewRepo});

  ResultPreviewModel resultPreviewModel;
  List<ResultPreviewModel> resultPreviewModelList = [];
  Fee feePreview;
  bool evaluate = false;

  Future<void> getPreview(
      BuildContext context, PreviewModel previewModel) async {
    resultPreviewModelList.clear();
    resultPreviewModel = ResultPreviewModel();
    feePreview = Fee();
    print("trong000: ${previewModel.toJson()}");
    ApiResponse apiresponse =
        await previewRepo.getPreview(previewModel.toJson());
    // Map<String, dynamic> result = jsonDecode(apiresponse.toString());
    if (apiresponse.response != null &&
        apiresponse.response.statusCode == 200) {
      evaluate = false;
      resultPreviewModel =
          ResultPreviewModel.fromJson(apiresponse.response.data['data']);
      feePreview = Fee.fromJson(apiresponse.response.data['data']['fee']);
      notifyListeners();
      resultPreviewModelList = resultPreviewModelList..add(resultPreviewModel);
    } else {
      evaluate = true;
      resultPreviewModelList.clear();
      resultPreviewModel = ResultPreviewModel();
      feePreview = Fee();
      notifyListeners();
    }
    notifyListeners();
  }
}
