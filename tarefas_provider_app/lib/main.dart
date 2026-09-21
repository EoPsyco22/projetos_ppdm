```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/tarefa_provider.dart';
import 'models/tarefa.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TarefaProvider()..carregarTarefas(),
      child: const TarefasApp(),
    ),
  );
}

class TarefasApp extends StatelessWidget {
  const TarefasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas com Provider & SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Exercício 02
  String filtroAtual = 'Todas';

  void _exibirDialogNovaTarefa(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Descrição da tarefa',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Provider.of<TarefaProvider>(
                  context,
                  listen: false,
                ).adicionarTarefa(controller.text);

                Navigator.pop(ctx);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  // Exercício 03
  void _exibirDialogEditarTarefa(
    BuildContext context,
    Tarefa tarefa,
  ) {
    final controller = TextEditingController(
      text: tarefa.titulo,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Tarefa'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Descrição da tarefa',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Provider.of<TarefaProvider>(
                  context,
                  listen: false,
                ).editarTarefa(
                  tarefa,
                  controller.text,
                );

                Navigator.pop(ctx);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  // Exercício 02
  List<Tarefa> _filtrarTarefas(
    List<Tarefa> tarefas,
  ) {
    switch (filtroAtual) {
      case 'Pendentes':
        return tarefas
            .where((tarefa) => !tarefa.concluida)
            .toList();

      case 'Concluídas':
        return tarefas
            .where((tarefa) => tarefa.concluida)
            .toList();

      default:
        return tarefas;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas Tarefas',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Consumer<TarefaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final tarefasFiltradas = _filtrarTarefas(
            provider.tarefas,
          );

          return Column(
            children: [
              // ==========================================
              // EXERCÍCIO 01 - CONTADOR
              // ==========================================

              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Progresso das tarefas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${provider.tarefasConcluidas} de '
                      '${provider.totalTarefas} concluídas',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: provider.totalTarefas == 0
                          ? 0
                          : provider.tarefasConcluidas /
                              provider.totalTarefas,
                    ),
                  ],
                ),
              ),

              // ==========================================
              // EXERCÍCIO 02 - FILTROS
              // ==========================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _botaoFiltro(
                        'Todas',
                        provider.tarefas.length,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _botaoFiltro(
                        'Pendentes',
                        provider.tarefasPendentes,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _botaoFiltro(
                        'Concluídas',
                        provider.tarefasConcluidas,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ==========================================
              // LISTA DE TAREFAS
              // ==========================================

              Expanded(
                child: tarefasFiltradas.isEmpty
                    ? Center(
                        child: Text(
                          filtroAtual == 'Todas'
                              ? 'Nenhuma tarefa cadastrada ainda!'
                              : 'Nenhuma tarefa em "$filtroAtual".',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tarefasFiltradas.length,
                        itemBuilder: (ctx, index) {
                          final tarefa =
                              tarefasFiltradas[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            // ==================================
                            // EXERCÍCIO 03 - CLIQUE LONGO
                            // ==================================

                            child: ListTile(
                              onLongPress: () {
                                _exibirDialogEditarTarefa(
                                  context,
                                  tarefa,
                                );
                              },

                              leading: Checkbox(
                                value: tarefa.concluida,
                                onChanged: (_) {
                                  provider.alternarStatus(
                                    tarefa,
                                  );
                                },
                              ),

                              title: Text(
                                tarefa.titulo,
                                style: TextStyle(
                                  decoration:
                                      tarefa.concluida
                                          ? TextDecoration
                                              .lineThrough
                                          : TextDecoration.none,
                                  color: tarefa.concluida
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),

                              subtitle: const Text(
                                'Clique longo para editar',
                              ),

                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  provider.removerTarefa(
                                    tarefa.id!,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirDialogNovaTarefa(context);
        },
        backgroundColor: Colors.indigo,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Botão utilizado pelo Exercício 02
  Widget _botaoFiltro(
    String filtro,
    int quantidade,
  ) {
    final selecionado = filtroAtual == filtro;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          filtroAtual = filtro;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selecionado ? Colors.indigo : Colors.grey.shade200,
        foregroundColor:
            selecionado ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
      ),
      child: Column(
        children: [
          Text(filtro),
          const SizedBox(height: 2),
          Text(
            '$quantidade',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
