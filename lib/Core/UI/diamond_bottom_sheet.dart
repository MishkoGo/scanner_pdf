import 'package:flutter/material.dart';
import 'package:scanner_pdf/generated/l10n.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';

class DiamondBottomSheet extends StatefulWidget {
  const DiamondBottomSheet({super.key});

  @override
  State<DiamondBottomSheet> createState() => _DiamondBottomSheetState();
}

class _DiamondBottomSheetState extends State<DiamondBottomSheet> {
  int _selectedPlan = 0;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _loading = true;

  final List<String> _productIds = [
    'pro_month_subscription_scanner',
  ];

  @override
  void initState() {
    super.initState();
    _initializeInAppPurchase();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeInAppPurchase() async {
    final bool available = await _inAppPurchase.isAvailable();
    print('availble: $available');
    if (!mounted) return;

    setState(() {
      _isAvailable = available;
      _loading = false;
    });

    if (!available) {
      return;
    }

    // Подписываемся на поток обновлений покупок
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        // Обработка ошибок
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при обработке покупки: $error')),
          );
        }
      },
    );

    // Загружаем информацию о продуктах (подписках)
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(_productIds.toSet());
    if (!mounted) return;

    print('Loaded products: ${response.productDetails}');
    print('Not found ${response.notFoundIDs}');
    print('error: ${response.error}');

    setState(() {
      _products = response.productDetails;
      _loading = false;
    });

    if (response.error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ошибка загрузки подписок: ${response.error!.message}',
            ),
          ),
        );
      }
    } else {
      // Логируем загруженные продукты для отладки
      print(
        'Загруженные продукты: ${_products.map((p) => "${p.id}: ${p.title} - ${p.price}").toList()}',
      );
    }
  }

  // Обработка обновлений покупок
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Покупка в процессе
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Покупка в процессе...')),
          );
        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Ошибка при покупке
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Ошибка покупки: ${purchaseDetails.error!.message}',
              ),
            ),
          );
        }
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Покупка успешна или восстановлена
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Подписка успешно оформлена!')),
          );
          Navigator.pop(
            context,
          ); // Закрываем BottomSheet после успешной покупки
        }
      }
    }
  }

  // Инициировать покупку
  void _buySubscription(ProductDetails product) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> _restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Восстановление покупок...')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка восстановления: $e')));
      }
    }
  }

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
                  onTap: _restorePurchases,
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
              S.of(context).update_header ?? 'Unlock Pro Features',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).update_desc ??
                  'Get unlimited scans, ad-free experience, and more!',
              style: textTheme.bodyMedium?.copyWith(color: Colors.white60),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (!_isAvailable || _products.isEmpty)
              Text(
                S.of(context).subscription,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )
            else ...[
              ..._products.asMap().entries.map((entry) {
                int index = entry.key;
                ProductDetails product = entry.value;
                return _buildPlanOption(
                  index: index,
                  title: product.title, 
                  price: product.price);
              }).toList(),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _products.isNotEmpty
                        ? () {
                          // Инициируем покупку выбранного плана
                          _buySubscription(_products[_selectedPlan]);
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  S.of(context).test_period ?? 'Подписаться',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).test_period_desc ??
                  'Cancel at any time in Settings > Apple Account at least one day before each renewal date. Plan automatically renews until cancelled.',
              style: textTheme.bodySmall?.copyWith(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOption({
    required int index,
    required String title,
    required String price,
  }) {
    return RadioListTile<int>(
      activeColor: Colors.blueAccent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Text(price, style: const TextStyle(color: Colors.white)),
        ],
      ),
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
