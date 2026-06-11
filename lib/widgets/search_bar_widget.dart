import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search opportunities, clubs, events…',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white38
                : AppColors.textTertiary,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,
        ),
      ),
    );
  }
}
