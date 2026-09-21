```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/produto.dart';
import 'providers/carrinho_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarrinhoProvider(),
      child: const CarrinhoApp(),
    ),
  );
}

class CarrinhoApp extends StatelessWidget {
  const CarrinhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrinho com Provider',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const CatalogoScreen(),
    );
  }
}

// =====================================================
// CATÁLOGO
// =====================================================

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  static const List<Produto> produtos = [
    Produto(
      id: '1',
      nome: 'Teclado Mecânico',
      preco: 250.00,
    ),
    Produto(
      id: '2',
      nome: 'Mouse Gamer',
      preco: 120.00,
    ),
    Produto(
      id: '3',
      nome: 'Monitor 24"',
      preco: 890.00,
    ),
    Produto(
      id: '4',
      nome: 'Headset Stereo',
      preco: 180.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catálogo de Produtos',
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,

        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CarrinhoScreen(),
                    ),
                  );
                },
              ),

              // Quantidade no carrinho
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CarrinhoProvider>(
                  builder: (
                    context,
                    carrinho,
                    child,
                  ) {
                    return carrinho.quantidade == 0
                        ? const SizedBox()
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              '${carrinho.quantidade}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              title: Text(
                produto.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                'R\$ ${produto.preco.toStringAsFixed(2)}',
              ),

              trailing: Consumer<CarrinhoProvider>(
                builder: (
                  context,
                  carrinho,
                  child,
                ) {
                  final quantidade =
                      carrinho.quantidadeDoProduto(
                    produto,
                  );

                  final estaNoCarrinho =
                      carrinho.itens.contains(produto);

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (estaNoCarrinho)
                        Text(
                          '$quantidade x',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      IconButton(
                        icon: Icon(
                          estaNoCarrinho
                              ? Icons.check_circle
                              : Icons.add_shopping_cart,
                          color: estaNoCarrinho
                              ? Colors.green
                              : Colors.teal,
                        ),
                        onPressed: () {
                          carrinho.adicionar(produto);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// =====================================================
// CARRINHO
// =====================================================

class CarrinhoScreen extends StatelessWidget {
  const CarrinhoScreen({super.key});

  // ===================================================
  // EXERCÍCIO 03
  // CONFIRMAÇÃO ANTES DE LIMPAR
  // ===================================================

  Future<void> _confirmarLimpeza(
    BuildContext context,
    CarrinhoProvider carrinho,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            'Limpar carrinho?',
          ),

          content: const Text(
            'Tem certeza que deseja remover '
            'todos os produtos do carrinho?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      carrinho.limpar();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Carrinho limpo com sucesso!',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seu Carrinho',
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: Consumer<CarrinhoProvider>(
        builder: (
          context,
          carrinho,
          child,
        ) {
          if (carrinho.quantidade == 0) {
            return const Center(
              child: Text(
                'Seu carrinho está vazio!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          return Column(
            children: [
              // ========================================
              // LISTA
              // ========================================

              Expanded(
                child: ListView.builder(
                  itemCount: carrinho.itens.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    final produto =
                        carrinho.itens[index];

                    final quantidade =
                        carrinho.quantidadeDoProduto(
                      produto,
                    );

                    final subtotalProduto =
                        produto.preco * quantidade;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding:
                                  EdgeInsets.zero,

                              title: Text(
                                produto.nome,
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              subtitle: Text(
                                'R\$ ${produto.preco.toStringAsFixed(2)} cada',
                              ),

                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  carrinho.remover(
                                    produto,
                                  );
                                },
                              ),
                            ),

                            // =================================
                            // EXERCÍCIO 01
                            // CONTROLE DE QUANTIDADE
                            // =================================

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        carrinho
                                            .diminuirQuantidade(
                                          produto,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle,
                                      ),
                                      color: Colors.red,
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                        horizontal: 18,
                                        vertical: 8,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          8,
                                        ),
                                      ),
                                      child: Text(
                                        '$quantidade',
                                        style:
                                            const TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        carrinho
                                            .aumentarQuantidade(
                                          produto,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add_circle,
                                      ),
                                      color: Colors.teal,
                                    ),
                                  ],
                                ),

                                Text(
                                  'R\$ ${subtotalProduto.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ==========================================
              // RESUMO DA COMPRA
              // ==========================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.teal.shade50,

                child: Column(
                  children: [
                    // Subtotal
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'R\$ ${carrinho.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // =====================================
                    // EXERCÍCIO 02
                    // CUPOM
                    // =====================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Desconto:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        Text(
                          '- R\$ ${carrinho.desconto.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Botão cupom
                    if (!carrinho.cupomAplicado)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            carrinho.aplicarCupom();

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Cupom de 10% aplicado!',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.discount,
                          ),
                          label: const Text(
                            'Aplicar cupom de 10%',
                          ),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Cupom de 10% aplicado',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          TextButton(
                            onPressed: () {
                              carrinho.removerCupom();
                            },
                            child: const Text(
                              'Remover',
                            ),
                          ),
                        ],
                      ),

                    const Divider(
                      height: 25,
                    ),

                    // Total
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          'R\$ ${carrinho.valorTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // =====================================
                    // EXERCÍCIO 03
                    // LIMPAR + CONFIRMAR
                    // =====================================

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _confirmarLimpeza(
                                context,
                                carrinho,
                              );
                            },
                            icon: const Icon(
                              Icons.delete_sweep,
                            ),
                            label: const Text(
                              'Limpar carrinho',
                            ),
                            style:
                                OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              carrinho.limpar();

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Compra finalizada com sucesso!',
                                  ),
                                ),
                              );
                            },
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.teal,
                              foregroundColor:
                                  Colors.white,
                            ),
                            child: const Text(
                              'Finalizar',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
