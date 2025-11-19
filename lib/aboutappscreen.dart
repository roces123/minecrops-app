import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F3),
      appBar: AppBar(
        title: const Text("About MineCrops App"),
        backgroundColor: const Color(0xFF6B8E23),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6B8E23), width: 2),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.spa, size: 50, color: Color(0xFF6B8E23)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "MineCrops",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E5D0),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  "\"Grow smarter, not harder\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3C5A14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "MineCrops is your smart farming companion created to break the cycle of debt, reduce losses, and guide every farmer with clear, reliable, and easy-to-understand advice.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                "It transforms soil insights, crop information, and essential farming data into simple, practical actions that help you save on inputs, increase your harvest, avoid risks, and earn more.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              const Text(
                "Whether you are a farmer, a student, or a small planter, MineCrops empowers you with the knowledge and confidence to grow smarter, farm better, and build a more secure future for your community.",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 40),
              const Text(
                "Bawat binhi may pangarap.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.green),
              ),
              const SizedBox(height: 5),
              const Text(
                "Tungkulin namin na gabayan ka hanggang anihan.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}