import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghtk_model/preview_ghtk_model.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/pick_add_ghtk_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/preview_ghtk_provider.dart';

import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ShippingMethodBottomSheet extends StatelessWidget {
  final double orderValue;
  final bool evaluate;
  ShippingMethodBottomSheet({this.orderValue, this.evaluate});
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

        Consumer<OrderProvider>(
          builder: (context, order, child) {
            return order.shippingList != null
                ? order.shippingList.length != 0
                    ? SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: order.shippingList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              title: Text('${order.shippingList[index].title}'),
                              value: index,
                              groupValue: order.shippingIndex,
                              activeColor: Theme.of(context).primaryColor,
                              toggleable: true,
                              onChanged: evaluate && index == 1
                                  ? null
                                  : (value) async {
                                      if (value == 2) {
                                        String _provinceName =
                                            Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .addressList[order.addressIndex]
                                                .province;
                                        String _districtName =
                                            Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .addressList[order.addressIndex]
                                                .district;
                                        String _addressName =
                                            Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .addressList[order.addressIndex]
                                                .address;
                                        var _previewGHTK = PreviewGHTKModel(
                                            pickAddressId: Provider.of<
                                                        PickAddGHTKProvider>(
                                                    context,
                                                    listen: false)
                                                .pickAddModel
                                                .first
                                                .pickAddressId,
                                            province: _provinceName,
                                            district: _districtName,
                                            address: _addressName,
                                            weight: 1000,
                                            value: orderValue.toInt(),
                                            transport: "road",
                                            deliverOption: "none");
                                        await Provider.of<PreviewGHTKProvider>(
                                                context,
                                                listen: false)
                                            .getPreviewGHTK(_previewGHTK);
                                      }
                                      Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .setSelectedShippingAddress(value);

                                      Navigator.pop(context);
                                    },
                            );
                          },
                        ),
                      )
                    : Center(child: Text('No method available'))
                : Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)));
          },
        ),
      ]),
    );
  }
}
