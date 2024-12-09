import 'package:flutter/material.dart'; // Importing Flutter material design library for UI components
import 'package:supabase_flutter/supabase_flutter.dart'; // Importing Supabase Flutter library for database connection and queries

class NotesPage extends StatefulWidget { // Declaring the 'NotesPage' class which is a StatefulWidget (can change state)
  const NotesPage({super.key}); // Constructor for 'NotesPage', a required method when defining widgets in Flutter

  @override
  State<NotesPage> createState() => _NotesPageState(); // Creates the state associated with this page
}

class _NotesPageState extends State<NotesPage> { 
  // Declaring a stream variable that will listen to the 'coffee_shops' table in Supabase.
  // This stream will be used to automatically update the data in real-time.
  late Stream<List<Map<String, dynamic>>> _notesStream;

  @override
  void initState() { // initState is called when the widget is created (first time)
    super.initState(); // Calling the super class constructor
    _initializeStream(); // Initialize the stream to start listening to changes in the database
  }

  // Function to initialize the stream (connect to Supabase and listen for changes)
  void _initializeStream() {
    _notesStream = Supabase.instance.client // Getting the Supabase client
        .from('coffee_shops') // Referring to the 'coffee_shops' table in the Supabase database
        .stream(primaryKey: ['id']); // Stream data, listening for changes based on the primary key 'id' (so when the data changes, it updates the UI)
  }

  // Function to refresh the data by reinitializing the stream
  void _refreshData() {
    setState(() { // setState tells Flutter to re-render the widget tree and update the UI
      _initializeStream(); // Reinitialize the stream, effectively refreshing the data
    });
  }

  @override
  Widget build(BuildContext context) { // The build method is where the UI components are constructed
    return Scaffold( // Scaffold provides the basic structure for the page (app bar, body, etc.)
      appBar: AppBar( // App bar at the top of the screen
        title: const Text('Coffee Shops'), // The title of the app bar (what appears at the top)
        actions: [ // Actions are widgets placed on the right side of the app bar (like buttons)
          IconButton( // IconButton is a clickable button that contains an icon
            icon: const Icon(Icons.refresh), // Using a refresh icon for the button
            onPressed: _refreshData, // When the button is pressed, call the _refreshData function to reload the data
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>( // StreamBuilder listens to a stream and updates the UI based on the data
        stream: _notesStream, // The stream that we are listening to for real-time updates (Supabase stream)
        builder: (context, snapshot) { // Snapshot is used to get the current data from the stream
          
          if (snapshot.connectionState == ConnectionState.waiting) { // Checking if the stream is still loading data
            return const Center(child: CircularProgressIndicator()); // Show a loading spinner while data is loading
          }

          if (snapshot.hasError) { // If there was an error while fetching data, show the error
            return Center(
              child: Text('Error: ${snapshot.error}'), // Display the error message in the UI
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) { // If no data is returned from the stream, show a message
            return const Center(
              child: Text('No coffee shops found.'), // Display "No data" message
            );
          }

          // If data is present, store the list of notes (coffee shops) in the variable
          final notes = snapshot.data!;

          // Use ListView.builder to build a scrollable list of coffee shops
          return ListView.builder(
            itemCount: notes.length, // Define the number of items in the list (based on the data length)
            itemBuilder: (context, index) { // For each item in the list, build a ListTile
              final note = notes[index]; // Get the note (coffee shop) at the current index
              final noteText = note['name']; // Get the 'name' column data for the current coffee shop

              // Return a ListTile widget to display the coffee shop name
              return ListTile(
                title: Text(noteText), // Display the name of the coffee shop
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData, // Refresh button logic
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
