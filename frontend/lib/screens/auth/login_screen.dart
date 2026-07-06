import "package:flutter/material.dart";
import "package:frontend/core/network/socket_service.dart";
import "package:frontend/core/storage/shared_pref_service.dart";
import "package:frontend/core/theme/appColor.dart";
import "package:frontend/core/utils/validator.dart";
import "package:frontend/screens/auth/register_screen.dart";
import "package:frontend/screens/home/homeScreen.dart";
import "package:frontend/services/authServices.dart";
import "package:frontend/widgets/customButton.dart";
import "package:frontend/widgets/customTextfield.dart";
import 'package:dio/dio.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final identifierController = TextEditingController();

  final passwordController = TextEditingController();

  bool obscurePassword = true;

  bool isLoading = false;

  Future <void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      final response = await authService.login(
          identifier: identifierController.text.trim(),
          password: passwordController.text.trim()
      );
      final token=response.data["data"]["token"];
      await SharedPrefService.saveToken(token);
      SocketService.instance.connect(token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
      );
    } on DioException catch (e) {
      final message = e.response?.data["message"] ??
          "Something went wrong";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("An unexpected error occurred."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }finally{
      if(mounted){
        setState(() {
          isLoading=false;
        });
      }
    }
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),

            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset("assets/images/LOGO.png",
                  width: 120
                  ),
                  SizedBox(height: 20,),
                  //AppName
                  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Talk",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(" Loop", style: Theme.of(context).textTheme
                                .headlineLarge
                                ?.copyWith(
                              color: Theme.of(context).colorScheme
                                  .primary,
                            ),
                          ),
                        ],
                  ),
                  // Welcome
                  const SizedBox(height: 12),
                  Text(
                    "Welcome Back",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    "Continue your anonymous conversations",
                    textAlign: TextAlign.center,
                    style:TextStyle(color: AppColors.lightSubtitle),
                  ),
                  SizedBox(height: 20,),
                  // Email
                  CustomTextField(
                    controller: identifierController,
                    hintText: "Enter your email or username",
                    labelText: "Email or UserName",
                    prefixIcon: Icons.email_outlined,
                    keyboardType:
                    TextInputType.emailAddress,
                    validator: Validators.identifier,
                  ),
                  SizedBox(height: 40),
                  // Password
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Enter your password",
                    labelText: "Password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: obscurePassword,
                    validator: Validators.password,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword =
                          !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  // Forgot Password
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: (){}, child:
                    Text("Forgot Password")
                    ),
                  ),
                  // Login Button
                  SizedBox(height: 10),
                  CustomButton(
                    text: "Login",
                    isLoading: isLoading,
                    onPressed:login,
                  ),
                  // Register
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                      ),
                      TextButton(
                        style: TextButton.styleFrom(textStyle:TextStyle(fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context)=>RegisterScreen())
                          );
                        },
                        child: const Text("Register",),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}