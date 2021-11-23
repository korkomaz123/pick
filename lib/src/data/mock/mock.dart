import 'package:markaa/src/data/models/delivery_rule_entity.dart';
import 'package:markaa/src/data/models/index.dart';

List<CategoryEntity> homeCategories = [];
List<RegionEntity> regions = [];
List<ShippingMethodEntity> shippingMethods = [];
List<PaymentMethodEntity> paymentMethods = [];
DeliveryRuleEntity? deliveryRule;
Map<String, dynamic> orderDetails = {};

List<String> sortByList = [
  'price_low_high',
  'price_high_low',
  'sort_by_brand',
  'name_az',
  'name_za',
];

List<String> enAlphabetList = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];

List<String> arAlphabetList = [
  'ا',
  'ب',
  'ت',
  'ث',
  'ج',
  'ح',
  'خ',
  'د',
  'ذ',
  'ر',
  'ز',
  'س',
  'ش',
  'ص',
  'ض',
  'ط',
  'ظ',
  'ع',
  'غ',
  'ف',
  'ق',
  'ك',
  'ل',
  'م',
  'ن',
  'ه',
  'و',
  'ي'
];

MessageEntity message = MessageEntity(
  time: '28-09-2020',
  title: 'Profile updated',
  content:
      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
);

List<MessageEntity> messages = List.generate(20, (index) => message).toList();

UserEntity? user;
String deviceToken = '';
String lang = 'en';
bool isNotification = true;

Map<String, dynamic> emptyAddress = {
  'customer_address_id': '',
  'prefix': '',
  'firstname': '',
  'lastname': '',
  'fullName': '',
  'country_name': '',
  'country_id': '',
  'region': '',
  'region_id': '',
  'city': '',
  'street': '',
  'postcode': '',
  'telephone': '',
  'company': '',
  'email': '',
};

String gDashboardSessionUrl = '';
String gDashboardVisitorUrl = '';
