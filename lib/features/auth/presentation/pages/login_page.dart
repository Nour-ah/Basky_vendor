import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spider_restaurant/core/di/injection_container.dart';
import 'package:spider_restaurant/core/theme/app_colors.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_state.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_button.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_card_widget.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:spider_restaurant/features/auth/presentation/pages/register_page.dart';
import 'package:spider_restaurant/features/home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.primary,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                const Positioned.fill(child: AuthBackgroundWidget()),
                Positioned.fill(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                if (Navigator.canPop(context))
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      alignment: Alignment.centerLeft,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                const Spacer(),
                                AuthCardWidget(
                                  children: [
                                    const Text('Welcome Back!',
                                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 24),
                                    AuthTextField(
                                      hintText: 'Email',
                                      prefixIcon: Icons.email_outlined,
                                      controller: _emailController,
                                      validator: (v) => (v == null || v.isEmpty) ? 'Enter your email' : null,
                                    ),
                                    const SizedBox(height: 12),
                                    AuthTextField(
                                      hintText: 'Password',
                                      prefixIcon: Icons.lock_outline,
                                      obscureText: true,
                                      controller: _passwordController,
                                      validator: (v) => (v == null || v.isEmpty) ? 'Enter your password' : null,
                                    ),
                                    const SizedBox(height: 24),
                                    AuthButton(
                                      text: 'Log In',
                                      backgroundColor: AppColors.promoRed,
                                      isLoading: state is AuthLoading,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthCubit>().login(
                                                login: _emailController.text.trim(),
                                                password: _passwordController.text,
                                              );
                                        }
                                      },
                                    ),

                                    DropdownButtonFormField<String>(
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: '1',
                                          child: Text('Option 1'),
                                        ),
                                      ],
                                      onChanged: (value) {},
                                    ),
                                    const SizedBox(height: 12),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const RegisterPage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Don't have an account? Sign Up",
                                        style: TextStyle(color: Colors.white, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}