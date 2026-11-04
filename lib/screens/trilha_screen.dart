import 'package:flutter/material.dart';
import '../models/desafio.dart';
import '../repositories/desafio_repository.dart';
import 'teleprompter_screen.dart'; // Importa a próxima tela

class TrilhaScreen extends StatefulWidget {
  const TrilhaScreen({Key? key}) : super(key: key);

  @override
  State<TrilhaScreen> createState() => _TrilhaScreenState();
}

class _TrilhaScreenState extends State<TrilhaScreen> {
  final DesafioRepository _repository = DesafioRepository();
  late Future<List<Desafio>> _futuroDesafios;

  @override
  void initState() {
    super.initState();
    _futuroDesafios = _repository.buscarDesafios();
  }

  Color _corDoPilar(String pilar) {
    switch (pilar) {
      case 'Destrave': return Colors.green;
      case 'Dicção': return Colors.amber;
      case 'Presença': return Colors.red;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro do Axeo
      appBar: AppBar(
        title: const Text('Trilha Axeo', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Desafio>>(
        future: _futuroDesafios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Erro ao carregar desafios. Verifique a conexão.', 
              style: TextStyle(color: Colors.white70)),
            );
          }

          final desafios = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: desafios.length,
            itemBuilder: (context, index) {
              final desafio = desafios[index];
              final cor = _corDoPilar(desafio.pilar);

              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: cor, width: 2),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: cor,
                    child: Text(
                      desafio.nivel.toString(),
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    desafio.titulo,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${desafio.pilar} • ${desafio.duracaoSegundos}s',
                      style: TextStyle(color: cor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  trailing: const Icon(Icons.play_circle_fill, color: Colors.white, size: 32),
                  onTap: () {
                    // Navega para o Teleprompter passando o desafio
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeleprompterScreen(desafio: desafio),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}