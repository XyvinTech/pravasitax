import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/core/theme/app_theme.dart';
import 'package:pravasitax_flutter/src/data/api/push_notifications_api.dart';
import 'package:pravasitax_flutter/src/data/providers/auth_provider.dart';
import 'package:pravasitax_flutter/src/data/services/get_fcm_token.dart';
import 'package:pravasitax_flutter/src/data/services/initialize_notifications.dart';
import 'dart:developer' as developer;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pravasitax_flutter/src/data/services/secure_storage_service.dart';

class LoginFrontPage extends ConsumerStatefulWidget {
  const LoginFrontPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginFrontPage> createState() => _LoginFrontPageState();
}

class _LoginFrontPageState extends ConsumerState<LoginFrontPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 2,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPageItem(index == 0
                  ? 'assets/images/login_image_2.png'
                  : 'assets/images/login_image_1.png');
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Column(
              children: [
                Text(
                  _currentIndex == 0
                      ? 'Welcome to Pravasi Tax'
                      : 'Login to access your account',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [0, 1].map((index) {
                    return Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                            .withOpacity(_currentIndex == index ? 0.9 : 0.4),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                _currentIndex == 0
                    ? ElevatedButton(
                        onPressed: () {
                          _pageController.animateToPage(1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.kPrimaryColor,
                          minimumSize: const Size(200, 50),
                        ),
                        child: const Text('Get Started'),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            TextField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleGetOTP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppPalette.kPrimaryColor,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Get OTP'),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageItem(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGetOTP() async {
    final email = _emailController.text.trim();
    developer.log('Handling OTP request for email: $email',
        name: 'LoginFrontPage._handleGetOTP');

    if (email.isEmpty) {
      developer.log('Email is empty', name: 'LoginFrontPage._handleGetOTP');
      setState(() {
        _errorMessage = 'Please enter your email';
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      developer.log('Invalid email format: $email',
          name: 'LoginFrontPage._handleGetOTP');
      setState(() {
        _errorMessage = 'Please enter a valid email';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).sendOTP(email);
      final authState = ref.read(authProvider);

      if (authState.error != null) {
        developer.log('Error from auth state: ${authState.error}',
            name: 'LoginFrontPage._handleGetOTP');
        setState(() {
          _errorMessage = authState.error;
        });
        return;
      }

      if (mounted) {
        developer.log('OTP sent successfully, showing verification dialog',
            name: 'LoginFrontPage._handleGetOTP');
        _showOtpVerificationSheet(email);
      }
    } catch (e) {
      developer.log('Error sending OTP',
          error: e.toString(), name: 'LoginFrontPage._handleGetOTP');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showOtpVerificationSheet(String email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter the verification code we sent to\n$email',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 30),
                    PinCodeTextField(
                      appContext: context,
                      length: 6, // Number of OTP digits
                      obscureText: false,
                      keyboardType:
                          TextInputType.number, // Number-only keyboard
                      animationType: AnimationType.fade,
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 5.0,
                      ),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 55,
                        fieldWidth: 50, selectedColor: AppPalette.kPrimaryColor,
                        activeColor: const Color.fromARGB(255, 232, 226, 226),
                        inactiveColor: const Color.fromARGB(255, 232, 226, 226),
                        activeFillColor: Colors.white, // Box color when focused
                        selectedFillColor:
                            Colors.white, // Box color when selected
                        inactiveFillColor:
                            Colors.white, // Box fill color when not selected
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      controller: _otpController,

                      onChanged: (value) {
                        // Handle input change
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _verifyOTP(email),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Verify OTP',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _handleGetOTP();
                          },
                          child: const Text(
                            'Resend',
                            style: TextStyle(
                              color: AppPalette.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text('Verifying OTP...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _verifyOTP(String email) async {
    final otp = _otpController.text;
    developer.log('Verifying OTP for email: $email',
        name: 'LoginFrontPage._verifyOTP');

    if (otp.length != 6) {
      developer.log('Invalid OTP length: ${otp.length}',
          name: 'LoginFrontPage._verifyOTP');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
      return;
    }

    _showLoadingDialog();

    try {
      await ref.read(authProvider.notifier).verifyOTP(email, otp);
      final authState = ref.read(authProvider);

      // Dismiss loading dialog
      if (mounted) {
        Navigator.of(context).pop(); // Pop loading dialog
      }

      if (authState.isAuthenticated) {
        developer.log(
            'Authentication successful, navigating based on user type',
            name: 'LoginFrontPage._verifyOTP');
        if (mounted) {
          final api = ref.read(pushNotificationsAPIProvider);
          final fcm = await getFcmToken();
          api.registerFCMToken(authState.userId ?? '', fcm);
          await initializeNoitifications();
          Navigator.of(context).pop(); // Pop OTP dialog

          // Navigate based on user type
          if (authState.userType == 'staff') {
            Navigator.of(context).pushReplacementNamed('/home_consultant');
          } else {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        }
      } else {
        developer.log('Authentication failed: Invalid OTP',
            name: 'LoginFrontPage._verifyOTP');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid OTP')),
          );
        }
      }
    } catch (e) {
      // Dismiss loading dialog
      if (mounted) {
        Navigator.of(context).pop(); // Pop loading dialog
      }

      developer.log('Error verifying OTP',
          error: e.toString(), name: 'LoginFrontPage._verifyOTP');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  // Widget _buildOtpFields() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: List.generate(
  //       6,
  //       (index) => SizedBox(
  //         width: 45,
  //         height: 55,
  //         child: OTPTextField(
  //           controller: _otpControllers[index],
  //           focusNode: _otpFocusNodes[index],
  //           onChanged: (value) {
  //             // Ensure only one character is entered
  //             if (value.length > 1) {
  //               _otpControllers[index].text =
  //                   value[0]; // Keep only the first digit
  //               _otpControllers[index].selection = TextSelection.fromPosition(
  //                   TextPosition(offset: _otpControllers[index].text.length));
  //             }

  //             // Handle normal typing
  //             if (value.isNotEmpty && index < 5) {
  //               _otpFocusNodes[index + 1].requestFocus();
  //             }
  //           },
  //           onBackspace: () {
  //             if (index > 0) {
  //               _otpControllers[index - 1].clear();
  //               _otpFocusNodes[index - 1].requestFocus();
  //             }
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}

class OTPTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function() onBackspace;

  const OTPTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
  }) : super(key: key);

  @override
  State<OTPTextField> createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.backspace &&
              widget.controller.text.isEmpty) {
            widget.onBackspace();
          }
        }
      },
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 6, // Allow longer input for paste operations
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppPalette.kPrimaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          fillColor: Colors.grey[100],
          filled: true,
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            widget.onBackspace();
          } else {
            widget.onChanged(value);
            // If it's a single character, keep it
            if (value.length == 1) {
              widget.controller.text = value[0];
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length),
              );
            }
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
