class ProdutoCategoriaModel {
  final String id;
  final String nome;
  final String imagem;

  ProdutoCategoriaModel({
    required this.id,
    required this.nome,
    required this.imagem,
  });

  factory ProdutoCategoriaModel.fromMap(Map<String, dynamic> map) {
    return ProdutoCategoriaModel(
      id: map['idMeal'],
      nome: map['strMeal'],
      imagem: map['strMealThumb'],
    );
  }
}
