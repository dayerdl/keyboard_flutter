import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // DETECCIÓN DEL TECLADO
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    // Tamaños de pantalla
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - keyboardHeight;

    final viewportHeight =
        MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: viewportHeight,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: viewportHeight - 32,
                child: Column(
                  children: [
                    Text(
                      'David 8',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 16),

                    // INFORMACIÓN DEL TECLADO
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isKeyboardVisible
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keyboard Status: ${isKeyboardVisible ? "VISIBLE ✅" : "HIDDEN ❌"}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Screen Height: ${screenHeight.toStringAsFixed(0)}px',
                          ),
                          Text(
                            'Keyboard Height: ${keyboardHeight.toStringAsFixed(0)}px',
                          ),
                          Text(
                            'Available Height: ${availableHeight.toStringAsFixed(0)}px',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Enter text',
                        border: OutlineInputBorder(),
                        hintText: 'Type something...',
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'You have pushed the button this many times:',
                            ),
                            Text(
                              '$_counter',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 72),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
