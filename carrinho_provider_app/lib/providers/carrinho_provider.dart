```dart
import 'package:flutter/foundation.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  final List<Produto> _itens = [];

  // Quantidade de cada produto
  final Map<String, int> _quantidades = {};

  // Cupom de desconto
  bool _cupomAplicado = false;

  List<Produto> get itens => List.unmodifiable(_itens);

  // Quantidade total de produtos no carrinho
  int get quantidade {
    return _quantidades.values.fold(
      0,
      (total, quantidade) => total + quantidade,
    );
  }

  // Valor sem desconto
  double get subtotal {
    return _itens.fold(
      0.0,
      (total, item) {
        final quantidade = _quantidades[item.id] ?? 1;
        return total + (item.preco * quantidade);
      },
    );
  }

  // Exercício 02
  bool get cupomAplicado => _cupomAplicado;

  double get desconto {
    if (_cupomAplicado) {
      return subtotal * 0.10;
    }

    return 0.0;
  }