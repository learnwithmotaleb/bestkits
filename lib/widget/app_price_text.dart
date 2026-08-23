import 'package:bestkits/presentation/currency_preference/widget/currency_helper.dart';
import 'package:flutter/material.dart';

class AppPriceText extends StatelessWidget {
  final dynamic price;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppPriceText({
    Key? key,
    required this.price,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      CurrencyHelper.formatPrice(price),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
