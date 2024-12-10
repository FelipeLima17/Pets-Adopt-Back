import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pets_adopt/view/detalhes.dart';
import 'package:pets_adopt/widgets/CardPet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List pets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  Future<void> fetchPets() async {
    const url = 'https://pet-adopt-dq32j.ondigitalocean.app/pet/mypets';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        throw Exception("Token não encontrado. Faça login novamente.");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('pets')) {
          setState(() {
            pets = data['pets'];
            isLoading = false;
          });
        } else {
          throw Exception("Formato de resposta inesperado.");
        }
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Erro desconhecido.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pets.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum pet favorito encontrado.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffE9ECF4),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 23),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.menu,
                                    size: 45, color: Colors.grey[700]),
                                Image.asset("assets/images/Mypet.png",
                                    height: 40, fit: BoxFit.cover),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      "assets/images/Mulher.png",
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 17),
                              child: Text(
                                "Meus Pets Favoritos",
                                style: TextStyle(
                                  fontFamily: 'Baloo_Thambi_2',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(14),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: pets.length,
                        itemBuilder: (context, index) {
                          final pet = pets[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detalhes(pet: pet),
                                ),
                              );
                            },
                            child: cardPet(
                              name: pet['name'] ?? 'Desconhecido',
                              breed: pet['breed'] ?? 'Raça desconhecida',
                              imageUrl: pet['image'] ??
                                  'https://via.placeholder.com/150',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
