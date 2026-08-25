import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/tarefa.dart';

void main() {
  runApp(const TarefasDbApp());
}

class TarefasDbApp extends StatelessWidget {
  const TarefasDbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const TarefasScreen(),
    );
  }
}

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Tarefa> _tarefas = [];

  bool _carregando = true;

  // Exercício 01
  int _totalTarefas = 0;

  // Exercício 03
  final _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  // Atualiza a lista e o contador
  Future<void> _atualizarLista() async {
    setState(() {
      _carregando = true;
    });

    final dados = await DatabaseHelper.instance.queryAll();

    // Exercício 01
    final total = await DatabaseHelper.instance.countAll();

    if (!mounted) return;

    setState(() {
      _tarefas = dados;
      _totalTarefas = total;
      _carregando = false;
    });
  }

  // Exercício 03
  // Realiza a busca pelo título
  Future<void> _buscarTarefas(String texto) async {
    setState(() {
      _carregando = true;
    });

    if (texto.trim().isEmpty) {
      await _atualizarLista();
      return;
    }

    final resultados =
        await DatabaseHelper.instance.searchByTitulo(texto.trim());

    // O contador continua mostrando o total real do banco
    final total = await DatabaseHelper.instance.countAll();

    if (!mounted) return;

    setState(() {
      _tarefas = resultados;
      _totalTarefas = total;
      _carregando = false;
    });
  }

  Future<void> _adicionarTarefa(String titulo) async {
    if (titulo.trim().isEmpty) return;

    await DatabaseHelper.instance.insert(
      Tarefa(
        titulo: titulo.trim(),
      ),
    );

    await _atualizarLista();
  }

  Future<void> _alternarStatus(Tarefa tarefa) async {
    final atualizada = tarefa.copyWith(
      concluida: !tarefa.concluida,
    );

    await DatabaseHelper.instance.update(atualizada);

    await _atualizarLista();
  }

  Future<void> _removerTarefa(int id) async {
    await DatabaseHelper.instance.delete(id);

    await _atualizarLista();
  }

  // Exercício 02
  // Confirma antes de apagar todas as tarefas
  Future<void> _limparTodasTarefas() async {
    if (_totalTarefas == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não existem tarefas para apagar.'),
          backgroundColor: Colors.orange,
        ),
      );

      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Limpar todas as tarefas?'),
          content: Text(
            'Você está prestes a apagar $_totalTarefas tarefas '
            'do banco de dados. Essa ação não pode ser desfeita.',
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
              child: const Text('Apagar Tudo'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    await DatabaseHelper.instance.deleteAll();

    await _atualizarLista();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Todas as tarefas foram removidas do banco!',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _exibirDialogCadastro() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova Tarefa (SQLite)'),
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
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _adicionarTarefa(controller.text);

              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Persistência Relacional (SQLite)',
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,

        // Exercício 02
        // Botão para apagar todas as tarefas
        actions: [
          IconButton(
            onPressed: _limparTodasTarefas,
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Limpar todas as tarefas',
          ),
        ],
      ),

      body: Column(
        children: [
          // ==========================================
          // EXERCÍCIO 03 - CAMPO DE BUSCA
          // ==========================================

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscaController,
              onChanged: _buscarTarefas,
              decoration: InputDecoration(
                labelText: 'Buscar tarefa',
                hintText: 'Digite o título da tarefa...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _buscaController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _buscaController.clear();
                          _buscarTarefas('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // ==========================================
          // LISTA DE TAREFAS
          // ==========================================

          Expanded(
            child: _carregando
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _tarefas.isEmpty
                    ? Center(
                        child: Text(
                          _buscaController.text.isNotEmpty
                              ? 'Nenhuma tarefa encontrada.'
                              : 'Nenhuma tarefa salva no banco local.',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tarefas.length,
                        itemBuilder: (ctx, i) {
                          final t = _tarefas[i];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: t.concluida,
                                onChanged: (_) {
                                  _alternarStatus(t);
                                },
                              ),
                              title: Text(
                                t.titulo,
                                style: TextStyle(
                                  decoration: t.concluida
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: t.concluida
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _removerTarefa(t.id!);
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // ==========================================
          // EXERCÍCIO 01 - CONTADOR
          // ==========================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              border: Border(
                top: BorderSide(
                  color: Colors.teal.shade200,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.task_alt,
                  color: Colors.teal,
                ),
                const SizedBox(width: 8),
                Text(
                  'Total de tarefas: $_totalTarefas',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _exibirDialogCadastro,
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}