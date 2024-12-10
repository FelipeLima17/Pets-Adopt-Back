import 'package:flutter/material.dart';
import 'package:pets_adopt/services/ServicePet.dart';
import 'package:pets_adopt/view/addPet_screen.dart';
import 'package:pets_adopt/view/favorites_screen.dart';
import 'package:pets_adopt/view/userProfile_screen.dart';
import 'package:pets_adopt/widgets/header.dart';
import 'package:pets_adopt/models/pet_model.dart';
import 'package:pets_adopt/widgets/CardPet.dart';
import 'package:pets_adopt/widgets/petCards.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 239, 239),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            SizedBox(height: 16),
            _buildPetList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPetList() {
    return FutureBuilder<List<Pet>>(
      future: PetService.fetchPets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhum pet encontrado.'));
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: snapshot.data!.map((pet) {
                var age = pet.age;
                return Petcards(
                  id: pet.id,
                  name: pet.name,
                  age: pet.age.toString(),
                  color: pet.color,
                  imageUrl: pet.images.isNotEmpty ? pet.images.first : '',
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
