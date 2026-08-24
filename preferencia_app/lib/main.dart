import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PreferenciaApp());
}

class PreferenciaApp extends StatefulWidget {
  const PreferenciaApp({super.key});

  @override
  State<PreferenciaApp> createState() => _PreferenciaAppState();
}

class _PreferenciaAppState extends State<PreferenciaApp> {
  bool _temaEscuro = false;
  String _tamanhoFonte = 'Médio';
  bool _receberNotificacoes = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  // Carrega todas as preferências salvas
  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _temaEscuro = prefs.getBool('isDark') ?? false;
      _tamanhoFonte = prefs.getString('tamanhoFonte') ?? 'Médio';
      _receberNotificacoes =
          prefs.getBool('receberNotificacoes') ?? true;
    });
  }

  // Altera e salva o tema
  Future<void> _alternarTema(bool valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDark', valor);

    setState(() {
      _temaEscuro = valor;
    });
  }

  // Salva o tamanho da fonte
  Future<void> _alterarTamanhoFonte(String valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('tamanhoFonte', valor);

    setState(() {
      _tamanhoFonte = valor;
    });
  }

  // Salva o estado das notificações
  Future<void> _alterarNotificacoes(bool valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('receberNotificacoes', valor);

    setState(() {
      _receberNotificacoes = valor;
    });
  }

  // Restaura as configurações padrão
  void _configuracoesLimpas() {
    setState(() {
      _temaEscuro = false;
      _tamanhoFonte = 'Médio';
      _receberNotificacoes = true;
    });
  }

  // Define o tamanho da fonte
  double _fatorFonte() {
    switch (_tamanhoFonte) {
      case 'Pequeno':
        return 0.85;

      case 'Grande':
        return 1.20;

      case 'Médio':
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final temaBase = _temaEscuro
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    return MaterialApp(
      title: 'Preferências do Usuário',
      debugShowCheckedModeBanner: false,

      theme: temaBase.copyWith(
        textTheme: temaBase.textTheme.apply(
          fontSizeFactor: _fatorFonte(),
        ),
      ),

      home: ConfigScreen(
        temaEscuro: _temaEscuro,
        onTemaAlterado: _alternarTema,
        tamanhoFonte: _tamanhoFonte,
        onTamanhoFonteAlterado: _alterarTamanhoFonte,
        receberNotificacoes: _receberNotificacoes,
        onNotificacoesAlteradas: _alterarNotificacoes,
        onConfiguracoesLimpas: _configuracoesLimpas,
      ),
    );
  }
}

class ConfigScreen extends StatefulWidget {
  final bool temaEscuro;
  final ValueChanged<bool> onTemaAlterado;

  final String tamanhoFonte;
  final ValueChanged<String> onTamanhoFonteAlterado;

  final bool receberNotificacoes;
  final ValueChanged<bool> onNotificacoesAlteradas;

  final VoidCallback onConfiguracoesLimpas;

  const ConfigScreen({
    super.key,
    required this.temaEscuro,
    required this.onTemaAlterado,
    required this.tamanhoFonte,
    required this.onTamanhoFonteAlterado,
    required this.receberNotificacoes,
    required this.onNotificacoesAlteradas,
    required this.onConfiguracoesLimpas,
  });

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _nomeController = TextEditingController();

  String _nomeSalvo = '';

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  // Carrega o nome salvo
  Future<void> _carregarNome() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _nomeSalvo =
          prefs.getString('usuario_nome') ?? 'Não informado';

      _nomeController.text =
          prefs.getString('usuario_nome') ?? '';
    });
  }

  // Salva o nome
  Future<void> _salvarNome() async {
    final nome = _nomeController.text.trim();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('usuario_nome', nome);

    setState(() {
      _nomeSalvo = nome;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nome salvo localmente com sucesso!',
          ),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  // Exercício 01 - Limpar todas as configurações
  Future<void> _limparConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();

    // Apaga todas as chaves salvas
    await prefs.clear();

    // Limpa o nome da tela
    setState(() {
      _nomeSalvo = 'Não informado';
      _nomeController.clear();
    });

    // Restaura as configurações do aplicativo
    widget.onConfiguracoesLimpas();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Todas as configurações foram apagadas!',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações Locais',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==============================
            // MODO ESCURO
            // ==============================

            Card(
              child: SwitchListTile(
                title: const Text(
                  'Modo Escuro',
                ),
                subtitle: const Text(
                  'Ativar visual escuro na aplicação',
                ),
                secondary: Icon(
                  _temaEscuroIcone(),
                ),
                value: widget.temaEscuro,
                onChanged: widget.onTemaAlterado,
              ),
            ),

            const SizedBox(height: 12),

            // ==============================
            // EXERCÍCIO 03
            // RECEBER NOTIFICAÇÕES
            // ==============================

            Card(
              child: SwitchListTile(
                title: const Text(
                  'Receber Notificações',
                ),
                subtitle: const Text(
                  'Permitir o recebimento de notificações',
                ),
                secondary: const Icon(
                  Icons.notifications,
                ),
                value: widget.receberNotificacoes,
                onChanged: widget.onNotificacoesAlteradas,
              ),
            ),

            const SizedBox(height: 20),

            // ==============================
            // EXERCÍCIO 02
            // TAMANHO DA FONTE
            // ==============================

            const Text(
              'Aparência',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  initialValue: widget.tamanhoFonte,
                  decoration: const InputDecoration(
                    labelText: 'Tamanho da Fonte',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.format_size,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Pequeno',
                      child: Text('Pequeno'),
                    ),
                    DropdownMenuItem(
                      value: 'Médio',
                      child: Text('Médio'),
                    ),
                    DropdownMenuItem(
                      value: 'Grande',
                      child: Text('Grande'),
                    ),
                  ],
                  onChanged: (valor) {
                    if (valor != null) {
                      widget.onTamanhoFonteAlterado(
                        valor,
                      );
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==============================
            // PERFIL DO USUÁRIO
            // ==============================

            const Text(
              'Perfil do Usuário',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Usuário',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.person,
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvarNome,
                icon: const Icon(
                  Icons.save,
                ),
                label: const Text(
                  'Salvar Nome',
                ),
              ),
            ),

            const Divider(
              height: 40,
            ),

            // ==============================
            // NOME SALVO
            // ==============================

            Text(
              'Valor atual salvo no disco: $_nomeSalvo',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 30),

            // ==============================
            // EXERCÍCIO 01
            // LIMPAR CONFIGURAÇÕES
            // ==============================

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _limparConfiguracoes,
                icon: const Icon(
                  Icons.delete_sweep,
                ),
                label: const Text(
                  'Limpar Configurações',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _temaEscuroIcone() {
    return widget.temaEscuro
        ? Icons.dark_mode
        : Icons.light_mode;
  }
}