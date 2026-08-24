import 'package:flutter/material.dart';
import '../observacao.dart';

class FormularioObservacao extends StatefulWidget {
  final Function(Observacao) onAdicionar;

  const FormularioObservacao({
    super.key,
    required this.onAdicionar,
  });

  @override
  State<FormularioObservacao> createState() => _FormularioObservacaoState();
}

class _FormularioObservacaoState extends State<FormularioObservacao> {
  final _tituloController = TextEditingController();
  final _especieController = TextEditingController();
  final _localController = TextEditingController();
  final _observadorController = TextEditingController();

  // Exercício 01 - Limpar formulário
  void _limparFormulario() {
    _tituloController.clear();
    _especieController.clear();
    _localController.clear();
    _observadorController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Formulário limpo com sucesso!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _submeterFormulario() {
    final titulo = _tituloController.text.trim();
    final especie = _especieController.text.trim();
    final local = _localController.text.trim();
    final observador = _observadorController.text.trim();

    if (titulo.isEmpty ||
        especie.isEmpty ||
        local.isEmpty ||
        observador.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final novaObservacao = Observacao(
      titulo: titulo,
      especie: especie,
      local: local,
      observador: observador,
      data: DateTime.now(),
    );

    widget.onAdicionar(novaObservacao);

    _limparCampos();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Observação cadastrada com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _limparCampos() {
    _tituloController.clear();
    _especieController.clear();
    _localController.clear();
    _observadorController.clear();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _especieController.dispose();
    _localController.dispose();
    _observadorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Nova Observação de Campo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título da Observação',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _especieController,
              decoration: const InputDecoration(
                labelText: 'Espécie/Ave',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pets),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _localController,
              decoration: const InputDecoration(
                labelText: 'Local do Avistamento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

            const SizedBox(height: 10),

            // Exercício 02 - Campo Observador
            TextField(
              controller: _observadorController,
              decoration: const InputDecoration(
                labelText: 'Observador',
                hintText: 'Nome de quem registrou',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                // Exercício 01 - Botão Limpar
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _limparFormulario,
                    icon: const Icon(Icons.clear),
                    label: const Text('Limpar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submeterFormulario,
                    icon: const Icon(Icons.add),
                    label: const Text('Cadastrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}