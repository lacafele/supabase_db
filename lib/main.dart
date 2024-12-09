import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notes_page.dart';

void main() async {
  // supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://ldfuqqftvlesqeeiwita.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxkZnVxcWZ0dmxlc3FlZWl3aXRhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM3NTMwNDEsImV4cCI6MjA0OTMyOTA0MX0.6D0eTmdN3XWyg-MKutDKTJLVUlr7I8ACDX-YHoBfHzo"
  );
  // supabase setup


  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotesPage(),
    );
  }
}
