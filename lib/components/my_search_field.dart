import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:stoktakip_app/size_config.dart';

class MySearchField<T> extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final List<SearchFieldListItem<T>> suggestions;
  final Function(SearchFieldListItem<T>)? onSuggestionTap;
  MySearchField(
      {this.controller,
      this.hint,
      required this.suggestions,
      this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    return SearchField(
      hint: hint,
      controller: controller,
      suggestionState: Suggestion.expand,
      searchInputDecoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueGrey.shade200,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.blue.withOpacity(0.8),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      maxSuggestionsInViewPort: 6,
      itemHeight: getProportionateScreenHeight(50),
      suggestionsDecoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 232, 232),
        borderRadius: BorderRadius.circular(10),
      ),
      suggestions: suggestions,
      onSuggestionTap: onSuggestionTap,
    );
  }
}
