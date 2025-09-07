import 'package:flutter/material.dart';
import '../../static/navigation_route.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Temukan Restoran Favoritmu",
      "subtitle": "Jelajahi berbagai pilihan restoran terbaik di sekitarmu, mulai dari kuliner lokal hingga internasional.",
      "image": "assets/images/laptop-2298286_1280.png" // Ini gambarnya dari https://pixabay.com/vectors/laptop-computer-portable-pc-2298286/ (entar dimasukin ke readme sumbernya)
    },
    {
      "title": "Menu Lengkap & Ulasan Jujur",
      "subtitle": "Lihat menu, rating, dan ulasan pelanggan sebelum kamu memutuskan tempat makan.",
      "image": "assets/images/pixel-cells-3947911_1280.png" // ini gambarnya dari https://pixabay.com/vectors/pixel-cells-portfolio-work-folder-3947911/
    },
    {
      "title": "Simpan & Bagikan Favoritmu",
      "subtitle": "Tambah restoran ke daftar favoritmu dan bagikan rekomendasi ke teman-temanmu.",
      "image": "assets/images/social-media-3846597_1280.png" // ini gambarnya dari https://pixabay.com/vectors/social-media-connections-networking-3846597/
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 11, 11),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(onboardingData[index]["image"]!, height: 250, fit: BoxFit.contain),
                        const SizedBox(height: 40),
                        Text(
                          onboardingData[index]["title"]!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          onboardingData[index]["subtitle"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 80, 45, 45),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_currentPage == onboardingData.length - 1) {
                      Navigator.pushReplacementNamed(
                        context,
                        NavigationRoute.loginRoute.name,
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == onboardingData.length - 1 ? "Mulai" : "Lanjut",
                  ),
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  NavigationRoute.loginRoute.name,
                );
              },
              child: const Text(
                "Lewati",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
