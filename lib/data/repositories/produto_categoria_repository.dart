import 'dart:convert';
import 'package:cardapio_sushi_layout/data/http/http_client.dart';
import 'package:cardapio_sushi_layout/data/models/produto_categoria_model.dart';

abstract class IProdutoCategoriaRepository {
  Future<List<ProdutoCategoriaModel>> getByCategoria(String categoria);
}

class ProdutoCategoriaRepository implements IProdutoCategoriaRepository {
  final IHttpClient client;

  ProdutoCategoriaRepository({required this.client});

  @override
  Future<List<ProdutoCategoriaModel>> getByCategoria(String categoria) async {
    final response = await client.get(
      url: 'https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoria',
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (body['meals'] as List)
          .map((e) => ProdutoCategoriaModel.fromMap(e))
          .toList();
    } else {
      throw Exception('Erro ao buscar produtos da categoria $categoria');
    }
  }
}
