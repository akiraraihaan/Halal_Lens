import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/data_migration_service.dart';
import 'services/accessibility_provider.dart';
// import 'firebase_options.dart'; // Uncomment if using generated firebase_options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Add options: DefaultFirebaseOptions.currentPlatform jika pakai firebase_options.dart
  
  // Uncomment the line below to run data migration once
  // await DataMigrationService.runFullMigration();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => AccessibilityProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final access = Provider.of<AccessibilityProvider>(context);
    return MaterialApp(
      title: 'Halal Lens',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: access.fontSize / 16,
        ),
        iconTheme: IconThemeData(size: access.iconSize),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
