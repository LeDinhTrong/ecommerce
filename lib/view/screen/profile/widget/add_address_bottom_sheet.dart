import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:provider/provider.dart';

class AddAddressBottomSheet extends StatefulWidget {
  @override
  _AddAddressBottomSheetState createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final FocusNode _buttonAddressFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false)
        .setAddAddressErrorText(null);
    Provider.of<ProfileProvider>(context, listen: false).getProvince(context);
    // if (Provider.of<ProfileProvider>(context, listen: false).provinceId !=
    //     null) {
    //   Provider.of<ProfileProvider>(context, listen: false).getDistrict(context,
    //       Provider.of<ProfileProvider>(context, listen: false).provinceId);
    // }
  }

  Widget dropdownAddress(String hint, String value, onchanged, itemsList) {
    return Container(
        padding: EdgeInsets.only(
          left: Dimensions.PADDING_SIZE_DEFAULT,
          right: Dimensions.PADDING_SIZE_DEFAULT,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            bottomLeft: Radius.circular(6),
          ),
        ),
        alignment: Alignment.center,
        child: DropdownButtonFormField<String>(
          hint: Text(hint),
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down,
              color: Theme.of(context).primaryColor),
          decoration: InputDecoration(border: InputBorder.none),
          iconSize: 24,
          elevation: 16,
          // style: titilliumRegular,
          onChanged: onchanged,
          items: itemsList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: titilliumRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyText1.color)),
            );
          }).toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm địa chỉ'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: Dimensions.PADDING_SIZE_DEFAULT,
                          right: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            )
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6)),
                        ),
                        alignment: Alignment.center,
                        child: DropdownButtonFormField<String>(
                          hint: Text(
                              getTranslated('Select Address type', context)),
                          value: profileProvider.addressType,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(border: InputBorder.none),
                          iconSize: 24,
                          elevation: 16,
                          // style: titilliumRegular,
                          //underline: SizedBox(),

                          onChanged: profileProvider.updateCountryCode,
                          items: profileProvider.addressTypeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(getTranslated(value, context),
                                  style: titilliumRegular.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color)),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(thickness: 0.7, color: ColorResources.GREY),

                      //province
                      dropdownAddress(
                          getTranslated('CHOOSE_PROVINCE', context),
                          profileProvider.province,
                          profileProvider.updateProvince,
                          profileProvider.provinceName),
                      Divider(thickness: 0.7, color: ColorResources.GREY),

                      //district
                      dropdownAddress(
                          getTranslated('CHOOSE_DISTRICT', context),
                          profileProvider.district,
                          profileProvider.updateDistrict,
                          profileProvider.districtName),
                      Divider(thickness: 0.7, color: ColorResources.GREY),

                      // //ward
                      dropdownAddress(
                          getTranslated('CHOOSE_WARD', context),
                          profileProvider.ward,
                          profileProvider.updateWard,
                          profileProvider.wardName),
                    ],
                  );
                }),

                Divider(thickness: 0.7, color: ColorResources.GREY),
                //address
                CustomTextField(
                  hintText: getTranslated('ENTER_YOUR_ADDRESS', context),
                  controller: _addressController,
                  textInputType: TextInputType.streetAddress,
                  focusNode: _buttonAddressFocus,
                  nextNode: _cityFocus,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 30),
                Provider.of<ProfileProvider>(context).addAddressErrorText !=
                        null
                    ? Text(
                        Provider.of<ProfileProvider>(context)
                            .addAddressErrorText,
                        style: titilliumRegular.copyWith(
                            color: ColorResources.RED))
                    : SizedBox.shrink(),
                Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    return profileProvider.isLoading
                        ? CircularProgressIndicator(
                            key: Key(''),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor))
                        : CustomButton(
                            buttonText:
                                getTranslated('UPDATE_ADDRESS', context),
                            onTap: () {
                              _addAddress();
                            },
                          );
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addAddress() async {
    if (Provider.of<ProfileProvider>(context, listen: false).addressType ==
        null) {
      Provider.of<ProfileProvider>(context, listen: false)
          .setAddAddressErrorText(
              getTranslated('SELECT_ADDRESS_TYPE', context));
    } else if (Provider.of<ProfileProvider>(context, listen: false).province ==
        null) {
      Provider.of<ProfileProvider>(context, listen: false)
          .setAddAddressErrorText(
              getTranslated('CITY_FIELD_MUST_BE_REQUIRED', context));
    } else if (Provider.of<ProfileProvider>(context, listen: false).district ==
        null) {
      Provider.of<ProfileProvider>(context, listen: false)
          .setAddAddressErrorText(
              getTranslated('DISTRICT_FIELD_MUST_BE_REQUIRED', context));
    } else if (Provider.of<ProfileProvider>(context, listen: false).ward ==
        null) {
      Provider.of<ProfileProvider>(context, listen: false)
          .setAddAddressErrorText(
              getTranslated('WARD_FIELD_MUST_BE_REQUIRED', context));
    } else if (_addressController.text.isEmpty) {
      Provider.of<ProfileProvider>(context, listen: false)
          .setAddAddressErrorText(
              getTranslated('ADDRESS_FIELD_MUST_BE_REQUIRED', context));
    } else {
      Provider.of<ProfileProvider>(context, listen: false)
          .setAddAddressErrorText(null);
      AddressModel addressModel = AddressModel();
      addressModel.contactPersonName = 'x';
      addressModel.addressType =
          Provider.of<ProfileProvider>(context, listen: false).addressType;
      addressModel.province =
          Provider.of<ProfileProvider>(context, listen: false).province;
      addressModel.district =
          Provider.of<ProfileProvider>(context, listen: false).district;
      addressModel.ward =
          Provider.of<ProfileProvider>(context, listen: false).ward;
      addressModel.address =
          "${_addressController.text}, ${Provider.of<ProfileProvider>(context, listen: false).ward}, ${Provider.of<ProfileProvider>(context, listen: false).district}";
      addressModel.zip = "";
      addressModel.phone = '0';

      await Provider.of<ProfileProvider>(context, listen: false)
          .addAddress(addressModel, route);
      Provider.of<ProfileProvider>(context, listen: false).clearAddress();
    }
  }

  route(bool isRoute, String message) {
    if (isRoute) {
      Provider.of<ProfileProvider>(context, listen: false)
          .initAddressList(context);
      Navigator.pop(context);
    }
  }
}
