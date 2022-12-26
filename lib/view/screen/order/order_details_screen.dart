import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/seller/seller_screen.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_details.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_loader.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/order_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_ticket_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/tracking/tracking_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:momo_vn/momo_vn.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final int orderId;
  final String orderHash;
  OrderDetailsScreen({@required this.orderModel, @required this.orderId, @required this.orderHash});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // double _amount = 0;
  MomoVn _momoPay;

  @override
  void initState() {
    super.initState();
    _momoPay = MomoVn();
    _momoPay.on(MomoVn.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _momoPay.on(MomoVn.EVENT_PAYMENT_ERROR, _handlePaymentError);
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {});
  }

  void _handlePaymentSuccess(PaymentResponse response) {
    Fluttertoast.showToast(
        msg: "THÀNH CÔNG: " + response.message.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentResponse response) {
    Fluttertoast.showToast(
        msg: "THẤT BẠI: " + response.message.toString(), toastLength: Toast.LENGTH_SHORT);
  }

  void _loadData(BuildContext context) async {
    await Provider.of<OrderProvider>(context, listen: false)
        .initTrackingInfo(widget.orderId.toString(), widget.orderModel, true, context);
    if (widget.orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false).initConfig(context);
    }
    Provider.of<SellerProvider>(context, listen: false).removePrevOrderSeller();
    await Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    await Provider.of<OrderProvider>(context, listen: false).initShippingList(context);
    Provider.of<OrderProvider>(context, listen: false).getOrderDetails(
      widget.orderId.toString(),
      context,
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context);

    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: getTranslated('ORDER_DETAILS', context)),
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, order, child) {
                //TODO: seller
                List<int> sellerList = [];
                List<List<OrderDetailsModel>> sellerProductList = [];
                double _order = 0;
                double _discount = 0;
                double _tax = 0;
                String shippingPartner = '';
                double _shippingFee = 0;
                String shippingAddress = '';

                if (order.orderDetails != null) {
                  //TODO: seller
                  order.orderDetails.forEach((orderDetails) {
                    if (!sellerList.contains(orderDetails.productDetails.userId)) {
                      sellerList.add(orderDetails.productDetails.userId);
                    }
                  });
                  sellerList.forEach((seller) {
                    Provider.of<SellerProvider>(context, listen: false)
                        .initSeller(seller.toString(), context);
                    List<OrderDetailsModel> orderList = [];
                    order.orderDetails.forEach((orderDetails) {
                      if (seller == orderDetails.productDetails.userId) {
                        orderList.add(orderDetails);
                      }
                    });
                    sellerProductList.add(orderList);
                  });

                  order.orderDetails.forEach((orderDetails) {
                    _order = _order + (orderDetails.price * orderDetails.qty);
                    _discount = _discount + orderDetails.discount;
                    _tax = _tax + (orderDetails.tax * orderDetails.qty);
                    _shippingFee = orderDetails.shippingCost;
                  });

                  if (order.shippingList != null) {
                    order.shippingList.forEach((shipping) {
                      if (shipping.id == order.orderDetails[0].shippingMethodId) {
                        shippingPartner = shipping.title;
                      }
                    });
                  }
                }

                return order.orderDetails != null
                    ? ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(0),
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: getTranslated('ORDER_ID', context),
                                      style: titilliumRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: Theme.of(context).textTheme.bodyText1.color,
                                      )),
                                  TextSpan(
                                      text: order.trackingModel.id.toString(),
                                      style: titilliumSemiBold.copyWith(
                                          color: ColorResources.getPrimary(context))),
                                ],
                              ),
                            ),
                          ),
                          if (widget.orderHash != null && widget.orderHash != 'null')
                            Container(
                              margin: EdgeInsets.only(
                                bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                left: Dimensions.PADDING_SIZE_SMALL,
                                right: Dimensions.PADDING_SIZE_SMALL,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Hash: ',
                                    style: titilliumRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Flexible(
                                    child: Text(
                                      widget.orderHash,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: titilliumSemiBold.copyWith(
                                          color: ColorResources.getPrimary(context)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.all(Dimensions.MARGIN_SIZE_SMALL),
                            decoration: BoxDecoration(color: Theme.of(context).accentColor),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getTranslated('SHIPPING_TO', context),
                                        style: titilliumRegular),
                                    SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                                    Expanded(
                                      child: Consumer<ProfileProvider>(
                                        builder: (context, profile, child) {
                                          if (profile.addressList != null) {
                                            profile.addressList.forEach((address) {
                                              if (address.id.toString() ==
                                                  order.trackingModel.shippingAddress) {
                                                shippingAddress = address.address ?? '';
                                              }
                                            });
                                          }
                                          return Text(
                                            shippingAddress,
                                            style: titilliumRegular.copyWith(
                                                color: ColorResources.getPrimary(context),
                                                fontSize: Dimensions.FONT_SIZE_SMALL),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(getTranslated('SHIPPING_PARTNER', context),
                                            style: titilliumRegular)),
                                    Text(
                                      shippingPartner,
                                      style: titilliumSemiBold.copyWith(
                                          color: ColorResources.getPrimary(context)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),

                          Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            color: Theme.of(context).accentColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated('ORDERED_PRODUCT', context),
                                  style: robotoBold.copyWith(color: Theme.of(context).hintColor),
                                ),
                                Divider(),
                              ],
                            ),
                          ),

                          //TODO: seller
                          ListView.builder(
                            itemCount: sellerList.length,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                                  vertical: Dimensions.MARGIN_SIZE_SMALL,
                                ),
                                color: Theme.of(context).accentColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (Provider.of<SellerProvider>(context, listen: false)
                                                    .orderSellerList
                                                    .length !=
                                                0 &&
                                            sellerList[index] != 1) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) {
                                              return SellerScreen(
                                                  seller: Provider.of<SellerProvider>(context,
                                                          listen: false)
                                                      .orderSellerList[index]);
                                            }),
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(getTranslated('seller', context),
                                                  style: robotoBold)),
                                          Text(
                                            sellerList[index] == 1
                                                ? 'Admin'
                                                : Provider.of<SellerProvider>(context)
                                                            .orderSellerList
                                                            .length <
                                                        index + 1
                                                    ? sellerList[index].toString()
                                                    : '${Provider.of<SellerProvider>(context).orderSellerList[index].fName} '
                                                        '${Provider.of<SellerProvider>(context).orderSellerList[index].lName}',
                                            style: titilliumRegular.copyWith(
                                                color: ColorResources.HINT_TEXT_COLOR),
                                          ),
                                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          Icon(
                                            Icons.chat,
                                            color: Theme.of(context).primaryColor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      getTranslated('ORDERED_PRODUCT', context),
                                      style: robotoBold.copyWith(
                                          color: ColorResources.HINT_TEXT_COLOR),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(0),
                                      itemCount: sellerProductList[index].length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, i) => OrderDetailsWidget(
                                          orderDetailsModel: sellerProductList[index][i],
                                          callback: () {
                                            showCustomSnackBar(
                                                getTranslated('REVIEW_SUBMITTED', context), context,
                                                isError: false);
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),

                          // Amounts
                          Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            color: Theme.of(context).accentColor,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              TitleRow(title: getTranslated('TOTAL', context)),
                              AmountWidget(
                                title: getTranslated('ORDER_PRICE', context),
                                amount: PriceConverter.convertPrice(context, _order),
                              ),
                              AmountWidget(
                                title: getTranslated('SHIPPING_FEE', context),
                                amount: PriceConverter.convertPrice(context, _shippingFee),
                              ),
                              AmountWidget(
                                title: getTranslated('DISCOUNT', context),
                                amount: PriceConverter.convertPrice(context, _discount),
                              ),
                              AmountWidget(
                                title: getTranslated('coupon_voucher', context),
                                amount: PriceConverter.convertPrice(
                                    context, order.trackingModel.discountAmount),
                              ),
                              AmountWidget(
                                title: getTranslated('TAX', context),
                                amount: PriceConverter.convertPrice(context, _tax),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Divider(height: 2, color: ColorResources.HINT_TEXT_COLOR),
                              ),
                              AmountWidget(
                                title: getTranslated('TOTAL_PAYABLE', context),
                                amount: PriceConverter.convertPrice(
                                  context,
                                  (_order + _shippingFee - _discount + _tax),
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),

                          // Payment
                          Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(color: Theme.of(context).accentColor),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(getTranslated('PAYMENT', context), style: robotoBold),
                              SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(getTranslated('PAYMENT_STATUS', context),
                                    style: titilliumRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL)),
                                Text(
                                  (order.trackingModel.paymentStatus != null &&
                                          order.trackingModel.paymentStatus.isNotEmpty)
                                      ? getTranslated(order.trackingModel.paymentStatus, context)
                                      : 'Digital Payment',
                                  style: titilliumRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL),
                                ),
                              ]),
                              SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),

                              //nền tảng thanh toán
                              order.trackingModel.paymentStatus == "unpaid"
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                          Text(getTranslated('PAYMENT_PLATFORM', context),
                                              style: titilliumRegular.copyWith(
                                                  fontSize: Dimensions.FONT_SIZE_SMALL)),
                                          (order.trackingModel.paymentMethod == 'cash' &&
                                                  order.trackingModel.paymentStatus == 'unpaid')
                                              ? InkWell(
                                                  onTap: () async {
                                                    MomoPaymentInfo options = MomoPaymentInfo(
                                                        //tên đối tác
                                                        merchantname: "6VALLEY",
                                                        //hiển thị tên đối tác trên app momo
                                                        merchantnamelabel: "6VALLEY",
                                                        appScheme: "momowxhq20210819",
                                                        merchantcode: 'MOMOWXHQ20210819',
                                                        //số tiền
                                                        amount: PriceConverter.convertPriceTMoMo(
                                                            context,
                                                            _order +
                                                                _shippingFee -
                                                                _discount +
                                                                _tax),
                                                        //mã giao dịch
                                                        orderId: "12321312",
                                                        orderLabel: 'Thanh toán mua hàng',

                                                        //phí giao dịch
                                                        fee: 0,
                                                        //nội dung
                                                        description: 'Thanh toán mua hàng',
                                                        //tài khoản
                                                        username:
                                                            "${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName} ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName}",
                                                        partner: "merchant",
                                                        extra:
                                                            "{\"key1\":\"value1\",\"key2\":\"value2\"}",
                                                        isTestMode: true);
                                                    try {
                                                      _momoPay.open(options);
                                                    } catch (e) {
                                                      debugPrint(e);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                    decoration: BoxDecoration(
                                                      color: ColorResources.getPrimary(context),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Text(getTranslated('pay_now', context),
                                                        style: titilliumSemiBold.copyWith(
                                                          fontSize:
                                                              Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                          color: Theme.of(context).accentColor,
                                                        )),
                                                  ),
                                                )
                                              : Text(
                                                  order.trackingModel.paymentMethod != null
                                                      ? order.trackingModel.paymentMethod
                                                          .replaceAll('_', ' ')
                                                      : 'Digital Payment',
                                                  style: titilliumBold.copyWith(
                                                    color: Theme.of(context).primaryColor,
                                                  )),
                                        ])
                                  : SizedBox(),
                            ]),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          // Buttons
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE,
                                vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    buttonText: getTranslated('TRACK_ORDER', context),
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            TrackingScreen(orderID: widget.orderId.toString()))),
                                  ),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Expanded(
                                  child: SizedBox(
                                    height: 45,
                                    child: TextButton(
                                      onPressed: () => Navigator.push(context,
                                          MaterialPageRoute(builder: (_) => SupportTicketScreen())),
                                      child: Text(
                                        getTranslated('SUPPORT_CENTER', context),
                                        style: titilliumSemiBold.copyWith(
                                          fontSize: 16,
                                          color: ColorResources.getPrimary(context),
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        side: BorderSide(
                                          color: ColorResources.getPrimary(context),
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(child: CustomLoader(color: Theme.of(context).primaryColor));
              },
            ),
          )
        ],
      ),
    );
  }
}
