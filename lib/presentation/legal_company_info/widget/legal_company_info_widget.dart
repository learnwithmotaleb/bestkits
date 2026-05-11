
// ─────────────────────────────────────────────
// widget/legal_company_info_widget.dart
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../../../core/responsive_layout/dimensions.dart';

class LegalCompanyInfoWidget extends StatelessWidget {
  final List<Map<String, String>> fields;

  const LegalCompanyInfoWidget({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(18),
        vertical: Dimensions.h(4),
      ),
      itemCount: fields.length,
      separatorBuilder: (_, __) => SizedBox(height: Dimensions.h(10)),
      itemBuilder: (context, index) {
        final field = fields[index];
        return _InfoCard(
          label: field['label']!,
          value: field['value']!,
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.w(16),
        vertical: Dimensions.h(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.r(14)),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: Dimensions.fs(11),
              color: const Color(0xFF999999),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: Dimensions.h(4)),
          Text(
            value,
            style: TextStyle(
              fontSize: Dimensions.fs(15),
              color: const Color(0xFF1A1A1A),
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}