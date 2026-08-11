import 'package:flutter/material.dart';

void main() {
  runApp(const MeuCrachaApp());
}

class MeuCrachaApp extends StatelessWidget {
  const MeuCrachaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPDM - Crachá Digital',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const TelaCracha(),
    );
  }
}

class TelaCracha extends StatelessWidget {
  const TelaCracha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPDM - Identificação Estudantil'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            // Exercício 01: fundo verde claro
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16.0),

            // Exercício 01: borda verde
            border: Border.all(
              color: Colors.green,
              width: 2.0,
            ),

            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12.0),

              const Text(
                'Ana Silva Santos',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const Text(
                'Desenvolvimento Mobile / PPDM',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Divider(
                height: 24,
                thickness: 1,
              ),

              // Ícone alterado para verde
              Row(
                children: const [
                  Icon(
                    Icons.badge,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'RA: 2026109923',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 8.0),

              // Ícone alterado para verde
              Row(
                children: const [
                  Icon(
                    Icons.email,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'ana.silva@estudante.edu.br',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}