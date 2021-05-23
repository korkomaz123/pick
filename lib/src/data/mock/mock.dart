import 'package:markaa/src/data/models/index.dart';

/// category list for home screen
List<CategoryEntity> homeCategories = [];

List<RegionEntity> regions = [];
int wishlistCount = 0;
List<ProductModel> wishlistItems = [];
List<String> wishlistIds = [];

Map<String, dynamic> orderDetails = {};
List<ShippingMethodEntity> shippingMethods = [];
List<PaymentMethodEntity> paymentMethods = [];

List<String> sortByList = [
  'price_low_high',
  'price_high_low',
  'sort_by_brand',
  'name_az',
  'name_za',
];

MessageEntity message = MessageEntity(
  time: '28-09-2020',
  title: 'Profile updated',
  content:
      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
);

List<MessageEntity> messages = List.generate(20, (index) => message).toList();

UserEntity user;
String deviceToken = '';
String lang = 'en';
bool isNotification = true;

List<TransactionEntity> transactions = [
  TransactionEntity(
    number: '292833',
    amount: 1200,
    date: '21/3/2021',
    type: TransactionType.order,
  ),
  TransactionEntity(
    number: '123456',
    amount: -223,
    date: '21/3/2021',
    type: TransactionType.order,
  ),
  TransactionEntity(
    number: '221123',
    amount: 288,
    date: '21/3/2021',
    type: TransactionType.bank,
  ),
  TransactionEntity(
    number: '2928384',
    amount: 102,
    date: '21/3/2021',
    type: TransactionType.debit,
  ),
];

List<BankAccountEntity> bankAccounts = [
  BankAccountEntity(
    title: 'My account',
    bank: 'global bank',
    name: 'name',
    iBan: '2232222',
  ),
  BankAccountEntity(
    title: 'Wife account',
    bank: 'global bank',
    name: 'name',
    iBan: '2232222',
  ),
  BankAccountEntity(
    title: 'mother account',
    bank: 'global bank',
    name: 'name',
    iBan: '2232222',
  ),
];