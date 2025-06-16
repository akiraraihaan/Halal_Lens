import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/data_migration_service.dart';
import 'services/accessibility_provider.dart'; // Using services version for persistence
import 'constants/app_constants.dart';
import 'constants/text_constants.dart';
// import 'firebase_options.dart'; // Uncomment if using generated firebase_options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Add options: DefaultFirebaseOptions.currentPlatform jika pakai firebase_options.dart
  
  // Run data migration
  await DataMigrationService.runFullMigration();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, access, _) {
        // Update AppText language index whenever it changes in the provider
        AppText.currentLanguageIndex = access.languageIndex;
        
        return MaterialApp(
          title: AppText.appName,
          theme: ThemeData(
            // Menggunakan warna monokrom jika mode buta warna aktif
            primaryColor: access.isColorBlindMode ? AppColors.primaryMonochrome : AppColors.primary,
            scaffoldBackgroundColor: access.isColorBlindMode ? AppColors.backgroundMonochrome : AppColors.background,
        
            colorScheme: access.isColorBlindMode 
              ? ColorScheme.light(
                  primary: AppColors.primaryMonochrome,
                  secondary: AppColors.secondaryMonochrome,
                  background: AppColors.backgroundMonochrome,
                  error: AppColors.errorMonochrome,
                  surface: AppColors.white,
                  onPrimary: AppColors.white,
                  onSecondary: AppColors.white,
                  onBackground: AppColors.textPrimaryMonochrome,
                  onError: AppColors.white,
                  onSurface: AppColors.textPrimaryMonochrome,
                )
              : ColorScheme.light(
                  primary: AppColors.primary,
                  secondary: AppColors.secondary,
                  background: AppColors.background,
                  error: AppColors.error,
                  surface: AppColors.white,
                  onPrimary: AppColors.white,
                  onSecondary: AppColors.white,
                  onBackground: AppColors.textPrimary,
                  onError: AppColors.white,
                  onSurface: AppColors.textPrimary,
                ),
            
            // Set tema teks dan font size dari pengaturan accessibility
            textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: access.fontSize / 16,
              bodyColor: access.isColorBlindMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
              displayColor: access.isColorBlindMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
            ),
            
            // Tema ikon dan komponen UI
            iconTheme: IconThemeData(
              size: access.iconSize,
              color: access.isColorBlindMode ? AppColors.primaryMonochrome : AppColors.primary,
            ),
            
            // Card theme
            cardTheme: CardThemeData(
              color: access.isColorBlindMode ? AppColors.white : AppColors.white,
              shadowColor: access.isColorBlindMode ? AppColors.secondaryMonochrome.withOpacity(0.3) : AppColors.secondary.withOpacity(0.3),
            ),
            
            // Pengaturan khusus untuk AppBar
            appBarTheme: AppBarTheme(
              backgroundColor: access.isColorBlindMode ? AppColors.backgroundMonochrome : AppColors.background,
              foregroundColor: access.isColorBlindMode ? AppColors.textPrimaryMonochrome : AppColors.textPrimary,
              elevation: 0,
              iconTheme: IconThemeData(
                color: access.isColorBlindMode ? AppColors.primaryMonochrome : AppColors.primary,
                size: access.iconSize,
              ),
            ),
            
            // Button themes
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: access.isColorBlindMode ? AppColors.primaryMonochrome : AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
                ),
              ),
            ),
          ),
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
