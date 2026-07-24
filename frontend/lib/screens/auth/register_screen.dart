import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:frontend/core/network/socket_service.dart";
import "package:frontend/core/storage/shared_pref_service.dart";
import "package:frontend/theme/appColor.dart";
import "package:frontend/core/utils/validator.dart";
import "package:frontend/screens/auth/profile_setup_screen.dart";
import "package:frontend/services/authServices.dart";
import "package:frontend/widgets/CustomWidgets/customButton.dart";
import "package:frontend/widgets/CustomWidgets/customTextfield.dart";
import "package:frontend/widgets/HomeScreenWidgets/securityFooter.dart";


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool isLoading = false;

  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  Future <void>register()async{
    setState(() {
      autoValidateMode=AutovalidateMode.onUserInteraction;
    });
    if(!_formKey.currentState!.validate()) return;
    if(passwordController.text.trim()!=confirmPasswordController.text.trim()){
      ScaffoldMessenger.of(context).
      showSnackBar(SnackBar(content: Text("Password Should be same"))
      );
      return;
    }
    try{
      setState(() {
        isLoading=true;
      });
      final response = await authService.register(
        username: userNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final loginResponse=await authService.login(
          identifier:emailController.text.trim() ,
          password: passwordController.text.trim()
      );
      final token =loginResponse.data["data"]["token"];
      await SharedPrefService.saveToken(token);
      SocketService.instance.connect(token);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_)=>ProfileSetupScreen())
      );

    }on DioException catch (e) {
      final message =
          e.response?.data["message"] ??
              "Something went wrong";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    confirmPasswordController.dispose();
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
              autovalidateMode: autoValidateMode,
              child: Column(
                children: [
                  Image.asset("assets/images/LOGO.png",
                      width: 120
                  ),
                  SizedBox(height: 10),
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
                  const SizedBox(height: 12),
                  // Create An account
                  Text(
                    "Create Account",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  // Start
                  Text(
                    textAlign: TextAlign.center,
                    "Join anonymous conversations in seconds",
                    style:TextStyle(color: AppColors.lightSubtitle),
                  ),
                  SizedBox(height: 30,),
                  // username
                  CustomTextField(
                    controller: userNameController,
                    hintText: "Enter username",
                    labelText: "Username",
                    prefixIcon: Icons.person,
                    validator: Validators.username,

                  ),
                  SizedBox(height: 20),
                  // Email
                  CustomTextField(
                    controller: emailController,
                    hintText: "Enter your email",
                    labelText: "Email",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  SizedBox(height: 20),
                  // Password
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Enter  password",
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
                  SizedBox(height: 20),
                  //confirmPasswordController
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm password",
                    labelText: "Confirm Password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: obscureConfirmPassword,
                    validator: Validators.password,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword =
                          !obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  // Login Button
                  SizedBox(height: 30),
                  CustomButton(
                    text: "Create Account",
                    isLoading: isLoading,
                    onPressed:register,
                  ),
                  // Register
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                      ),
                      TextButton(
                        style: TextButton.styleFrom(textStyle:TextStyle(fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Login",style: TextStyle(fontWeight: FontWeight.w600),),

                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(child: Securityfooter()),
    );
  }
}