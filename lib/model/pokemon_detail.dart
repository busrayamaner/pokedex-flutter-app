class PokemonDetails {
  PokemonDetails({
    required this.baseExperience,
    required this.height,
    required this.id,
    required this.name,
    required this.order,
    required this.weight,
  });

  int baseExperience;
  int height;
  int id;
  String name;
  int order;
  int weight;

  factory PokemonDetails.fromJson(Map<String, dynamic> json) => PokemonDetails(
        baseExperience: json["base_experience"],
        height: json["height"],
        id: json["id"],
        name: json["name"],
        order: json["order"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "base_experience": baseExperience,
        "height": height,
        "id": id,
        "name": name,
        "order": order,
        "weight": weight,
      };
}
