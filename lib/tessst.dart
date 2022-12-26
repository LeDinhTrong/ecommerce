import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/create_shipping.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/preview_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/shop_all_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghtk_model/create_ghtk_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghtk_model/pick_add_ghtk_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghtk_model/preview_ghtk_model.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/create_shipping_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/district_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/preview.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/province_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/shop_all_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/pick_add_ghtk_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/preview_ghtk_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class Tesst extends StatefulWidget {
  Tesst();

  @override
  _TesstState createState() => _TesstState();
}

class _TesstState extends State<Tesst> {
  @override
  Widget build(BuildContext context) {
    var preview = PreviewModel(
        paymentTypeId: 2,
        toPhone: "0332121125",
        toName: "trong ",
        toAddress: "523 CMT8, cam le, da nang",
        toWardCode: "40703",
        toDistrictId: 1531,
        content: " ",
        weight: 200,
        serviceTypeId: 2,
        requiredNote: "KHONGCHOXEMHANG",
        insuranceValue: 10000000);

    return SafeArea(
        child: Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Provider.of<PreviewProvider>(context, listen: false)
                  .getPreview(context, preview);
            },
            child: Text("button")),
      ),
    ));
  }
}
