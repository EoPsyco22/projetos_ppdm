import 'package:flutter/material.dart';
import 'models/produto.dart';
import 'screens/detail_screen.dart';
import 'screens/add_product_screen.dart';

void main() {
  runApp(const NavegacaoApp());
}

class NavegacaoApp extends StatelessWidget {
  const NavegacaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Navegação',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),

      // Exercício 03 - Rotas nomeadas
      routes: {
        '/': (context) => const HomeScreen(),

        '/add-product': (context) => const AddProductScreen(),

        '/details': (context) {
          final produto =
              ModalRoute.of(context)!.settings.arguments as Produto;

          return DetailScreen(produto: produto);
        },
      },

      initialRoute: '/',
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Produto> _produtos = [
    Produto(
      nome: 'Notebook Pro',
      descricao: 'Processador de última geração, 16GB RAM, SSD 512GB.',
      preco: 4500.00,
    ),
    Produto(
      nome: 'Smartphone X',
      descricao: 'Tela AMOLED 120Hz, Câmera Tripla de 50MP.',
      preco: 2800.00,
    ),
    Produto(
      nome: 'Fone Bluetooth',
      descricao: 'Cancelamento ativo de ruído e bateria de até 30h.',
      preco: 350.00,
    ),
  ];

  // Exercício 03 - Navigator.pushNamed()
  Future<void> _abrirDetalhes(
    BuildContext context,
    Produto produto,
  ) async {
    final resultado = await Navigator.pushNamed(
      context,
      '/details',
      arguments: produto,
    );

    if (resultado != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Retorno da tela: $resultado'),
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }

  // Exercício 01 - Abrir tela de cadastro
  Future<void> _adicionarProduto(BuildContext context) async {
    final resultado = await Navigator.pushNamed(
      context,
      '/add-product',
    );

    if (resultado != null && resultado is Produto && mounted) {
      setState(() {
        _produtos.add(resultado);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${resultado.nome} foi cadastrado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,

        // Botão para adicionar produto
        actions: [
          IconButton(
            onPressed: () => _adicionarProduto(context),
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar produto',
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (ctx, index) {
          final prod = _produtos[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.indigoAccent,
                child: Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
              ),

              title: Text(
                prod.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                'R\$ ${prod.preco.toStringAsFixed(2)}',
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),

              onTap: () => _abrirDetalhes(
                context,
                prod,
              ),
            ),
          );
        },
      ),

      // Botão flutuante para adicionar produto
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarProduto(context),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}