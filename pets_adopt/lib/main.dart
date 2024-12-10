import 'package:flutter/material.dart';
import 'package:pets_adopt/view/addPet_screen.dart';
import 'package:pets_adopt/view/cadastro_screen.dart';
import 'package:pets_adopt/view/home_screen.dart';
import 'package:pets_adopt/view/login_screen.dart';
import 'package:pets_adopt/view/favorites_screen.dart';
import 'package:pets_adopt/view/userProfile_screen.dart';
import 'package:pets_adopt/view/petDetails_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pets Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(195, 19, 182, 127)),
        useMaterial3: true,
      ),
      home: Cadastro(),
    );
  }
}
