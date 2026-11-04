class Desafio {
  final String id;
  final String titulo;
  final String roteiro;
  final int nivel;
  final String pilar;
  final int duracaoSegundos;

  Desafio({
    required this.id,
    required this.titulo,
    required this.roteiro,
    required this.nivel,
    required this.pilar,
    required this.duracaoSegundos,
  });

  factory Desafio.fromMap(Map<String, dynamic> map) {
    return Desafio(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      roteiro: map['roteiro'] as String,
      nivel: map['nivel'] as int,
      pilar: map['pilar'] as String? ?? 'Geral',
      duracaoSegundos: map['duracao_segundos'] as int? ?? 30,
    );
  }
}