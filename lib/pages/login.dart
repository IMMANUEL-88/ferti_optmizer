import 'package:agri_connect/API/api.dart';
import 'package:agri_connect/constants/image_strings.dart';
import 'package:agri_connect/constants/sizes.dart';
import 'package:agri_connect/constants/spacing.dart';
import 'package:agri_connect/constants/text_strings.dart';
import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // This will dismiss the keyboard
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: ESpacingStyle.paddingWithAppBarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: ESizes.spaceBtwSections,
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Image(
                        height: 150,
                        image: AssetImage(EImages.lightAppLogo),
                      ),
                    ],
                  ),
                ),
                const Text(
                  ETexts.loginTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.white70),
                  //style: TextStyle(color: Colors.black, fontSize: 45),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  ETexts.loginSubTitle,
                  // style: Theme.of(context).textTheme.bodyMedium,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white),
                  //style: TextStyle(fontSize: 17, color: Colors.black),
                ),
                const SizedBox(
                  height: ESizes.spaceBtwSections,
                ),

                TextField(
                  controller: email,
                  cursorColor: Colors.white70,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.w600), // Text color for better contrast
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent.withOpacity(
                        0.15), // Slightly darker green to make it stand out
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.white
                          .withOpacity(.9), // White icon for contrast
                    ),
                    labelText: ETexts.email,
                    labelStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                        fontWeight: FontWeight
                            .w600), // Lighten and adjust the label text color
                    floatingLabelBehavior: FloatingLabelBehavior
                        .auto, // Smooth transition effect for the label
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0), // White border when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.6),
                          width:
                              1.5), // Semi-transparent white border when not focused
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0), // Red border for errors
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                    ),
                    hintText: '',
                    hintStyle: const TextStyle(
                        color: Colors.white60), // Subtle hint text color
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 16.0), // Adjust padding
                  ),
                ),

                const SizedBox(
                  height: ESizes.spaceBtwInputFields,
                ),

                TextField(
                  controller: pass,
                  cursorColor: Colors.white70,
                  obscureText: _obscureText, // For hiding the password input
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent.withOpacity(0.15),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white.withOpacity(.9),
                    ),
                    labelText: ETexts.password,
                    labelStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.6), width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0),
                    ),
                    hintText: '',
                    hintStyle: const TextStyle(color: Colors.white60),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 16.0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70, // Change the color if needed
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; // Toggle visibility
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Forgot Password
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        ETexts.forgetPassword,
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ESizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      try {
                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    EImages.leafLoadingLogo,
                                    height: 75,
                                    width: 75,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Loading Data...",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .apply(
                                          color: Colors.black,
                                        ),
                                  )
                                ],
                              ),
                            );
                          },
                        );

                        // Validate user inputs
                        if (email.text.isEmpty) {
                          Navigator.of(context).pop(); // Dismiss the dialog
                          EHelperFunctions.showSnackBar(
                              context, "Enter your email");
                          return;
                        }

                        if (pass.text.isEmpty) {
                          Navigator.of(context).pop(); // Dismiss the dialog
                          EHelperFunctions.showSnackBar(
                              context, "Enter your password");
                          return;
                        }

                        // Check internet connectivity
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.none) {
                          Navigator.of(context).pop(); // Dismiss the dialog
                          EHelperFunctions.showSnackBar(
                              context, 'No internet connection');
                          return;
                        }

                        // Perform login
                        bool login = await Api().login(email.text, pass.text);
                        if (login) {
                          print('successful');
                          await Future.delayed(Duration(seconds: 3));
                          Navigator.of(context).pop(); // Dismiss the dialog
                          context.go('/home');
                        } else {
                          Navigator.of(context).pop();
                          EHelperFunctions.showSnackBar(context, globalMessage);
                        }
                      } catch (e) {
                        Navigator.of(context).pop(); // Dismiss the dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dialogBackgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainer,
                              ),
                              child: AlertDialog(
                                icon: SizedBox(
                                  height:
                                      EHelperFunctions.screenHeight(context) *
                                          .1,
                                  child: Image.asset(EImages.ipAppLogo),
                                ),
                                title: Text(
                                  e.toString(),
                                  style: GoogleFonts.rubik(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                content: Text(
                                  'Please connect to internet',
                                  style: GoogleFonts.rubik(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                actions: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Sign in",
                    ),
                  ),
                ),
                // OutlinedButton(onPressed: (){}, child: Text('Login',style: Theme.of(context)
                //     .textTheme
                //     .bodySmall!
                //     .apply(color: dark ? EColors.light : EColors.dark),)),
                SizedBox(
                  height: EHelperFunctions.screenHeight(context) * 0.18,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Divider(
                        color: Colors.white70,
                        thickness: 1,
                        indent: 5,
                        endIndent: 1,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      ETexts.supportText1,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white70),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Flexible(
                      child: Divider(
                        color: Colors.white70,
                        thickness: 1,
                        indent: 1,
                        endIndent: 5,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
