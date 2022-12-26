import 'package:flutter_sixvalley_ecommerce/data/model/response/language_model.dart';

class AppConstants {
  static const String USER_MONGO = 'ldtrong258';
  static const String PASSWORD_MONGO = 'ueLahApixRBTr8Ua';
  static const String MONGO_CONN_URL = 'mongodb+srv://$USER_MONGO:$PASSWORD_MONGO@cluster0.snfnv.mongodb.net/blockchain?retryWrites=true&w=majority';
  static const String USER_COLLECTION = 'eblockchain';
  // static const String BASE_URL = 'https://10.0.0.2';
  static const String BASE_URL = 'https://ecom2.toolgencode.com/';
  static const String USER_ID = 'userId';
  static const String NAME = 'name';
  static const String CATEGORIES_URI = 'api/v1/categories';
  static const String BRANDS_URI = 'api/v1/brands';
  static const String BRAND_PRODUCT_URI = 'api/v1/brands/products/';
  static const String CATEGORY_PRODUCT_URI = 'api/v1/categories/products/';
  static const String REGISTRATION_URI = 'api/v1/auth/register';
  static const String LOGIN_URI = 'api/v1/auth/login';
  static const String LATEST_PRODUCTS_URI =
      'api/v1/products/latest?limit=10&&offset=';
  static const String PRODUCT_DETAILS_URI = 'api/v1/products/details/';
  static const String PRODUCT_REVIEW_URI = 'api/v1/products/reviews/';
  static const String SEARCH_URI = 'api/v1/products/search?name=';
  static const String CONFIG_URI = 'api/v1/config';
  static const String ADD_WISH_LIST_URI =
      'api/v1/customer/wish-list/add?product_id=';
  static const String REMOVE_WISH_LIST_URI =
      'api/v1/customer/wish-list/remove?product_id=';
  static const String UPDATE_PROFILE_URI = 'api/v1/customer/update-profile';
  static const String CUSTOMER_URI = 'api/v1/customer/info';
  static const String ADDRESS_LIST_URI = 'api/v1/customer/address/list';
  static const String PROVINCE_URI = 'api/v1/location/province/';
  static const String DISTRICT_URI = 'api/v1/location/district/';
  static const String WARD_URI = 'api/v1/location/ward/';
  static const String REMOVE_ADDRESS_URI =
      'api/v1/customer/address?address_id=';
  static const String ADD_ADDRESS_URI = 'api/v1/customer/address/add';
  static const String WISH_LIST_GET_URI = 'api/v1/customer/wish-list';
  static const String SUPPORT_TICKET_URI =
      'api/v1/customer/support-ticket/create';
  static const String MAIN_BANNER_URI =
      'api/v1/banners?banner_type=main_banner';
  static const String FOOTER_BANNER_URI =
      'api/v1/banners?banner_type=footer_banner';
  static const String RELATED_PRODUCT_URI = 'api/v1/products/related-products/';
  static const String ORDER_URI = 'api/v1/customer/order/list';
  static const String ORDER_DETAILS_URI =
      'api/v1/customer/order/details?order_id=';
  static const String ORDER_PLACE_URI = 'api/v1/customer/order/place';
  static const String SELLER_URI = 'api/v1/seller?seller_id=';
  static const String SELLER_PRODUCT_URI = 'api/v1/seller/';
  static const String TRACKING_URI = 'api/v1/order/track?order_id=';
  static const String FORGET_PASSWORD_URI = 'api/v1/auth/forgot-password';
  static const String SUPPORT_TICKET_GET_URI =
      'api/v1/customer/support-ticket/get';
  static const String SUBMIT_REVIEW_URI = 'api/v1/products/reviews/submit';
  static const String FLASH_DEAL_URI = 'api/v1/flash-deals';
  static const String FLASH_DEAL_PRODUCT_URI = 'api/v1/flash-deals/products/';
  static const String COUNTER_URI = 'api/v1/products/counter/';
  static const String SOCIAL_LINK_URI = 'api/v1/products/social-share-link/';
  static const String SHIPPING_URI = 'api/v1/products/shipping-methods';
  static const String COUPON_URI = 'api/v1/coupon/apply?code=';
  static const String MESSAGES_URI = 'api/v1/customer/chat/messages?shop_id=';
  static const String CHAT_INFO_URI = 'api/v1/customer/chat';
  static const String SEND_MESSAGE_URI = 'api/v1/customer/chat/send-message';
  static const String TOKEN_URI = 'api/v1/customer/cm-firebase-token';
  static const String NOTIFICATION_URI = 'api/v1/notifications';

  // sharePreference
  static const String TOKEN = 'token';
  static const String USER = 'user';
  static const String USER_EMAIL = 'user_email';
  static const String USER_PASSWORD = 'user_password';
  static const String HOME_ADDRESS = 'home_address';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String OFFICE_ADDRESS = 'office_address';
  static const String CART_LIST = 'cart_list';
  static const String CONFIG = 'config';
  static const String GUEST_MODE = 'guest_mode';
  static const String CURRENCY = 'currency';
  static const String LANG_KEY = 'lang';

  // order status
  static const String PENDING = 'pending';
  static const String CONFIRMED = 'confirmed';
  static const String PROCESSING = 'processing';
  static const String PROCESSED = 'processed';
  static const String DELIVERED = 'delivered';
  static const String FAILED = 'failed';
  static const String RETURNED = 'returned';
  static const String CANCELLED = 'cancelled';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String THEME = 'theme';
  static const String TOPIC = 'sixvalley';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: '',
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    // LanguageModel(imageUrl: '', languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  ];

  //giao hang nhanh
  static const BASE_URL_API =
      "https://dev-online-gateway.ghn.vn/shiip/public-api/";
  static const PREVIEW =
      "v2/shipping-order/preview"; // lấy thông tin đơn hàng trước khi tạo
  static const LEAD_TIME =
      "v2/shipping-order/leadtime"; // tính thời gian dự kiến giao hàng
  static const UPDATE =
      "v2/shipping-order/update"; // thay đổi thông tin đơn hàng
  static const CANCEL = "v2/switch-status/cancel"; // huỷ đơn hàng
  static const RETURN = "v2/switch-status/return"; // trả lại hàng
  static const DETAIL = "v2/shipping-order/detail"; // lấy chi tiết của đơn hàng
  static const STORING = "v2/switch-status/storing"; // giao lại đơn hàng
  static const UPDATE_COD =
      "v2/shipping-order/updateCOD"; //thay đổi COD của đơn hàng
  static const GET_STATION = "v2/station/get"; // lấy danh sách bưu cục
  static const SOC =
      "v2/shipping-order/soc"; // lấy chi tiết phí dịch vụ của đơn hàng
  static const CREATE = "v2/shipping-order/create"; // tạo đơn
  static const DISTRICT =
      "master-data/district"; //lấy danh sách mã quận - huyện
  static const WARD_DISTRICT_ID =
      "master-data/ward?district_id"; // lấy danh sách mã phường - xã
  static const PROVINCE =
      "master-data/province"; //lấy danh sách mã tỉnh - thành
  static const SHOP_ALL = "v2/shop/all"; // lấy danh sách shop

  //giao hang tiet kiem
  static const BASE_URL_GHTK =
      "https://services.giaohangtietkiem.vn/services/shipment/";
  static const PREVIEW_GHTK = "fee";
  static const CREATE_GHTK = "order";
  static const LIST_PICK_ADD = "list_pick_add";
}
