import 'package:flutter/material.dart';
import '../components/api_service.dart';
import '../components/auth_service.dart';
import 'package:pks/pages/orders.dart';

import '../models/user_model.dart';
import 'chat_list.dart';
import 'chat_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  late Future<User> user;

  @override
  void initState() {
    super.initState();
    final currentEmail = authService.getCurrentUserEmail();
    user = ApiService().getUserByEmail(currentEmail);
  }

  void _refreshData() {
    final currentEmail = authService.getCurrentUserEmail();
    setState(() {
      user = ApiService().getUserByEmail(currentEmail);
    });
  }

  void logout(BuildContext context) async {
    try {
      await authService.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    }
  }

  void _navigateToOrdersScreen(BuildContext context, int userId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyOrders(userId: userId)),
    );
  }

  void _navigateToChat(BuildContext context, int userId) {
    if (userId == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatList()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatPage(
          receiverUserEmail: 'xdd@mail.com',
          receiverUserID: '055aosc3hxXAWOBv6TpjL5fMVIY2',
        ),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Данных профиля нет'));
          }

          final userData = snapshot.data!;

          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.accessible_forward_outlined,
                    size: 200,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          userData.email,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () =>
                        _navigateToOrdersScreen(context, userData.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Мои заказы',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Новая кнопка "Чатик"
                  ElevatedButton(
                    onPressed: () => _navigateToChat(context, userData.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Чатик',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () => logout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Выйти из аккаунта',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[300],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
