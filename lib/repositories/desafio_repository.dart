import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/desafio.dart';

class DesafioRepository {
  // COLOQUE SUAS CREDENCIAIS DO SUPABASE AQUI
  final String supabaseUrl = 'https://zdgyxmgjuxlbrhoktoia.supabase.co';
  final String supabaseAnonKey = 'sb_secret_RQPdvL3crk_uT1HuM88ETw_woZcdpL';

  Future<List<Desafio>> buscarDesafios() async {
    try {
      // Inicializa o Supabase (se ainda não foi inicializado)
      if (Supabase.instance.client.auth.currentSession == null && 
          Supabase.instance.client.auth.currentUser == null) {
         await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseAnonKey,
        );
      }

      final response = await Supabase.instance.client
          .from('challenges')
          .select()
          .order('nivel', ascending: true);

      return (response as List).map((item) => Desafio.fromMap(item)).toList();
    } catch (e) {
      print('Erro ao buscar desafios: $e');
      return [];
    }
  }
}