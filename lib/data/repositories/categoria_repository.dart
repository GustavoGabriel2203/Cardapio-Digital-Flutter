import 'dart:convert';

import 'package:cardapio_sushi_layout/data/http/exceptions.dart';
import 'package:cardapio_sushi_layout/data/http/http_client.dart';

import '../models/categoria_model.dart';

abstract class IProdutoRepository {
  Future<List<ProdutoModel>> getProdutos();
}

class ProdutoRepository implements IProdutoRepository {
  final IHttpClient client;

  ProdutoRepository({required this.client});

  @override
  Future<List<ProdutoModel>> getProdutos() async {
    final response = await client.get(
      url: 'https://www.themealdb.com/api/json/v1/1/categories.php',
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final produtos = (body['categories'] as List)
          .map((item) => ProdutoModel.fromMap(item))
          .toList();

      return produtos;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A URL informada não é válida');
    } else {
      throw Exception('Não foi possível carregar os produtos');
    }
  }
}
