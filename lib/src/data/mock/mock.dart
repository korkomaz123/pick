import 'package:ciga/src/data/models/index.dart';

/// category list for home screen
final List<CategoryEntity> homeCategories = [
  CategoryEntity(
    id: '1',
    name: 'Best Deal',
    products: products,
  ),
  CategoryEntity(
    id: '2',
    name: 'New Arrival',
    products: products,
  ),
  CategoryEntity(
    id: '3',
    name: 'Perfumes',
    products: products,
  ),
];

final List<CategoryEntity> allCategories = List.generate(
  6,
  (index) => CategoryEntity(
    id: index.toString(),
    name: 'Category ${index + 1}',
    imageUrl: 'lib/public/images/category${index + 1}.png',
    products: products,
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
    name: 'Store ${index+1}',
    imageUrl: 'lib/public/images/brand${index+1}.png',
    products: products,
  ),
);
