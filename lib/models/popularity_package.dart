import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PopularityPackage {
  final String id;
  final String title;
  final String description;
  final int popularityAmount;
  final double price;
  final IconData icon;
  final bool isPremium;

  const PopularityPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.popularityAmount,
    required this.price,
    required this.icon,
    this.isPremium = false,
  });
}