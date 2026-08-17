import 'package:flutter/material.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
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
        title: const Text(
          'PPDM - Dashboard de Observações',
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // EXERCÍCIO 02
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Resumo das Observações',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            // EXERCÍCIO 08
            // Grid 2x2 com 4 cards
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                BlocoEstatistica(
                  icone: Icons.flutter_dash,
                  numero: '124',
                  legenda: 'Aves Vistas',
                  cor: Colors.teal,
                ),

                BlocoEstatistica(
                  icone: Icons.place,
                  numero: '181',
                  legenda: 'Locais Visitados',
                  cor: Colors.teal,
                ),

                // EXERCÍCIO 01
                BlocoEstatistica(
                  icone: Icons.camera_alt,
                  numero: '45',
                  legenda: 'Fotos',
                  cor: Colors.teal,
                ),

                BlocoEstatistica(
                  icone: Icons.visibility,
                  numero: '89',
                  legenda: 'Observações',
                  cor: Colors.teal,
                ),
              ],
            ),

            const SizedBox(height: 24.0),

            const Text(
              'Destaque da Semana',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            // EXERCÍCIO 05
            // Stack com dois selos
            Stack(
              clipBehavior: Clip.none,
              children: [
                // EXERCÍCIO 06
                // Container substituído por Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 48,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 16),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Gavião-Real',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Avistado no Parque Central',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Selo Raro
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Raro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // EXERCÍCIO 05
                // Segundo selo: Confirmado
                Positioned(
                  bottom: -8,
                  left: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Confirmado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32.0),

            // EXERCÍCIO 03
            const Text(
              'Últimos Registros',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.teal.shade200,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.list,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Visualizar registros recentes',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ver todos'),
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