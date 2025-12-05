import 'package:flutter/material.dart';
import 'search_bar_widget.dart';

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
  final TextEditingController _searchController = TextEditingController();
  final List<String> _items = List.generate(20, (index) => 'Item ${index + 1}');

  @override
  void dispose() {
    _textController.dispose();
    _searchController.dispose();
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

  void _handleSearch(String value) {
    // Handle search logic here
    print('Searching for: $value');
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - keyboardHeight;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Scaffold(
        body: Stack(
          children: [
            _buildScrollableContent(
              keyboardHeight: keyboardHeight,
              isKeyboardVisible: isKeyboardVisible,
              screenHeight: screenHeight,
              availableHeight: availableHeight,
            ),
            _buildFloatingButton(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
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
        _buildHeaderSliver(),
        _buildKeyboardInfoSliver(
          isKeyboardVisible: isKeyboardVisible,
          screenHeight: screenHeight,
          keyboardHeight: keyboardHeight,
          availableHeight: availableHeight,
        ),
        _buildSearchBarSliver(),
        _buildTextFieldSliver(),
        _buildItemsListSliver(),
        _buildCounterSliver(),
      ],
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

  Widget _buildSearchBarSliver() {
    return SliverToBoxAdapter(
      child: CustomSearchBar(
        title: 'Search items...',
        controller: _searchController,
        function: _handleSearch,
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
        padding: const EdgeInsets.only(bottom: 80, top: 16),
        child: _buildCounterSection(),
      ),
    );
  }

  Widget _buildHeader() {
    return Text('David 15', style: Theme.of(context).textTheme.headlineLarge);
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

  Widget _buildFloatingButton() {
    return Positioned(
      right: 16,
      bottom: 16,
      child: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(0.0, -4.0),
            blurRadius: 16.0,
            color: Colors.black38,
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onBottomNavTap,
        indicatorColor: Theme.of(context).colorScheme.primary,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
