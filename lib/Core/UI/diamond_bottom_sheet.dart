import 'package:flutter/material.dart';
import 'package:scanner_pdf/generated/l10n.dart';

class DiamondBottomSheet extends StatefulWidget {
  const DiamondBottomSheet({super.key});

  @override
  State<DiamondBottomSheet> createState() => _DiamondBottomSheetState();
}

class _DiamondBottomSheetState extends State<DiamondBottomSheet> {
  int _selectedPlan = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(
                    S.of(context).restore,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    S.of(context).skip,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).update_header,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              S.of(context).update_desc,
              style: textTheme.bodyMedium?.copyWith(color: Colors.white60),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            _buildPlanOption(index: 0, title: S.of(context).price_1),
            _buildPlanOption(index: 1, title: S.of(context).price_2),
            _buildPlanOption(index: 2, title: S.of(context).price_3),
            _buildPlanOption(index: 3, title: S.of(context).price_4),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(S.of(context).test_period, style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              S.of(context).test_period_desc,
              style: textTheme.bodySmall?.copyWith(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOption({required int index, required String title}) {
    return RadioListTile<int>(
      activeColor: Colors.blueAccent,
      title: Text(title, style: TextStyle(color: Colors.white)),
      value: index,
      groupValue: _selectedPlan,
      onChanged: (value) {
        setState(() {
          _selectedPlan = value ?? 0;
        });
      },
    );
  }
}
