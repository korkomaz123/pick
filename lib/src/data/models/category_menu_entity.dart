class CategoryMenuEntity {
  final String id;
  final String title;
  final List<CategoryMenuEntity> subMenu;

  CategoryMenuEntity({
    this.id,
    this.title,
    this.subMenu,
  });

  CategoryMenuEntity.fromJson(Map<String, dynamic> json)
      : id = json['category_id'],
        title = json['label'],
        subMenu = _getChildrenMenus(json['children']);

  static List<CategoryMenuEntity> _getChildrenMenus(dynamic childrens) {
    List<CategoryMenuEntity> subMenus = [];
    if (childrens != null && childrens.length > 0) {
      for (int i = 0; i < childrens.length; i++) {
        subMenus.add(CategoryMenuEntity.fromJson(childrens[i]));
      }
    }
    return subMenus;
  }
}
