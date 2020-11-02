import 'package:ciga/src/data/models/adress_entity.dart';
import 'package:ciga/src/data/models/category_menu_entity.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/message_entity.dart';
import 'package:ciga/src/data/models/order_entity.dart';

/// category list for home screen
final List<CategoryEntity> homeCategories = [
  CategoryEntity(
    id: '41',
    name: 'Best Deal',
    products: products,
    subCategories: subCategories,
  ),
  CategoryEntity(
    id: '42',
    name: 'New Arrivals',
    products: products,
    subCategories: subCategories,
  ),
  CategoryEntity(
    id: '43',
    name: 'Perfumes',
    products: products,
    subCategories: subCategories,
  ),
];

final List<CategoryEntity> subCategories = [
  CategoryEntity(id: 'all', name: 'All', products: products),
  CategoryEntity(id: 'sub1', name: 'Sub1', products: products),
  CategoryEntity(id: 'sub2', name: 'Sub2', products: products),
  CategoryEntity(id: 'sub3', name: 'Sub3', products: products),
  CategoryEntity(id: 'sub4', name: 'Sub4', products: products),
  CategoryEntity(id: 'sub5', name: 'Sub5', products: products),
  CategoryEntity(id: 'sub6', name: 'Sub6', products: products),
  CategoryEntity(id: 'sub7', name: 'Sub7', products: products),
];

final List<CategoryEntity> allCategories = List.generate(
  6,
  (index) => CategoryEntity(
    id: index.toString(),
    name: 'Category ${index + 1}',
    imageUrl: 'lib/public/images/category${index + 1}.png',
    products: products,
    subCategories: subCategories,
  ),
).toList();

/// mockup products list
final List<ProductEntity> products = List.generate(
  10,
  (index) => ProductEntity(
    id: index.toString(),
    name: 'Product Name $index',
    description:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    price: 3.450,
    discount: 25,
    store: store1,
  ),
).toList();

final StoreEntity store1 = StoreEntity(
  id: '1',
  name: 'Store1',
  products: [],
);

List<String> topCategoryItems = [
  'All',
  'French Perfumes',
  'Arabian Perfumes',
  'American Perfumes',
  'Aisa Perfumes',
];

final List<StoreEntity> stores = List.generate(
  10,
  (index) => StoreEntity(
    id: index.toString(),
    name: 'Brand ${index + 1}',
    imageUrl: 'lib/public/images/brand${index + 1}.png',
    products: products,
  ),
);

final List<CartItemEntity> myCartItems = [
  CartItemEntity(product: products[0], itemCount: 3),
  CartItemEntity(product: products[0], itemCount: 2),
  CartItemEntity(product: products[0], itemCount: 4),
];

final List<OrderEntity> orders = [
  OrderEntity(
    orderNo: '129292',
    orderDate: '18/11/2020',
    status: OrderStatusEnum.pending,
    paymentMethod: 'Cash On Delivery',
    totalPrice: '2029',
  ),
  OrderEntity(
    orderNo: '129293',
    orderDate: '21/11/2020',
    status: OrderStatusEnum.onProgress,
    paymentMethod: 'Visa Card',
    totalPrice: '882',
  ),
  OrderEntity(
    orderNo: '129294',
    orderDate: '3/12/2020',
    status: OrderStatusEnum.delivered,
    paymentMethod: 'KNet',
    totalPrice: '1029',
  ),
  OrderEntity(
    orderNo: '129295',
    orderDate: '11/12/2020',
    status: OrderStatusEnum.onProgress,
    paymentMethod: 'Cash On Delivery',
    totalPrice: '2726',
  ),
];

List<String> sortByList = [
  'Price (Low to High)',
  'Price (High to Low)',
  'Sort By Brand',
  'Products on Sale',
  'Name (A - Z)',
  'Name (Z - A)',
];

List<CategoryMenuEntity> categoryMenu = List.generate(
  5,
  (menuIndex) => CategoryMenuEntity(
    id: '${menuIndex + 1}',
    title: 'menu${menuIndex + 1}',
    subMenu: List.generate(
      4,
      (subMenuIndex) => CategoryMenuEntity(
        id: '${menuIndex + 1} - ${subMenuIndex + 1}',
        title: 'submenu${menuIndex + 1}-${subMenuIndex + 1}',
        subMenu: List.generate(
          6,
          (subSubMenuIndex) => CategoryMenuEntity(
            id: '${menuIndex + 1} - ${subMenuIndex + 1} - ${subSubMenuIndex + 1}',
            title:
                'subsubmenu${menuIndex + 1} - ${subMenuIndex + 1} - ${subSubMenuIndex + 1}',
            subMenu: [],
          ),
        ),
      ),
    ),
  ),
);

List<String> colorItems = ['#FD0000', '#F5FF00', '#00A7FF', '#853299'];

String aboutUsText =
    '''Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor''';

MessageEntity message = MessageEntity(
  time: '28-09-2020',
  title: 'Profile updated',
  content:
      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.',
);

List<MessageEntity> messages = List.generate(20, (index) => message).toList();

List<AddressEntity> shippingAddresses = List.generate(4, (index) {
  return AddressEntity(
    country: 'Kuwait',
    city: 'Salmaya Salem Almubarak',
    street: 'Street',
    zipCode: '00232',
    phoneNumber: '+9653373373',
  );
}).toList();

UserEntity user;

String lang = 'en';
