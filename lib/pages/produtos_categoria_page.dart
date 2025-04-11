import 'dart:convert';
import 'package:cardapio_sushi_layout/data/http/http_client.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProdutosCategoriaPage extends StatefulWidget {
  final String nomeCategoria;

  const ProdutosCategoriaPage({super.key, required this.nomeCategoria});

  @override
  State<ProdutosCategoriaPage> createState() => _ProdutosCategoriaPageState();
}

class _ProdutosCategoriaPageState extends State<ProdutosCategoriaPage> {
  bool isLoading = true;
  String? erro;
  List produtos = [];

  @override
  void initState() {
    super.initState();
    fetchProdutos();
  }

  Future<void> fetchProdutos() async {
    final client = HttpClient();
    final response = await client.get(
      url: 'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.nomeCategoria}',
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      setState(() {
        produtos = body['meals'];
        isLoading = false;
      });
    } else {
      setState(() {
        erro = 'Erro ao carregar os produtos';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(widget.nomeCategoria, style: TextStyle(color: Colors.grey[900])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey[900]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      title: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 16,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                      subtitle: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 12,
                          margin: EdgeInsets.only(top: 4),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              )
            : erro != null
                ? Center(
                    child: Text(
                      erro!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      final item = produtos[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Image.network(
                            item['strMealThumb'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['strMeal']),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Aqui pode navegar para a tela de detalhe do prato
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
