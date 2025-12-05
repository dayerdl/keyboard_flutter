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
  // State
  int _counter = 0;
  int _selectedIndex = 0;
  final TextEditingController _textController = TextEditingController();
  final List<String> _items = List.generate(20, (index) => 'Item ${index + 1}');

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Actions
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onItemTap(String item) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tapped on $item')));
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - keyboardHeight;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _buildScrollableContent(
            keyboardHeight: keyboardHeight,
            isKeyboardVisible: isKeyboardVisible,
            screenHeight: screenHeight,
            availableHeight: availableHeight,
          ),
          _buildFloatingButton(keyboardHeight: keyboardHeight),
          _buildBottomNavigationBar(keyboardHeight: keyboardHeight),
        ],
      ),
    );
  }

  Widget _buildScrollableContent({
    required double keyboardHeight,
    required bool isKeyboardVisible,
    required double screenHeight,
    required double availableHeight,
  }) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        _buildSliverAppBar(),
        _buildHeaderSliver(),
        _buildKeyboardInfoSliver(
          isKeyboardVisible: isKeyboardVisible,
          screenHeight: screenHeight,
          keyboardHeight: keyboardHeight,
          availableHeight: availableHeight,
        ),
        _buildTextFieldSliver(),
        _buildItemsListSliver(),
        _buildCounterSliver(),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.title,
          textAlign: TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      centerTitle: false,
      floating: false,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildHeaderSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildHeader(),
      ),
    );
  }

  Widget _buildKeyboardInfoSliver({
    required bool isKeyboardVisible,
    required double screenHeight,
    required double keyboardHeight,
    required double availableHeight,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _buildKeyboardInfo(
          isKeyboardVisible: isKeyboardVisible,
          screenHeight: screenHeight,
          keyboardHeight: keyboardHeight,
          availableHeight: availableHeight,
        ),
      ),
    );
  }

  Widget _buildTextFieldSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildTextField(),
      ),
    );
  }

  Widget _buildItemsListSliver() {
    return _items.isNotEmpty
        ? SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildItemCard(_items[index], index);
            }, childCount: _items.length),
          )
        : const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No items available'),
              ),
            ),
          );
  }

  Widget _buildCounterSliver() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120, top: 16),
        child: _buildCounterSection(),
      ),
    );
  }

  Widget _buildHeader() {
    return Text('David 12', style: Theme.of(context).textTheme.headlineLarge);
  }

  Widget _buildKeyboardInfo({
    required bool isKeyboardVisible,
    required double screenHeight,
    required double keyboardHeight,
    required double availableHeight,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isKeyboardVisible ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keyboard Status: ${isKeyboardVisible ? "VISIBLE ✅" : "HIDDEN ❌"}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Screen Height: ${screenHeight.toStringAsFixed(0)}px'),
          Text('Keyboard Height: ${keyboardHeight.toStringAsFixed(0)}px'),
          Text('Available Height: ${availableHeight.toStringAsFixed(0)}px'),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _textController,
      decoration: const InputDecoration(
        labelText: 'Enter text',
        border: OutlineInputBorder(),
        hintText: 'Type something...',
      ),
    );
  }

  Widget _buildItemCard(String item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(item),
        subtitle: Text('Description for $item'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _onItemTap(item),
      ),
    );
  }

  Widget _buildCounterSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have pushed the button this many times:'),
          Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({required double keyboardHeight}) {
    return Positioned(
      right: 16,
      bottom: keyboardHeight + 72,
      child: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBottomNavigationBar({required double keyboardHeight}) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: keyboardHeight,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
