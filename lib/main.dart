import 'package:agri_connect/routes.dart';
import 'package:agri_connect/theme/theme.dart';
import 'package:agri_connect/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Locking the orientation to portrait
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.green, // Custom color for navigation bar
          systemNavigationBarIconBrightness: Brightness.light, // Adjust icons for better visibility
          ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    
  ]);
  // Load environment variables
  await dotenv.load(fileName: '.env');
  await SharedPrefs().init();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final bool tokenValid = token != null && !JwtDecoder.isExpired(token);
  // final String? userid = prefs.getString('userid');

  // Set login flag based on token validity
  await prefs.setBool('login', tokenValid);

  // Run the app
  runApp(ProviderScope(child: App(tokenValid: tokenValid)));
}
final prefs = SharedPrefs().prefs;
class App extends StatelessWidget {
  final bool tokenValid;

  const App({super.key, required this.tokenValid});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: ThemeMode.system,
      routerConfig: AppRoutes.createRouter(),
    );
  }
}
