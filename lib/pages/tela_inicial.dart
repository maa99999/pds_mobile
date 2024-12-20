import 'package:flutter/material.dart';
import 'package:revitalize_mobile/pages/login_page.dart';
import 'package:revitalize_mobile/pages/funcionario_page.dart';
import 'package:revitalize_mobile/pages/paciente_page.dart';
import 'package:revitalize_mobile/pages/prontuario_paciente.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

@override
Widget build(BuildContext context) {
  return const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Revitalize",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0E37BB),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Cabeçalho do sistema
              Container(
                width: MediaQuery.of(context).size.width > 600
                    ? 600
                    : MediaQuery.of(context).size.width * 0.9,
                color: Colors.blue[50],
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: const Text(
                  "Bem-vindo ao Revitalize!\nGerencie pacientes, funcionários e prontuários de forma simples.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0E37BB),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Grid de opções
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildMenuCard(
                    icon: Icons.person,
                    title: "Pacientes",
                    onTap: _onPacientePressed,
                  ),
                  _buildMenuCard(
                    icon: Icons.group,
                    title: "Funcionários",
                    onTap: _onFuncionarioPressed,
                  ),
                  _buildMenuCard(
                    icon: Icons.description,
                    title: "Prontuário do Paciente",
                    onTap: _onProntuariosPacientePressed,
                  ),
                  _buildMenuCard(
                    icon: Icons.calendar_today,
                    title: "Agenda",
                    onTap: () {},
                    iconColor: Colors.grey,
                    textColor: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: const Color(0xFF0E37BB),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: doUserLogout,
              ),
              const SizedBox(width: 8),
              const Text(
                "Sair",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF0E37BB),
    Color textColor = Colors.black87,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 48),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mensagem de sucesso
  void showSuccess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Mensagem de erro
  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Funções de navegação
  void _onFuncionarioPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FuncionarioPageState()),
    );
  }

  void _onPacientePressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PacientePage()),
    );
  }

  void _onProntuariosPacientePressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProntuarioPacientePage()),
    );
  }

  // Função de logout
  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();

    if (response.success) {
      showSuccess("User was successfully logged out!");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      showError(response.error!.message);
    }
  }
}
