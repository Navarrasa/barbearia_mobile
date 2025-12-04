class ServiceModel {
  final String id;
  final String nome;
  final double preco;
  final String imagem;

  ServiceModel({
    required this.id,
    required this.nome,
    required this.preco,
    required this.imagem,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return ServiceModel(
      id: id,
      nome: map['nome'] ?? "Sem nome",
      preco: (map['preco'] ?? 0).toDouble(),
      imagem: map['imagem'] ?? "",
    );
  }
}
