
class ProdutoModel {
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  ProdutoModel({
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      strCategory: map['strCategory'],
      strCategoryThumb: map['strCategoryThumb'],
      strCategoryDescription: map['strCategoryDescription'],
    );
  }
}
