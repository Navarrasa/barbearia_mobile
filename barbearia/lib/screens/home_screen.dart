import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d2647),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ---- LOGO/IMAGEM ----
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/logo.jpg",
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ---- TÍTULO ----
                  const Text(
                    "Studio Pro Barber",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ---- SUBTÍTULO ----
                  Text(
                    "Cuidando do seu estilo com excelência e tradição.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ---- TEXTO LONGO SOBRE A BARBEARIA ----
                  Text(
                    """
No Studio Pro Barber, buscamos muito mais do que apenas cortar cabelo — queremos que cada cliente viva uma experiência completa. 
Aqui, tradição e modernidade caminham juntas, combinando técnicas clássicas de barbearia com produtos de alta qualidade e um atendimento acolhedor.

Nossa equipe é formada por profissionais apaixonados pelo que fazem, comprometidos em oferecer o melhor serviço possível. Seja para um corte, barba ou um estilo mais moderno, você sempre sairá satisfeito.

Sinta-se em casa, aproveite o ambiente, relaxe e cuide do visual com quem realmente entende do assunto.
                    """,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.grey[200],
                      height: 1.55,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ---- COPYRIGHT ----
                  Text(
                    "© ${DateTime.now().year} Studio Pro Barber • Todos os direitos reservados",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
