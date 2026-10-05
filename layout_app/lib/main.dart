import 'package:flutter/material.dart';
// Importação do widget customizado criado no Exercício 07
import 'widgets/bloco_estatistica.dart'; 

void main() {
  runApp(const MeuLayoutApp());
}

class MeuLayoutApp extends StatelessWidget {
  const MeuLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPDM - Layout Widgets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TelaDashboard(),
    );
  }
}

class TelaDashboard extends StatelessWidget {
  const TelaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPDM - Dashboard de Observacoes'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // EXERCÍCIO 02: Alinhamento alterado de .start para .center
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            const Text(
              'Resumo das Observacoes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // EXERCÍCIO 08: Refatorado de Row/Expanded para GridView 2x2
            // EXERCÍCIO 01: Adicionado o terceiro card ("Fotos")
            // Adicionado também um quarto card simulado para fechar o Grid 2x2 perfeitamente
            SizedBox(
              height: 240, // Altura limite necessária para o GridView dentro do ScrollView
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.3,
                physics: const NeverScrollableScrollPhysics(), // Evita conflito de scroll
                children: [
                  BlocoEstatistica(
                    icone: Icons.flutter_dash,
                    valor: '124',
                    legenda: 'Aves Vistas',
                    corFundo: Colors.teal.shade100,
                  ),
                  BlocoEstatistica(
                    icone: Icons.place,
                    valor: '18',
                    legenda: 'Locais Visitados',
                    corFundo: Colors.teal.shade50,
                  ),
                  // CARD ADICIONADO NO EXERCÍCIO 01
                  BlocoEstatistica(
                    icone: Icons.camera_alt,
                    valor: '45',
                    legenda: 'Fotos',
                    corFundo: Colors.teal.shade100,
                  ),
                  // CARD EXTRA para preencher a grade 2x2 do Exercício 08
                  BlocoEstatistica(
                    icone: Icons.assignment,
                    valor: '5',
                    legenda: 'Relatórios',
                    corFundo: Colors.teal.shade50,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            const Text(
              'Destaque da Semana',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // SOBREPOSIÇÃO usando Stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                // EXERCÍCIO 06: Substituído Container por Card com elevação 4
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 48, color: Colors.amber),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Gaviao-Real', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Avistado no Parque Central', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Selo superior direito (Original)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Raro',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // EXERCÍCIO 05: Segundo selo na parte inferior esquerda com fundo verde
                Positioned(
                  bottom: -4,
                  left: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Confirmado',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // EXERCÍCIO 03: Nova seção "Últimos Registros" com MainAxisAlignment.spaceBetween
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ultimos Registros',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinhamento das extremidades
                children: [
                  Row(
                    children: const [
                      Icon(Icons.list_alt, color: Colors.teal),
                      SizedBox(width: 12),
                      Text('Log_Avistamento_041.pdf', style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Abrir'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

