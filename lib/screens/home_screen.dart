import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/MGF_Icon.png', height: 36),
            const Spacer(),
            Row(
              children: [
                Text('DE', style: TextStyle(fontWeight: FontWeight.bold)),
                Switch(value: true, onChanged: (_) {}, activeColor: Colors.green),
                Text('EN', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Your Smart Guide to Settling in Germany 🇩🇪",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Step-by-step guidance for Anmeldung, visas, taxes & more!",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/MGF_Landingpage.png',
                      fit: BoxFit.cover,
                      height: 110,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {Navigator.pushNamed(context, '/otp');},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {Navigator.pushNamed(context, '/onboarding');},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Get Started Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
            _FeatureCards(),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _PersonaGrid(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
      floatingActionButton: _FloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _FeatureCards extends StatelessWidget {
  const _FeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': 'assets/icons/MGF_Bureaucracy.png',
        'title': 'Bureaucratic Guidance',
        'desc':
        'Get step-by-step instructions on Anmeldung, visa processes, health insurance, and taxes—no more confusion!',
        'route': '/bureaucratic',
      },
      {
        'icon': 'assets/icons/MGF_Smartchecklist.png',
        'title': 'Smart Checklists',
        'desc':
        'Stay on top of important deadlines with automated task lists that remind you what to do next.',
        'route': '/checklists',
      },
      {
        'icon': 'assets/icons/MGF_PreFilledForms.png',
        'title': 'Pre-Filled Forms',
        'desc':
        'Save time with auto-generated documents, ready for submission to government offices.',
        'route': '/prefilled',
      },
      {
        'icon': 'assets/icons/MGF_Assistant.png',
        'title': 'Smart Letter Scanner',
        'desc':
        'Scan your official letter and we’ll break it down for you — deadlines, actions, and everything that matters.',
        'route': '/scanner',
      },
      {
        'icon': 'assets/icons/MGF_Assistant.png',
        'title': 'AI Chat Assistant',
        'desc':
        'Get instant answers 24/7 to all your questions about moving and living in Germany',
        'route': '/aichat',
      },
    ];

    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: features.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, idx) {
          final f = features[idx];

          return SizedBox(
            width: 135,
            child: Material(
              color: const Color(0xFFB5B3E9),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.of(context).pushNamed(f['route'] as String);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        f['icon'] as String,
                        width: 26,
                        height: 26,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        f['title'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.indigo[900],
                          fontSize: 11,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Expanded(
                        child: Text(
                          f['desc'] as String,
                          style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            height: 1.15,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Smart animate: fade in (substitute route names for real pages)
PageRouteBuilder _smartPageRoute(String route, BuildContext context) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => Scaffold(
      appBar: AppBar(title: Text(route.replaceAll('/', '').toUpperCase())),
      body: Center(child: Text('Page: $route')),
    ), // Replace with your actual page
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

// 2x2 grid: all cards use the Figma pink/peach background
class _PersonaGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final personas = [
      {
        'icon': 'assets/icons/MGF_Families.png',
        'title': 'Families',
        'desc': 'Settle your family with ease',
      },
      {
        'icon': 'assets/icons/MGF_Freelancers.png',
        'title': 'Freelancers',
        'desc': 'Kickstart your business in Germany',
      },
      {
        'icon': 'assets/icons/MGF_Students.png',
        'title': 'Students',
        'desc': 'Simplify your studies in Germany',
      },
      {
        'icon': 'assets/icons/MGF_Expats.png',
        'title': 'Expats',
        'desc': 'Start your career hassle-free',
      },
    ];
    return SizedBox(
      height: 2 * 70 + 12, // slightly taller for content
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.8, // close to 170x60
        ),
        itemCount: personas.length,
        itemBuilder: (context, idx) {
          final p = personas[idx];
          return Container(
            width: 170,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE9CABF), // Figma peach
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  p['icon'] as String,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p['desc'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.message, color: Colors.orange),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.grey),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.support_agent, color: Colors.blue),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: 32),
        FloatingActionButton(
          heroTag: "help",
          mini: true,
          onPressed: () {},
          backgroundColor: Colors.white,
          child: const Icon(Icons.help_outline, color: Colors.blue),
          tooltip: "Need Help?",
        ),
      ],
    );
  }
}