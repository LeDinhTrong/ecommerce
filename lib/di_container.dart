import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';

import 'package:flutter_sixvalley_ecommerce/data/repository/auth_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/banner_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/brand_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/cart_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/category_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/chat_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/coupon_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/flash_deal_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/create_shipping_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/district_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/preview.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/province_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/shop_all_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/ward_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghtk_repo/create_ghtk_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghtk_repo/pick_add_ghtk_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghtk_repo/preview_ghtk_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/notification_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/onboarding_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/product_details_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/order_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/product_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/profile_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/search_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/seller_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/splash_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/support_ticket_repo.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/wishlist_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/chat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/coupon_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/flash_deal_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/create_shipping_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/district_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/preview.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/province_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/shop_all_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghn_provider/ward_district_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/create_ghtk_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/pick_add_ghtk_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ghtk_provider/preview_ghtk_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/notification_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/onboarding_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/support_ticket_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasource/remote/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  // sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(),
  //     loggingInterceptor: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => DioClient(sl(), loggingInterceptor: sl(), sharedPreferences: sl()));
  // sl.registerLazySingleton(() => DioUtil(AppConstants.BASE_URL_API, sl()));

  // Repository
  sl.registerLazySingleton(() => ShopAllRepo(dioClient: sl()));
  sl.registerLazySingleton(() => PickAddGHTKRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CreateGHTKRepo(dioClient: sl()));
  sl.registerLazySingleton(() => PreviewGHTKRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WardDistrictRepo(dioClient: sl()));
  sl.registerLazySingleton(() => DistrictRepo(dioClient: sl()));
  sl.registerLazySingleton(() => PreviewRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CreateShippingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProvinceRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => FlashDealRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BrandRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BannerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProductDetailsRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => SearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl()));
  sl.registerLazySingleton(() => SellerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CouponRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => WishListRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CartRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => SupportTicketRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => ShopAllProvider(shopAllRepo: sl()));
  sl.registerFactory(() => PickAddGHTKProvider(pickAddGHTKRepo: sl()));
  sl.registerFactory(() => CreateGHTKProvider(createGHTKRepo: sl()));
  sl.registerFactory(() => PreviewGHTKProvider(previewGHTKRepo: sl()));
  sl.registerFactory(() => WardDistrictProvider(wardDistrictRepo: sl()));
  sl.registerFactory(() => DistrictProvider(districtRepo: sl()));
  sl.registerFactory(() => PreviewProvider(previewRepo: sl()));
  sl.registerFactory(() => CreateShippingProvider(createShippingRepo: sl()));
  sl.registerFactory(() => ProvinceProvider(provinceRepo: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl()));
  sl.registerFactory(() => FlashDealProvider(megaDealRepo: sl()));
  sl.registerFactory(() => BrandProvider(brandRepo: sl()));
  sl.registerFactory(() => ProductProvider(productRepo: sl()));
  sl.registerFactory(() => BannerProvider(bannerRepo: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ProductDetailsProvider(productDetailsRepo: sl()));
  sl.registerFactory(() => SearchProvider(searchRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl()));
  sl.registerFactory(() => SellerProvider(sellerRepo: sl()));
  sl.registerFactory(() => CouponProvider(couponRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(
      () => WishListProvider(wishListRepo: sl(), productDetailsRepo: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => CartProvider(cartRepo: sl()));
  sl.registerFactory(() => SupportTicketProvider(supportTicketRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());
}
