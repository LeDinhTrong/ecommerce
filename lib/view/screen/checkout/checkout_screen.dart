import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/order_place_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/create_shipping.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/preview_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/shop_all_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghtk_model/create_ghtk_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/payment.dart';

import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/coupon_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/create_shipping_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/preview.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/province_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/shop_all_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/create_ghtk_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/pick_add_ghtk_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/preview_ghtk_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/utill/theme_data.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/my_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/address_bottom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/custom_check_box.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/shipping_method_bottom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:momo_vn/momo_vn.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromProductDetails;
  CheckoutScreen({@required this.cartList, this.fromProductDetails = false});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CreateShippingModel createShipping;
  CreateGHTKModel createGHTKModel;
  MomoVn _momoPay;
  OrderPlaceModel xxx;
  List<Items> itemsList = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();
  var preview;
  double _order = 0;
  double _discount = 0;
  double _tax = 0;
  double _amount = 0;

  final textStyle = TextStyle(color: Colors.black54);
  final valueStyle = TextStyle(
      color: AppColor.accentColor, fontSize: 18.0, fontWeight: FontWeight.w400);
  String zpTransToken = "";
  String payResult = "";
  String payResultReturnSuccess = "Thanh toán thành công";
  String payResultReturnFailure = "Thanh toán thất bại";
  String payResultReturnCancel = "User Huỷ Thanh Toán";
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    _momoPay = MomoVn();
    _momoPay.on(MomoVn.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _momoPay.on(MomoVn.EVENT_PAYMENT_ERROR, _handlePaymentError);
    initPlatformState();
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressTypeList(context);
    Provider.of<OrderProvider>(context, listen: false)
        .initShippingList(context);
    Provider.of<CouponProvider>(context, listen: false).removePrevCouponData();
    Provider.of<PickAddGHTKProvider>(context, listen: false).getPickAddGHTK();
    var shopAllModel = ShopAllModel(offset: 0, limit: 50);
    Provider.of<ShopAllProvider>(context, listen: false)
        .getShopAll(shopAllModel);

    widget.cartList.forEach((cart) {
      double amount = cart.price;
      _order = _order + (amount * cart.quantity);
      _discount = _discount +
          PriceConverter.calculation(
              amount, cart.discount, cart.discountType, cart.quantity);
      _tax = _tax +
          PriceConverter.calculation(
              amount, cart.tax, cart.taxType, cart.quantity);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _momoPay.clear();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {});
  }

  void _handlePaymentSuccess(PaymentResponse response) {
    Provider.of<OrderProvider>(context, listen: false)
        .placeOrder(xxx, _callback, widget.cartList);
    if (Provider.of<OrderProvider>(context, listen: false).shippingIndex == 1) {
      Provider.of<CreateShippingProvider>(context, listen: false)
          .createShipping(context, createShipping);
    }
    if (Provider.of<OrderProvider>(context, listen: false).shippingIndex == 2) {
      Provider.of<CreateGHTKProvider>(context, listen: false)
          .createGHTK(createGHTKModel);
    }
  }

  void _handlePaymentError(PaymentResponse response) {
    Fluttertoast.showToast(
        msg: "THẤT BẠI: " + response.message.toString(),
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_LARGE,
            vertical: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
            color: ColorResources.getPrimary(context),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: Consumer<OrderProvider>(
          builder: (context, order, child) {
            var _prviewGHTK =
                Provider.of<PreviewGHTKProvider>(context, listen: false);
            var _prview = Provider.of<PreviewProvider>(context, listen: false);
            double _shippingCost =
                order.shippingIndex == 0 && order.shippingIndex != null
                    ? order.shippingList[order.shippingIndex].cost
                    : order.shippingIndex == 1
                        ? _prview.resultPreviewModel != null
                            ? _prview.resultPreviewModel.totalFee.toDouble()
                            : 0
                        : _prviewGHTK.resultPreviewGHTKModel != null
                            ? _prviewGHTK.resultPreviewGHTKModel.fee.toDouble()
                            : 0;
            double _couponDiscount =
                Provider.of<CouponProvider>(context).discount != null
                    ? Provider.of<CouponProvider>(context).discount
                    : 0;

            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    PriceConverter.convertPrice(
                        context,
                        (_order +
                            _shippingCost -
                            _discount -
                            _couponDiscount +
                            _tax)),
                    style: titilliumSemiBold.copyWith(
                        color: Theme.of(context).accentColor),
                  ),
                  !Provider.of<OrderProvider>(context).isLoading
                      ? Builder(
                          builder: (context) => TextButton(
                            onPressed: () async {
                              print(
                                  'phuong ${Provider.of<OrderProvider>(context, listen: false).addressIndex}');
                              print(
                                  'phuong ${Provider.of<OrderProvider>(context, listen: false).shippingIndex}');
                              // return;
                              if (Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .addressIndex ==
                                  null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Chọn địa chỉ giao hàng'),
                                        backgroundColor: Colors.red));
                              } else if (Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .shippingIndex ==
                                  null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Chọn phương thức thanh toán'),
                                        backgroundColor: Colors.red));
                              } else {
                                List<Cart> carts = [];
                                List<Items> items = [];
                                List<Products> products = [];

                                // return;
                                for (int index = 0;
                                    index < widget.cartList.length;
                                    index++) {
                                  CartModel cart = widget.cartList[index];
                                  items.add(Items(
                                      name: cart.name,
                                      quantity: cart.quantity,
                                      price: cart.price.toInt()));
                                  products.add(Products(
                                      name: cart.name,
                                      price: cart.price.toInt(),
                                      quantity: cart.quantity,
                                      weight: 0.1));
                                  carts.add(Cart(
                                    cart.id.toString(),
                                    PriceConverter.calculation(
                                        cart.price, cart.tax, cart.taxType, 1),
                                    cart.quantity,
                                    cart.price,
                                    PriceConverter.calculation(cart.price,
                                        cart.discount, cart.discountType, 1),
                                    'amount',
                                    index == 0
                                        ? Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .shippingList[
                                                Provider.of<OrderProvider>(
                                                        context,
                                                        listen: false)
                                                    .shippingIndex]
                                            .id
                                        : 1,
                                    "" //cart.variant
                                    ,
                                    cart.variation != null
                                        ? [cart.variation]
                                        : [],
                                    _shippingCost ?? 0,
                                    name: cart.name,
                                  ));
                                }

                                double couponDiscount =
                                    Provider.of<CouponProvider>(context,
                                                    listen: false)
                                                .discount !=
                                            null
                                        ? Provider.of<CouponProvider>(context,
                                                listen: false)
                                            .discount
                                        : 0;

                                print('star1t');

                                CustomerInfo x1 = CustomerInfo(
                                  Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .addressList[Provider.of<OrderProvider>(
                                              context,
                                              listen: false)
                                          .addressIndex]
                                      .id
                                      .toString(),
                                  Provider.of<ProfileProvider>(context,
                                          listen: false)
                                      .addressList[Provider.of<OrderProvider>(
                                              context,
                                              listen: false)
                                          .addressIndex]
                                      .address,
                                );
                                print('star2t');
                                xxx = OrderPlaceModel(
                                  x1,
                                  carts,
                                  order.paymentMethodIndex == 0
                                      ? 'cash'
                                      : 'e-wallet',
                                  order.paymentMethodIndex == 0
                                      ? 'unpaid'
                                      : 'paid',
                                  couponDiscount,
                                );

                                print('st3art');
                                Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .paymentMethodIndex ==
                                        0
                                    ? Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .placeOrder(
                                            xxx, _callback, widget.cartList)
                                    : Provider.of<OrderProvider>(context,
                                                    listen: false)
                                                .paymentMethodIndex ==
                                            1
                                        ? _callbackEwallet()
                                        : _callbackZaloPay(zpTransToken);
                                //giao hang nhanh
                                var _codAmount =
                                    PriceConverter.convertPriceTMoMo(
                                        context,
                                        _order -
                                            _discount -
                                            _couponDiscount +
                                            _tax);
                                createShipping = CreateShippingModel(
                                  paymentTypeId: 2,
                                  note: "Test 123",
                                  requiredNote: "KHONGCHOXEMHANG",
                                  returnAddress: Provider.of<ShopAllProvider>(
                                          context,
                                          listen: false)
                                      .resultShopAllList
                                      .first
                                      .address,
                                  returnPhone: Provider.of<ShopAllProvider>(
                                          context,
                                          listen: false)
                                      .resultShopAllList
                                      .first
                                      .phone,
                                  toName:
                                      "${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName} ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName}",
                                  toPhone:
                                      "${Provider.of<ProfileProvider>(context, listen: false).phone}",
                                  toAddress: Provider.of<OrderProvider>(context,
                                                  listen: false)
                                              .addressIndex !=
                                          null
                                      ? Provider.of<ProfileProvider>(context,
                                              listen: false)
                                          .addressList[
                                              Provider.of<OrderProvider>(
                                                      context,
                                                      listen: false)
                                                  .addressIndex]
                                          .address
                                      : " khong co dia chi",
                                  toWardCode: order.wardId,
                                  toDistrictId: order.districtId,
                                  codAmount: order.paymentMethodIndex == 0
                                      ? _codAmount.toInt()
                                      : 0,
                                  content: items.first.name,
                                  weight: 200,
                                  length: 1,
                                  width: 10,
                                  height: 10,
                                  insuranceValue: _order < 10000000
                                      ? _order.toInt()
                                      : 10000000,
                                  serviceTypeId: 2,
                                  items: items,
                                );

                                // giao hang tiet kiem
                                var _pickAdd = Provider.of<PickAddGHTKProvider>(
                                        context,
                                        listen: false)
                                    .pickAddModel
                                    .first;
                                var _profile = Provider.of<ProfileProvider>(
                                    context,
                                    listen: false);
                                var _addressIndex = Provider.of<OrderProvider>(
                                    context,
                                    listen: false);
                                var orders = Order(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    pickName: _pickAdd.pickName,
                                    pickMoney: Provider.of<OrderProvider>(context, listen: false)
                                                .paymentMethodIndex ==
                                            0
                                        ? _order.toInt()
                                        : 0,
                                    pickAddressId: _pickAdd.pickAddressId,
                                    pickAddress: _pickAdd.address,
                                    pickProvince: _pickAdd.address,
                                    pickDistrict: _pickAdd.address,
                                    pickTel: _pickAdd.pickTel,
                                    name:
                                        "${_profile.userInfoModel.fName} ${_profile.userInfoModel.lName}",
                                    address: _addressIndex.addressIndex != null
                                        ? _profile
                                            .addressList[
                                                _addressIndex.addressIndex]
                                            .address
                                        : " khong co dia chi",
                                    province: _addressIndex.addressIndex != null
                                        ? _profile
                                            .addressList[
                                                _addressIndex.addressIndex]
                                            .province
                                        : " khong co dia chi",
                                    district: _addressIndex.addressIndex != null
                                        ? _profile
                                            .addressList[_addressIndex.addressIndex]
                                            .district
                                        : " khong co dia chi",
                                    ward: _addressIndex.addressIndex != null ? _profile.addressList[_addressIndex.addressIndex].ward : " khong co dia chi",
                                    hamlet: "khác",
                                    tel: "${Provider.of<ProfileProvider>(context, listen: false).phone}",
                                    note: "note khong co",
                                    isFreeship: "0",
                                    value: _codAmount.toInt(),
                                    transport: "road");
                                createGHTKModel = CreateGHTKModel(
                                  products: products,
                                  order: orders,
                                );
                                if (Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .paymentMethodIndex ==
                                        0 &&
                                    Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .shippingIndex ==
                                        1) {
                                  Provider.of<CreateShippingProvider>(context,
                                          listen: false)
                                      .createShipping(context, createShipping);
                                }
                                if (Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .paymentMethodIndex ==
                                        0 &&
                                    Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .shippingIndex ==
                                        2) {
                                  Provider.of<CreateGHTKProvider>(context,
                                          listen: false)
                                      .createGHTK(createGHTKModel);
                                }
                              }
                              print('star4t');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(getTranslated('proceed', context),
                                style: titilliumSemiBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                  color: ColorResources.getPrimary(context),
                                )),
                          ),
                        )
                      : Container(
                          height: 30,
                          width: 100,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).accentColor)),
                        ),
                ]);
          },
        ),
      ),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('checkout', context)),
          Expanded(
            child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(0),
                children: [
                  // Shipping Details
                  Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    decoration:
                        BoxDecoration(color: Theme.of(context).accentColor),
                    child: Column(children: [
                      // Choose Address
                      InkWell(
                        onTap: () {
                          Provider.of<OrderProvider>(context, listen: false)
                              .clearShippingAddress();
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => AddressBottomSheet(
                                    order: _order,
                                  ));
                        },
                        child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated('SHIPPING_TO', context),
                                  style: titilliumRegular),
                              SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox.shrink(),
                                    Flexible(
                                      child: Text(
                                        Provider.of<OrderProvider>(context)
                                                    .addressIndex ==
                                                null
                                            ? getTranslated(
                                                'add_your_address', context)
                                            : Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .addressList[
                                                    Provider.of<OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressIndex]
                                                .address,
                                        style: titilliumSemiBold.copyWith(
                                            color: ColorResources.getPrimary(
                                                context)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                        width: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    Image.asset(Images.EDIT_TWO,
                                        width: 15,
                                        height: 15,
                                        color:
                                            ColorResources.getPrimary(context)),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Divider(
                            height: 2, color: ColorResources.getHint(context)),
                      ),
                      // Choose Shipping Method
                      InkWell(
                        onTap: () {
                          if (Provider.of<OrderProvider>(context, listen: false)
                                  .addressIndex ==
                              null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Chọn địa chỉ giao hàng'),
                                backgroundColor: Colors.red));
                          } else {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ShippingMethodBottomSheet(
                                  orderValue: _order,
                                  evaluate: Provider.of<PreviewProvider>(
                                          context,
                                          listen: false)
                                      .evaluate),
                            );
                          }
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                      getTranslated(
                                          'SHIPPING_PARTNER', context),
                                      style: titilliumRegular),
                                ],
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox.shrink(),
                                  Flexible(
                                    child: Text(
                                      Provider.of<OrderProvider>(context)
                                                  .shippingIndex ==
                                              null
                                          ? getTranslated(
                                              'select_shipping_method', context)
                                          : Provider.of<OrderProvider>(context,
                                                  listen: false)
                                              .shippingList[
                                                  Provider.of<OrderProvider>(
                                                          context,
                                                          listen: false)
                                                      .shippingIndex]
                                              .title,
                                      style: titilliumSemiBold.copyWith(
                                          color: ColorResources.getPrimary(
                                              context)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Image.asset(Images.EDIT_TWO,
                                      width: 15,
                                      height: 15,
                                      color:
                                          ColorResources.getPrimary(context)),
                                ],
                              )),
                            ]),
                      ),
                      Provider.of<OrderProvider>(context).shippingIndex == 1
                          ? Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    getTranslated('insurance', context),
                                    style: TextStyle(
                                        color: ColorResources.RED,
                                        fontSize: Dimensions.FONT_SIZE_SMALL),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                      Provider.of<OrderProvider>(context).shippingIndex == 2
                          ? Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    getTranslated('insurance_GHTK', context),
                                    style: TextStyle(
                                        color: ColorResources.RED,
                                        fontSize: Dimensions.FONT_SIZE_SMALL),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink()
                    ]),
                  ),

                  // Order Details
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    color: Theme.of(context).accentColor,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleRow(
                            title: getTranslated('ORDER_DETAILS', context),
                            // onTap: widget.fromProductDetails
                            //     ? null
                            //     : () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (_) => CartScreen(
                            //                     fromCheckout: true,
                            //                     checkoutCartList:
                            //                         widget.cartList)));
                            //       }
                          ),
                          for (var i = 0; i < widget.cartList.length; i++)
                            Padding(
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: Row(children: [
                                FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  image:
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${widget.cartList[i].image}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                      Images.placeholder,
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50),
                                ),
                                SizedBox(width: Dimensions.MARGIN_SIZE_DEFAULT),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.cartList[i].name,
                                          style: titilliumRegular.copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                              color: ColorResources.getPrimary(
                                                  context)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                            height: Dimensions
                                                .MARGIN_SIZE_EXTRA_SMALL),
                                        Row(children: [
                                          Text(
                                            PriceConverter.convertPrice(context,
                                                widget.cartList[i].price),
                                            style: titilliumSemiBold.copyWith(
                                                color:
                                                    ColorResources.getPrimary(
                                                        context)),
                                          ),
                                          SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          Text(
                                              widget.cartList[i].quantity
                                                  .toString(),
                                              style: titilliumSemiBold.copyWith(
                                                  color:
                                                      ColorResources.getPrimary(
                                                          context))),
                                          Container(
                                            height: 20,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            margin: EdgeInsets.only(
                                                left: Dimensions
                                                    .MARGIN_SIZE_EXTRA_LARGE),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                    color: ColorResources
                                                        .getPrimary(context))),
                                            child: Text(
                                              PriceConverter
                                                  .percentageCalculation(
                                                      context,
                                                      widget.cartList[i].price,
                                                      widget
                                                          .cartList[i].discount,
                                                      widget.cartList[i]
                                                          .discountType),
                                              style: titilliumRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_EXTRA_SMALL,
                                                  color:
                                                      ColorResources.getPrimary(
                                                          context)),
                                            ),
                                          ),
                                        ]),
                                      ]),
                                ),
                              ]),
                            ),

                          // Coupon
                          Row(children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: 'Have a coupon?',
                                      hintStyle: titilliumRegular.copyWith(
                                          color:
                                              ColorResources.HINT_TEXT_COLOR),
                                      filled: true,
                                      fillColor:
                                          ColorResources.getIconBg(context),
                                      border: InputBorder.none,
                                    )),
                              ),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            !Provider.of<CouponProvider>(context).isLoading
                                ? ElevatedButton(
                                    onPressed: () {
                                      if (_controller.text.isNotEmpty) {
                                        Provider.of<CouponProvider>(context,
                                                listen: false)
                                            .initCoupon(
                                                _controller.text, _order)
                                            .then((value) {
                                          if (value > 0) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'You got ${PriceConverter.convertPrice(context, value)} discount'),
                                                    backgroundColor:
                                                        Colors.green));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(getTranslated(
                                                  'invalid_coupon_or',
                                                  context)),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: ColorResources.getGreen(context),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child:
                                        Text(getTranslated('APPLY', context)),
                                  )
                                : CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor)),
                          ]),
                        ]),
                  ),

                  // Total bill
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    color: Theme.of(context).accentColor,
                    child: Consumer<OrderProvider>(
                      builder: (context, order, child) {
                        var _preview = Provider.of<PreviewProvider>(context,
                            listen: false);
                        var _previewGHTK = Provider.of<PreviewGHTKProvider>(
                            context,
                            listen: false);
                        double _shippingCost = order.shippingIndex == 0 &&
                                order.shippingIndex != null
                            ? order.shippingList[order.shippingIndex].cost
                            : order.shippingIndex == 1
                                ? _preview.resultPreviewModel != null
                                    ? _preview.resultPreviewModel.totalFee
                                        .toDouble()
                                    : 0
                                : Provider.of<PreviewGHTKProvider>(context,
                                                listen: false)
                                            .resultPreviewGHTKModel !=
                                        null
                                    ? Provider.of<PreviewGHTKProvider>(context,
                                            listen: false)
                                        .resultPreviewGHTKModel
                                        .fee
                                        .toDouble()
                                    : 0;
                        double _couponDiscount =
                            Provider.of<CouponProvider>(context).discount !=
                                    null
                                ? Provider.of<CouponProvider>(context).discount
                                : 0;
                        _amount = PriceConverter.convertPriceTMoMo(
                            context,
                            _order +
                                _shippingCost -
                                _discount -
                                _couponDiscount +
                                _tax);
                        var _feeDetails = order.shippingIndex == 1
                            ? "(${getTranslated('MAIN_SERVICE', context)}: ${PriceConverter.convertPrice(context, _preview.feePreview.mainService.toDouble())} + ${getTranslated('INSURANCE', context)}: ${PriceConverter.convertPrice(context, _preview.feePreview.insurance.toDouble())})"
                            : null;
                        var _feeDetailsGHTK = order.shippingIndex == 2
                            ? "(${getTranslated('MAIN_SERVICE', context)}: ${PriceConverter.convertPrice(context, _previewGHTK.resultPreviewGHTKModel.shipFeeOnly.toDouble())} + ${getTranslated('INSURANCE', context)}: ${PriceConverter.convertPrice(context, _previewGHTK.resultPreviewGHTKModel.insuranceFee.toDouble())})"
                            : null;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleRow(title: getTranslated('TOTAL', context)),
                              AmountWidget(
                                  title: getTranslated('ORDER_PRICE', context),
                                  amount: PriceConverter.convertPrice(
                                      context, _order)),
                              AmountWidget(
                                  title: getTranslated('SHIPPING_FEE', context),
                                  amount: PriceConverter.convertPrice(
                                      context, _shippingCost)),
                              _feeDetails != null
                                  ? Text(_feeDetails,
                                      style: titilliumRegular.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL,
                                          color: ColorResources.RED))
                                  : SizedBox.shrink(),
                              _feeDetailsGHTK != null
                                  ? Text(_feeDetailsGHTK,
                                      style: titilliumRegular.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL,
                                          color: ColorResources.RED))
                                  : SizedBox.shrink(),
                              AmountWidget(
                                  title: getTranslated('DISCOUNT', context),
                                  amount: PriceConverter.convertPrice(
                                      context, _discount)),
                              AmountWidget(
                                  title:
                                      getTranslated('coupon_voucher', context),
                                  amount: PriceConverter.convertPrice(
                                      context, _couponDiscount)),
                              AmountWidget(
                                  title: getTranslated('TAX', context),
                                  amount: PriceConverter.convertPrice(
                                      context, _tax)),
                              Divider(
                                  height: 5,
                                  color: Theme.of(context).hintColor),
                              AmountWidget(
                                  title:
                                      getTranslated('TOTAL_PAYABLE', context),
                                  amount: PriceConverter.convertPrice(
                                      context,
                                      (_order +
                                          _shippingCost -
                                          _discount -
                                          _couponDiscount +
                                          _tax))),
                            ]);
                      },
                    ),
                  ),

                  // Payment Method
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    color: Theme.of(context).accentColor,
                    child: Column(children: [
                      TitleRow(title: getTranslated('payment_method', context)),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      CustomCheckBox(
                          title: getTranslated('cash_on_delivery', context),
                          index: 0),
                      CustomCheckBox(
                          title: getTranslated('momo', context), index: 1),
                      Consumer<OrderProvider>(
                        builder: (context, order, child) {
                          return Row(children: [
                            Checkbox(
                                value: order.paymentMethodIndex == 2,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (bool isChecked) async {
                                  order.setPaymentMethod(2);
                                  int amount = _amount.toInt();
                                  if (amount < 1000) {
                                    setState(() {
                                      zpTransToken = "Invalid Amount";
                                    });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        });
                                    var result = await createOrder(amount);
                                    if (result != null) {
                                      Navigator.pop(context);

                                      zpTransToken = result.zptranstoken;
                                      print("zpTransToken $zpTransToken'.");
                                      setState(() {
                                        zpTransToken = result.zptranstoken;
                                        showResult = true;
                                      });
                                    }
                                  }
                                }),
                            Expanded(
                              child: Text(getTranslated('zalo', context),
                                  style: titilliumRegular.copyWith(
                                    color: order.paymentMethodIndex == 2
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color
                                        : ColorResources.getHint(context),
                                  )),
                            ),
                          ]);
                        },
                      ),
                    ]),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID,
      List<CartModel> carts) async {
    if (isSuccess) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => DashBoardScreen()),
          (route) => false);
      showAnimatedDialog(
          context,
          MyDialog(
            icon: Icons.check,
            title: getTranslated('order_placed', context),
            description: getTranslated('your_order_placed', context),
            isFailed: false,
          ),
          dismissible: false,
          isFlip: true);

      Provider.of<OrderProvider>(context, listen: false).stopLoader();

      if (!widget.fromProductDetails) {
        Provider.of<CartProvider>(context, listen: false)
            .removeCheckoutProduct(carts);
        Provider.of<ProductProvider>(context, listen: false)
            .getLatestProductList(
          '1',
          context,
          Provider.of<LocalizationProvider>(context, listen: false)
              .locale
              .languageCode,
          reload: true,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message), backgroundColor: ColorResources.RED));
    }
  }

  void _callbackEwallet() {
    MomoPaymentInfo options = MomoPaymentInfo(
        //tên đối tác
        merchantname: "6VALLEY",
        //hiển thị tên đối tác trên app momo
        merchantnamelabel: "6VALLEY",
        appScheme: "momowxhq20210819",
        merchantcode: 'MOMOWXHQ20210819',
        //số tiền
        amount: _amount,
        //mã giao dịch
        // orderId: "12321312",
        orderLabel: 'Thanh toán mua hàng',

        //phí giao dịch
        fee: 0,
        //nội dung
        description: 'Thanh toán mua hàng',
        //tài khoản
        username:
            "${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName} ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName}",
        partner: "merchant",
        extra: "{\"key1\":\"value1\",\"key2\":\"value2\"}",
        isTestMode: true);
    try {
      _momoPay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _callbackZaloPay(String zpToken) {
    FlutterZaloPaySdk.payOrder(zpToken: zpToken).listen((event) {
      setState(() {
        switch (event) {
          case FlutterZaloPayStatus.cancelled:
            payResult = "User Huỷ Thanh Toán";
            break;
          case FlutterZaloPayStatus.success:
            payResult = "Thanh toán thành công";
            break;
          case FlutterZaloPayStatus.failed:
            payResult = "Thanh toán thất bại";
            break;
          default:
            payResult = "Thanh toán thất bại";
            break;
        }
      });
      if (payResult.trim() == payResultReturnSuccess.trim()) {
        Provider.of<OrderProvider>(context, listen: false)
            .placeOrder(xxx, _callback, widget.cartList);
        if (Provider.of<OrderProvider>(context, listen: false).shippingIndex ==
            1) {
          Provider.of<CreateShippingProvider>(context, listen: false)
              .createShipping(context, createShipping);
        }
        if (Provider.of<OrderProvider>(context, listen: false).shippingIndex ==
            2) {
          Provider.of<CreateGHTKProvider>(context, listen: false)
              .createGHTK(createGHTKModel);
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => DashBoardScreen()),
            (route) => false);
        showAnimatedDialog(
            context,
            MyDialog(
              icon: Icons.check,
              title: getTranslated('order_placed', context),
              description: getTranslated('your_order_placed', context),
              isFailed: false,
            ),
            dismissible: false,
            isFlip: true);
      } else if (payResult.trim() == payResultReturnFailure.trim()) {
        showAnimatedDialog(
            context,
            MyDialog(
              icon: Icons.check,
              title: getTranslated('sorry', context),
              description: getTranslated('your_order_place_failed', context),
              isFailed: false,
            ),
            dismissible: false,
            isFlip: true);
      } else {
        showAnimatedDialog(
            context,
            MyDialog(
              icon: Icons.check,
              title: getTranslated('sorry', context),
              description: getTranslated('your_order_place_cancelled', context),
              isFailed: false,
            ),
            dismissible: false,
            isFlip: true);
      }
    });
  }
}

class PaymentButton extends StatelessWidget {
  final String image;
  final Function onTap;
  PaymentButton({@required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: ColorResources.getGrey(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(image),
      ),
    );
  }
}
