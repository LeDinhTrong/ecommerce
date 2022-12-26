import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/district_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/preview_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/province_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/ward_district.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/district_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/preview.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/province_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/ward_district_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/profile/widget/add_address_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AddressBottomSheet extends StatelessWidget {
  final double order;
  AddressBottomSheet({@required this.order});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Close Button
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).accentColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[
                            Provider.of<ThemeProvider>(context).darkTheme
                                ? 700
                                : 200],
                        spreadRadius: 1,
                        blurRadius: 5)
                  ]),
              child: Icon(Icons.clear, size: Dimensions.ICON_SIZE_SMALL),
            ),
          ),
        ),

        Consumer<ProfileProvider>(
          builder: (context, profile, child) {
            return profile.addressList != null
                ? profile.addressList.length != 0
                    ? SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: profile.addressList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    });
                                Provider.of<OrderProvider>(context,
                                        listen: false)
                                    .setAddressIndex(index);

                                //get provinceId
                                await Provider.of<ProvinceProvider>(context,
                                        listen: false)
                                    .getProvince(context);
                                String _provinceName =
                                    Provider.of<ProfileProvider>(context,
                                            listen: false)
                                        .addressList[Provider.of<OrderProvider>(
                                                context,
                                                listen: false)
                                            .addressIndex]
                                        .province;
                                List<ProvinceModel> _provinceList = [];
                                int _provinceId = 0;
                                _provinceList =
                                    await Provider.of<ProvinceProvider>(context,
                                            listen: false)
                                        .provinceList;
                                for (var i = 0; i < _provinceList.length; i++) {
                                  if (_provinceList[i].nameExtension.indexWhere(
                                          (element) =>
                                              element == _provinceName) !=
                                      -1) {
                                    _provinceId = _provinceList[i].provinceID;
                                    await Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .setProvinceId(
                                            _provinceList[i].provinceID);
                                  }
                                }

                                //get districtId
                                final _provinceData =
                                    DistrictModel(provinceId: _provinceId);
                                await Provider.of<DistrictProvider>(context,
                                        listen: false)
                                    .getDistrict(_provinceData);
                                List<ResultDistrictModel> _districtList = [];
                                String _districtName =
                                    Provider.of<ProfileProvider>(context,
                                            listen: false)
                                        .addressList[Provider.of<OrderProvider>(
                                                context,
                                                listen: false)
                                            .addressIndex]
                                        .district;
                                _districtList =
                                    await Provider.of<DistrictProvider>(context,
                                            listen: false)
                                        .districtModelList;
                                int _districtId = _districtList.indexWhere(
                                    (element) =>
                                        element.districtName.trim() ==
                                        _districtName.trim());
                                await Provider.of<OrderProvider>(context,
                                        listen: false)
                                    .setDistrictId(
                                        _districtList[_districtId].districtID);

                                //get ward
                                final _districtData = WardDistrictModel(
                                    districtId:
                                        _districtList[_districtId].districtID);
                                await Provider.of<WardDistrictProvider>(context,
                                        listen: false)
                                    .getWardDistrictList(_districtData);
                                List<ResultWardDistrictModel> _wardList = [];
                                _wardList =
                                    await Provider.of<WardDistrictProvider>(
                                            context,
                                            listen: false)
                                        .wardModelList;
                                String _wardName = Provider.of<ProfileProvider>(
                                        context,
                                        listen: false)
                                    .addressList[Provider.of<OrderProvider>(
                                            context,
                                            listen: false)
                                        .addressIndex]
                                    .ward;
                                int _wardId = _wardList.indexWhere((element) =>
                                    element.wardName.trim() ==
                                    _wardName.trim());
                                await Provider.of<OrderProvider>(context,
                                        listen: false)
                                    .setWardId(
                                        int.parse(_wardList[_wardId].wardCode));
                                // PreviewModel
                                var preview = PreviewModel(
                                    paymentTypeId: 2,
                                    toPhone:
                                        Provider.of<ProfileProvider>(context, listen: false)
                                            .phone,
                                    // "0332121125",
                                    toName: Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName,
                                    toAddress: Provider.of<OrderProvider>(context,
                                                    listen: false)
                                                .addressIndex !=
                                            null
                                        ? Provider.of<ProfileProvider>(context,
                                                listen: false)
                                            .addressList[
                                                Provider.of<OrderProvider>(context,
                                                        listen: false)
                                                    .addressIndex]
                                            .address
                                        : "khong co dia chi",
                                    toWardCode: _wardList[_wardId].wardCode,
                                    toDistrictId:
                                        _districtList[_districtId].districtID,
                                    content: " ",
                                    weight: 1,
                                    height: 1,
                                    width: 1,
                                    length: 1,
                                    serviceTypeId: 2,
                                    requiredNote: "KHONGCHOXEMHANG",
                                    insuranceValue: order < 10000000
                                        ? order.toInt()
                                        : 10000000,
                                    note: "khong");
                                await Provider.of<PreviewProvider>(context,
                                        listen: false)
                                    .getPreview(context, preview);

                                Navigator.pop(context);

                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorResources.getIconBg(context),
                                  border: index ==
                                          Provider.of<OrderProvider>(context)
                                              .addressIndex
                                      ? Border.all(
                                          width: 2,
                                          color: Theme.of(context).primaryColor)
                                      : null,
                                ),
                                child: ListTile(
                                  leading: Image.asset(
                                    profile.addressList[index].addressType ==
                                            'Home'
                                        ? Images.home_image
                                        : profile.addressList[index]
                                                    .addressType ==
                                                'Ofice'
                                            ? Images.bag
                                            : Images.more_image,
                                    color: ColorResources.getSellerTxt(context),
                                    height: 30,
                                    width: 30,
                                  ),
                                  title: Text(
                                      profile.addressList[index].address,
                                      style: titilliumRegular),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            bottom: Dimensions.PADDING_SIZE_LARGE),
                        child: Text(
                            getTranslated('NO_ADDRESS_AVAILABLE', context)),
                      )
                : Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)));
          },
        ),

        CustomButton(
            buttonText: getTranslated('add_new_address', context),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAddressBottomSheet()));
            }),
      ]),
    );
  }
}
