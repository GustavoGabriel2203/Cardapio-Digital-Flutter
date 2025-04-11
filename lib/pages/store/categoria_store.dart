import 'package:cardapio_sushi_layout/data/http/exceptions.dart';
import 'package:cardapio_sushi_layout/data/models/categoria_model.dart';
import 'package:cardapio_sushi_layout/data/repositories/categoria_repository.dart';
import 'package:flutter/widgets.dart';

class ProdutoStore {
  final IProdutoRepository repository;
  // Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável reativa para o estado
  final ValueNotifier<List<ProdutoModel>> state =
      ValueNotifier<List<ProdutoModel>>([]);

  // variável reativa para o erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  ProdutoStore({required this.repository});

  Future getProdutos() async {
    isLoading.value = true;

    try {
      final result = await repository.getProdutos();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}
