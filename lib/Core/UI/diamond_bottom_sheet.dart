import 'package:flutter/material.dart';

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
                    'Восстановить',
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
                    'Пропустить',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Обновите до Pro-версии и\n получите доступ ко всем\n возможностям приложения',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '• Пакетное сканирование\n'
              '• Экспорт без ограничений\n'
              '• Неограниченное количество сканирований\n'
              '• Распознавание текста (OCR)\n',
              style: textTheme.bodyMedium?.copyWith(color: Colors.white60),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            _buildPlanOption(index: 0, title: 'Pro (1 месяц) 4,49\$'),
            _buildPlanOption(index: 1, title: 'Pro (1 месяц) 9,99\$'),
            _buildPlanOption(index: 2, title: 'Pro (1 год) 28,99\$'),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Начать бесплатно пробный период'),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Пробный период 7 дней. Можно отменить в любое время.',
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
