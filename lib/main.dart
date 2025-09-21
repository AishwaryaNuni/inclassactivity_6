import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // SharedPreferences keys
  static const _counterKey = "counter";
  static const _imageKey = "isFirstImage";
  static const _themeKey = "isDarkMode";

  // State variables
  int _counter = 0;
  bool _isFirstImage = true;
  bool _isDarkMode = false;

  final _img1 = "assets/download (1).jpeg";
  final _img2 = "assets/download.jpeg";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Loads saved app state
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt(_counterKey) ?? 0;
      _isFirstImage = prefs.getBool(_imageKey) ?? true;
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
    });
  }

  /// Saves current app state
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, _counter);
    await prefs.setBool(_imageKey, _isFirstImage);
    await prefs.setBool(_themeKey, _isDarkMode);
  }

  void _incrementCounter() {
    setState(() => _counter++);
    _savePreferences();
  }

  void _toggleImage() {
    setState(() => _isFirstImage = !_isFirstImage);
    _savePreferences();
  }

  void _toggleTheme(bool value) {
    setState(() => _isDarkMode = value);
    _savePreferences();
  }

  Future<void> _resetApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _counter = 0;
      _isFirstImage = true;
      _isDarkMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = _isFirstImage ? _img1 : _img2;

    // Pastel theme setup
    final pastelLightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFFB5EAD7), // mint
        secondary: const Color(0xFFF7D9E3), // pink
        background: const Color(0xFFFFF9F9), // cream
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF9F9),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFB5EAD7),
        foregroundColor: Colors.black,
      ),
    );

    final pastelDarkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFFA0CED9), // teal
        secondary: const Color(0xFFE2F0CB), // pastel green
        background: const Color(0xFF2E2E3A), // soft dark
      ),
      scaffoldBackgroundColor: const Color(0xFF2E2E3A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFA0CED9),
        foregroundColor: Colors.black,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? pastelDarkTheme : pastelLightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("In-Class Activity 6"),
          centerTitle: true,
          actions: [
            Row(
              children: [
                const Icon(Icons.light_mode),
                Switch(
                  value: _isDarkMode,
                  activeColor: Colors.pink.shade200,
                  onChanged: _toggleTheme,
                ),
                const Icon(Icons.dark_mode),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Counter card
              _InfoCard(
                title: "Counter",
                content: "$_counter",
                icon: Icons.numbers,
                color: Colors.pink.shade100,
                action: _ActionButton(
                  label: "Increment",
                  icon: Icons.add,
                  onPressed: _incrementCounter,
                ),
              ),

              const SizedBox(height: 20),

              // Image card
              _InfoCard(
                title: "Image Viewer",
                content: _isFirstImage ? "Image 1" : "Image 2",
                icon: Icons.image,
                color: Colors.blue.shade100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    currentImage,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Text("⚠ Image not found!"),
                  ),
                ),
                action: _ActionButton(
                  label: "Toggle Image",
                  icon: Icons.swap_horiz,
                  onPressed: _toggleImage,
                ),
              ),

              const SizedBox(height: 20),

              // Reset button
              _ActionButton(
                label: "Reset App",
                icon: Icons.refresh,
                color: Colors.pink.shade300,
                onPressed: _resetApp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card widget for structured info
class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;
  final Widget? child;
  final Widget? action;

  const _InfoCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
    this.child,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (child != null) ...[const SizedBox(height: 10), child!],
            if (action != null) ...[const SizedBox(height: 10), action!],
          ],
        ),
      ),
    );
  }
}

/// Reusable pastel button with icon
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.black,
        minimumSize: const Size(160, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      onPressed: onPressed,
    );
  }
}
