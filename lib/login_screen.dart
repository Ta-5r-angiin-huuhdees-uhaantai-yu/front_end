import 'package:bd_frontend/model/leaderboard_response.dart';
import 'package:bd_frontend/widgets/full_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LoginBloc();
    initControls();
  }

  void initControls() {
    _loginNameController.text = '';
    _passwordController.text = '';
  }


  @override
  void dispose() {
    _bloc.close();
    _loginNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => _bloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: _blocListener,
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, LoginState state) async {
    fullLoader(state is LoginLoading);
    if (state is LoginSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нэвтэрлээ! 🎉'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Амжилтгүй!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, LoginState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login", style: TextStyle(fontSize: 32, color: Colors.white)),
            const SizedBox(height: 40),
            buildInput("Login Name", _loginNameController),
            buildInput("Password", _passwordController, obscure: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_loginNameController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  context.read<LoginBloc>().add(
                    LoginSubmitted(
                      login_name: _loginNameController.text,
                      password: _passwordController.text,
                    ),
                  );
                } else if (_loginNameController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Мэдээллээ оруулна уу!'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text("Login"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Don’t have an account? Register", style: TextStyle(color: Colors.white70)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInput(String hint, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
