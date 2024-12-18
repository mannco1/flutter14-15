import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pks/components/auth_service.dart';
import 'package:pks/components/global.dart';
import 'package:pks/firebase_options.dart';
import 'package:pks/pages/cart.dart';
import 'package:pks/pages/home_page.dart';
import 'package:pks/pages/favourite.dart';
import 'package:pks/pages/profile.dart';
import 'package:provider/provider.dart';


import 'components/account.dart';
GlobalData appData = GlobalData();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(create: (context)=>AuthService(),
    child: const MyApp())
  );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  List<Widget> pages = [HomePage(), Favourite(),Cart(),AuthGate()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'xdd',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.light),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Аптечка"),
        ),
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items:const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.medication_liquid_outlined), label: "Товары"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Избранное"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: "Корзина"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Профиль")
          ],
          selectedItemColor: Colors.lightBlueAccent,
          unselectedItemColor: Colors.blueGrey,
          currentIndex: selectedIndex,
          useLegacyColorScheme: true,
          onTap: (int barItemIndex) => {
            setState(() {
              selectedIndex = barItemIndex;
            })
          },
        ),
      ),
    );
  }
}