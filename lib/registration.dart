import 'package:flutter/material.dart';


class OtpEntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade900, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/blue_1.png', // Replace with your actual asset path
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            
            // OTP Form Section
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enter OTP',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      
                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) => _buildOtpField()),
                      ),
                      const SizedBox(height: 20),
                      
                      // Resend OTP
                      TextButton(
                        onPressed: () {
                          // Resend OTP logic
                        },
                        child: Text(
                          "Didn’t receive the OTP? Resend OTP",
                          style: TextStyle(
                            color: Colors.green[500],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Continue Button
                      ElevatedButton(
                        onPressed: () {
                          // Continue button logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade500,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Illustration Image (Optional)
            Container(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'assets/frame_37.png', // Replace with your actual asset path
                width: MediaQuery.of(context).size.width * 0.75,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // OTP Input Field
  Widget _buildOtpField() {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextField(
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
