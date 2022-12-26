import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/province_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/province_repo.dart';

class ProvinceProvider extends ChangeNotifier {
  final ProvinceRepo provinceRepo;

  ProvinceProvider({@required this.provinceRepo});

  List<ProvinceModel> provinceList = [];

  Future<void> getProvince(BuildContext context) async {
    final response = await provinceRepo.getProvinceList();
    Map<String, dynamic> result = jsonDecode(response.toString());
    if (result['code'] == 200) {
      provinceList = List<ProvinceModel>.from(
          result['data'].map((model) => ProvinceModel.fromJson(model)));
      notifyListeners();
    } else {
      throw Exception(result['message']);
    }
    notifyListeners();
  }
}
