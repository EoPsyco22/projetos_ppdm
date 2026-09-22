import 'package:flutter/material.dart';

class CartaoEstudante extends StatelessWidget {
  final String nome;
  final String curso;
  final String ra;
  final String email;
  final String imagem;

  const CartaoEstudante({
    super.key,
    required this.nome,
    required this.curso,
    required this.ra,
    required this.email,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        // Exercício 04: fundo com gradiente
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50,
            Colors.white,
            Colors.green.shade100,
          ],
        ),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.green,
          width: 2,
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ==========================================
            // EXERCÍCIO 01 - IMAGEM REAL
            // ==========================================

            CircleAvatar(
              radius: 40,

              // Substitui o ícone por uma imagem da internet
              backgroundImage: NetworkImage(imagem),

              backgroundColor: Colors.green,
            ),

            const SizedBox(height: 12),

            // ==========================================
            // NOME
            // ==========================================

            Text(
              nome,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

            // ==========================================
            // CURSO
            // ==========================================

            Text(
              curso,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const Divider(
              height: 24,
              thickness: 1,
            ),

            // ==========================================
            // RA
            // ==========================================

            Row(
              children: [
                const Icon(
                  Icons.badge,
                  color: Colors.green,
                ),

                const SizedBox(width: 10),

                Text(
                  "RA: $ra",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ==========================================
            // EMAIL
            // ==========================================

            Row(
              children: [
                const Icon(
                  Icons.email,
                  color: Colors.green,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    email,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ==========================================
            // STATUS
            // ==========================================

            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),

                SizedBox(width: 10),

                Text(
                  "Status: Matriculado / Ativo",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const Divider(
              height: 30,
              thickness: 1,
            ),

            // ==========================================
            // EXERCÍCIO 02 - SOBRE MIM
            // ==========================================

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Sobre Mim",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Sou estudante de Desenvolvimento de Sistemas, "
              "interessado em tecnologia e desenvolvimento de "
              "aplicações. Estou aprendendo programação mobile "
              "com Flutter e buscando aprimorar minhas habilidades.",
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 16),

            // ==========================================
            // EXERCÍCIO 03 - HABILIDADES
            // ==========================================

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Habilidades",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Chips dentro de uma Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  label: const Text("Flutter"),
                  avatar: const Icon(
                    Icons.phone_android,
                    size: 18,
                  ),
                  backgroundColor: Colors.green.shade100,
                ),

                const SizedBox(width: 6),

                Chip(
                  label: const Text("Dart"),
                  avatar: const Icon(
                    Icons.code,
                    size: 18,
                  ),
                  backgroundColor: Colors.green.shade100,
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  label: const Text("UI/UX"),
                  avatar: const Icon(
                    Icons.design_services,
                    size: 18,
                  ),
                  backgroundColor: Colors.green.shade100,
                ),

                const SizedBox(width: 6),

                Chip(
                  label: const Text("Mobile"),
                  avatar: const Icon(
                    Icons.smartphone,
                    size: 18,
                  ),
                  backgroundColor: Colors.green.shade100,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ==========================================
            // BOTÃO
            // ==========================================

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Carteirinha validada com sucesso!",
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.verified),
              label: const Text(
                "Validar Carteirinha",
              ),
            ),
          ],
        ),
      ),
    );
  }
}