import 'package:flutter/material.dart';
import 'package:glyph_developer_kit_flutter/glyph_mappings/phone_2.dart';
import 'package:glyph_developer_kit_flutter/glyphs.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nothing Glyphs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const NothingGlyphsPage(title: 'Nothing Glyphs'),
    );
  }
}

class NothingGlyphsPage extends StatefulWidget {
  const NothingGlyphsPage({super.key, required this.title});

  final String title;

  @override
  State<NothingGlyphsPage> createState() => _NothingGlyphsPageState();
}

class _NothingGlyphsPageState extends State<NothingGlyphsPage> {
  final GlyphsPlatform glyphs = GlyphsPlatform();
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nothing Glyphs'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                glyphs.checkIfNothingPhone1().then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value.toString(),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      ),
                    );
              },
              child: const Text("Nothing Phone (1) Check"),
            ),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                glyphs.checkIfNothingPhone2().then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value.toString(),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      ),
                    );
              },
              child: const Text("Nothing Phone (2) Check"),
            ),
            // Turns on the entire C section on the Nothing Phone (2)
            FilledButton(
              onPressed: () {
                GlyphFrame glyphFrame = GlyphFrame(channels: [
                  ...NP2GlyphMappings.C1Sections,
                  NP2GlyphMappings.C2,
                  NP2GlyphMappings.C3,
                  NP2GlyphMappings.C4,
                  NP2GlyphMappings.C5,
                  NP2GlyphMappings.C6,
                ]);
                glyphFrame.toggleGlyphs().onError(
                      (error, stackTrace) =>
                          _logger.e(error, stackTrace: stackTrace),
                    );
              },
              child: const Text("Turn On Section C Glyphs - Phone (2)"),
            ),
            FilledButton(
              onPressed: () {
                GlyphFrame glyphData = GlyphFrame(channels: []);
                glyphData.toggleGlyphs().onError(
                      (error, stackTrace) =>
                          _logger.e(error, stackTrace: stackTrace),
                    );
              },
              child: const Text("Turn Off All Glyphs"),
            ),
          ],
        ),
      ),
    );
  }
}
