import 'package:bd_frontend/bloc/register_bloc.dart';
import 'package:bd_frontend/widgets/full_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController loginNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final RegisterBloc _bloc;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _bloc = RegisterBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => _bloc,
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: _blocListener,
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: _blocBuilder,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, RegisterState state) {
    fullLoader(state is RegisterLoading);
    if (state is RegisterSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Бүртгэл амжилттай боллоо! 🎉'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (state is RegisterFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Бүртгэл амжилтгүй. Алдаа гарлаа! ❌'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _blocBuilder(BuildContext context, RegisterState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Register", style: TextStyle(fontSize: 32, color: Colors.white)),
            const SizedBox(height: 40),
            buildInput("Login Name", loginNameController),
            buildInput("Email", emailController),
            buildInput("Password", passwordController, obscure: true),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator(color: Colors.orange)
                : ElevatedButton(
              onPressed: () {
                print('wdwdw');
                if (passwordController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    loginNameController.text.isNotEmpty) {
                  context.read<RegisterBloc>().add(
                    RegisterSubmitEvent(
                      login_name: loginNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  );
                } else if (passwordController.text.isEmpty &&
                    emailController.text.isEmpty &&
                    loginNameController.text.isEmpty) {
                  const SnackBar(
                    content: Text('Та мэдээллээ оруулна уу! ❌'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  );
                } else {
                  const SnackBar(
                    content: Text('Алдаа! ❌'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Already have an account? Login", style: TextStyle(color: Colors.white70)),
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
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
