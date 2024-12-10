import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CadastrarPet extends StatefulWidget {
  const CadastrarPet({super.key});

  @override
  _CadastrarPetState createState() => _CadastrarPetState();
}

class _CadastrarPetState extends State<CadastrarPet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Future<void> _registerPet() async {
    final String name = _nameController.text;
    final String age = _ageController.text;
    final String weight = _weightController.text;
    final String color = _colorController.text;
    final String image = _imageController.text;

    if (name.isEmpty ||
        age.isEmpty ||
        weight.isEmpty ||
        color.isEmpty ||
        image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Erro: token não encontrado. Faça o login novamente.')),
      );
      return;
    }

    final Map<String, dynamic> petData = {
      'name': name,
      'age': age,
      'weight': weight,
      'color': color,
      'images': [image],
    };

    final Uri url =
        Uri.parse('https://pet-adopt-dq32j.ondigitalocean.app/pet/create');

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(petData),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          print('Response Data: $responseData');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    responseData['message'] ?? 'Pet registrado com sucesso')),
          );
        } catch (e) {
          print('Erro ao decodificar a resposta: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao processar a resposta')),
          );
        }
      } else {
        final responseBody =
            response.body.isEmpty ? 'Sem resposta do servidor' : response.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $responseBody')),
        );
      }
    } catch (e) {
      print('Erro ao registrar pet: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
          ),
          Positioned(
            top: 0,
            child: Image.asset(
              "assets/images/patasGreen.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 0,
            right: 10,
            child: Image.asset(
              "assets/images/patasGreen.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 150,
            right: 160,
            child: Image.asset(
              "assets/images/patasGreen.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 165,
            right: 0,
            child: Image.asset(
              "assets/images/patasGreen.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 150,
            left: 5,
            child: Image.asset(
              "assets/images/patasGreen.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            right: 160,
            top: 770,
            child: Image.asset(
              "assets/images/patasGreen.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 700,
            right: 10,
            child: Image.asset(
              "assets/images/patasGreen.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 690,
            left: 5,
            child: Image.asset(
              "assets/images/patasGreen.png",
              width: 100,
              height: 100,
            ),
          ),
          Positioned(
            top: 115,
            left: 145,
            child: Image.asset(
              "assets/images/favorite.png",
              width: 100,
              height: 100,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Center(child: Text("")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(195, 19, 182, 127),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              "Registrar Pet",
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            ..._buildFormFields(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 8),
                              child: GestureDetector(
                                onTap: _registerPet,
                                child: Container(
                                  width: 250,
                                  height: 60,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        195, 115, 255, 208),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Registrar Pet",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return [
      _buildTextField(_nameController, 'Name'),
      _buildTextField(_ageController, 'Age'),
      _buildTextField(_colorController, 'Color'),
      _buildTextField(_weightController, 'Weight'),
      _buildTextField(_imageController, 'Image URL'),
    ];
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: true,
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 20,
          ),
          fillColor: const Color(0xffEFEFEF),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(25),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
