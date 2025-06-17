// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'otp_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   LoginScreenState createState() => LoginScreenState();
// }

// class LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   bool isLoading = false;

//   Future<void> sendOTP(String phoneNumber) async {
//     if (!mounted) return; // Ensure widget is mounted before making changes
//     setState(() => isLoading = true);

//     final url = Uri.parse('http://192.168.15.26:3000/api/v1/user/send-otp');
//     String? errorMessage;
//     bool success = false;

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"phone": phoneNumber}),
//       );

//       final data = jsonDecode(response.body);
//       success = response.statusCode == 200 && data['success'] == true;
//       if (!success) {
//         errorMessage = data['message'];
//       }
//     }  catch (e, stackTrace) {
//         debugPrint("Error verifying OTP: $e\nStackTrace: $stackTrace");
//         errorMessage = "Error: $e"; // Display actual error
//     }

//     if (mounted) {
//       setState(() => isLoading = false);

//       if (success) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => OtpScreen(phone: phoneNumber),
//           ),
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
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset('assets/tractor.jpg', width: double.infinity, height: 250, fit: BoxFit.cover),
//               const SizedBox(height: 20),
//               const Text("Sign In", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: TextField(
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     prefixIcon: const Padding(
//                       padding: EdgeInsets.all(14.0),
//                       child: Text("+91", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     ),
//                     hintText: "Enter Your Mobile Number",
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
//                         String phoneNumber = _phoneController.text.trim();
//                         if (phoneNumber.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
//                           sendOTP(phoneNumber);
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Please enter a valid 10-digit phone number"), backgroundColor: Colors.red),
//                           );
//                         }
//                       },
//                 child: isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : const Text("Send OTP", style: TextStyle(fontSize: 18, color: Colors.white)),
//               ),
//               const SizedBox(height: 20),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Text(
//                   "By continuing, you agree to our Terms and Conditions.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
