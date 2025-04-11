import 'package:cardapio_sushi_layout/data/http/http_client.dart';
import 'package:cardapio_sushi_layout/data/repositories/categoria_repository.dart';
import 'package:cardapio_sushi_layout/pages/produtos_categoria_page.dart';
import 'package:cardapio_sushi_layout/pages/store/categoria_store.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final ProdutoStore store = ProdutoStore(
    repository: ProdutoRepository(client: HttpClient()),
  );

  @override
  void initState() {
    super.initState();
    store.getProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Tokyo', style: TextStyle(color: Colors.grey[900])),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Card de promoção
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(166, 44, 44, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '32% de Desconto!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(166, 44, 44, 0.5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Resgatar", style: TextStyle(color: Colors.white, fontSize: 16)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Image.asset(
                    'assets/images/sushi_principal.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),

            // Campo de busca
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Pesquisar Produto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 10),

            // Título das categorias
            Row(
              children: [
                Text('Categorias', style: TextStyle(fontSize: 20, color: Colors.black)),
              ],
            ),

            SizedBox(height: 5),

            // Lista de categorias ou shimmer
            Expanded(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  store.isLoading,
                  store.erro,
                  store.state,
                ]),
                builder: (context, _) {
                  if (store.isLoading.value) {
                    // shimmer enquanto carrega
                    return ListView.builder(
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
                                color: Colors.white,
                                margin: EdgeInsets.only(top: 4),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (store.erro.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        store.erro.value,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }

                  // lista de categorias com dados carregados
                  return ListView.builder(
                    itemCount: store.state.value.length,
                    itemBuilder: (context, index) {
                      final produto = store.state.value[index];

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProdutosCategoriaPage(
                                  nomeCategoria: produto.strCategory,
                                ),
                              ),
                            );
                          },
                          leading: Image.network(
                            produto.strCategoryThumb,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(produto.strCategory),
                          subtitle: Text(
                            produto.strCategoryDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
