import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gempa_bumi/core/theme/app_style.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bg(context),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: AppStyle.card(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Earthquake Monitor",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              const TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/dashboard');
                  },
                  child: const Text('Login'),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
