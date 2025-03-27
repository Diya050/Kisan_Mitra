// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'onboarding_screen.dart';

// class OtpScreen extends StatefulWidget {
//   final String phone;
//   const OtpScreen({super.key, required this.phone});

//   @override
//   OtpScreenState createState() => OtpScreenState();
// }

// class OtpScreenState extends State<OtpScreen> {
//   final TextEditingController _otpController = TextEditingController();
//   bool isLoading = false;

//   Future<void> verifyOTP(String otp) async {
//     if (!mounted) return; // Ensure widget is mounted before proceeding
//     setState(() => isLoading = true);

//     final url = Uri.parse('http://192.168.1.79:3000/api/v1/user/verify-otp');
//     String? errorMessage;
//     bool success = false;

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"phone": widget.phone, "otp": otp}),
//       );

//       final data = jsonDecode(response.body);
//       success = response.statusCode == 200 && data['success'] == true;
//       if (!success) {
//         errorMessage = data['message'];
//       }
//     } catch (e) {
//       errorMessage = "Error verifying OTP";
//     }

//     if (mounted) {
//       setState(() => isLoading = false);

//       if (success) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => OnboardingScreen()),
//           (route) => false,
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage ?? "Unknown error"), backgroundColor: Colors.red),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Image.asset('assets/otp.png', width: double.infinity, height: 250, fit: BoxFit.contain),
//               const SizedBox(height: 20),
//               const Text("Enter OTP", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: TextField(
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: "Enter OTP",
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(200, 50)),
//                 onPressed: isLoading
//                     ? null
//                     : () {
//                         String otp = _otpController.text.trim();
//                         if (otp.length == 6 && RegExp(r'^[0-9]+$').hasMatch(otp)) {
//                           verifyOTP(otp);
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Please enter a valid OTP"), backgroundColor: Colors.red),
//                           );
//                         }
//                       },
//                 child: isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : const Text("Verify OTP", style: TextStyle(fontSize: 18, color: Colors.white)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
