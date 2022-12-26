import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/mongoDb.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_details_screen.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  // String id;
  OrderWidget({this.orderModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
                  orderModel: orderModel,
                  orderId: orderModel.id,
                  orderHash: orderModel.orderHash,
                )));
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: Dimensions.PADDING_SIZE_SMALL,
          left: Dimensions.PADDING_SIZE_SMALL,
          right: Dimensions.PADDING_SIZE_SMALL,
        ),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            if (orderModel.orderHash != null && orderModel.orderHash != 'null')
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Hash:\t',
                    style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Flexible(
                    child: Text(orderModel.orderHash.toString(),
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: titilliumSemiBold),
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            getTranslated('ORDER_ID', context),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Text(orderModel.id.toString(), style: titilliumSemiBold),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            getTranslated('order_date', context),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Text(
                            DateConverter.isoStringToLocalDateOnly(orderModel.createdAt),
                            style: titilliumRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            getTranslated('total_price', context),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Text(
                            PriceConverter.convertPrice(context, orderModel.orderAmount),
                            style: titilliumSemiBold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          color: ColorResources.getLowGreen(context),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(getTranslated(orderModel.orderStatus, context),
                            style: titilliumSemiBold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
