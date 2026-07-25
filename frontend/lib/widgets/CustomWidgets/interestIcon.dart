import 'package:flutter/material.dart';

   IconData getInterestIcon(String interest) {
    switch (interest.toLowerCase()) {
      case "coding":
        return Icons.code;
      case "gaming":
        return Icons.sports_esports;
      case "music":
        return Icons.music_note;
      case "sports":
        return Icons.sports_soccer;
      case "movies":
        return Icons.movie;
      case "books":
        return Icons.menu_book;
      case "travel":
        return Icons.flight;
      case "food":
        return Icons.restaurant;
      case "photography":
        return Icons.camera_alt;
      case "fitness":
        return Icons.fitness_center;
      case "technology":
        return Icons.memory;
      case "art":
        return Icons.palette;
      default:
        return Icons.interests;
    }
  }