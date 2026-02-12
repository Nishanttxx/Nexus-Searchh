import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity_clone/pages/home_page.dart';
import 'package:perplexity_clone/theme/colors.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
     scaffoldBackgroundColor: AppColors.background,
     colorScheme: ColorScheme.fromSeed(seedColor:AppColors.submitButton),
     textTheme: GoogleFonts.interTextTheme(//interTextTheme applies inter font to every text in app
      ThemeData.dark().textTheme.copyWith(
        bodyMedium: TextStyle(fontSize:15,
        color:AppColors.whiteColor)
      )//apply dark font to every text in app
     )
      ),
      home: const HomePage(
      
      ),
    );
  }
}
