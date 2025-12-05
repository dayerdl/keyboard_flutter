import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Function(String val) function;

  const CustomSearchBar({
    super.key,
    required this.title,
    required this.controller,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: controller,
            onChanged: (value) => function(value),
            decoration: InputDecoration(
              hintText: title,

              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
