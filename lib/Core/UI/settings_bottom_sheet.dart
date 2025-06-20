import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_pdf/Core/UI/diamond_bottom_sheet.dart';
import 'package:scanner_pdf/common/models/localeProvider.dart';
import 'package:scanner_pdf/generated/l10n.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    S.of(context).settings,
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 8),

            _SettingItem(
              title: S.of(context).subscription,
              trailing: S.of(context).status_subscription,
              onTap: () {
                Navigator.pop(context);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    isScrollControlled: true,
                    builder: (context) => const DiamondBottomSheet(),
                  );
                });
              },
            ),
            _SettingItem(
              title: S.of(context).manage_subscription,
              onTap: () {
                Navigator.pop(context);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    isScrollControlled: true,
                    builder: (context) => const DiamondBottomSheet(),
                  );
                });
              },
            ),
            _SettingItem(
              title: S.of(context).language,
              trailing: S.of(context).current_language,
              onTap: () {
                _showLanguageSelectionBottomSheet(context);
              },
            ),
            _SettingItem(
              title: S.of(context).political,
              onTap: () {
                _showTextBottomSheet(
                  context,
                  title: S.of(context).political,
                  text: '''

This Privacy Policy describes how Victor Bondarev ("we," "us," or "our") collects, uses, and discloses your information when you use the mobile application DOC CAM Scanner App To PDF pro (the "App"). By downloading, accessing, or using the App, you consent to the data practices described in this Privacy Policy.

1. INFORMATION WE COLLECT

When you use our App, we may collect the following types of information:

1.1 Personal Data

We do not collect, store, or share any personally identifiable information ("PII") unless explicitly provided by you (e.g., customer support inquiries).

1.2 Non-Personal Data

We may collect non-personal information related to your use of the App, including but not limited to:

 ● Device model and operating system
 ● App usage statistics
 ● Crash logs (to improve app performance)

1.3 Document Data

 ● The App allows you to scan, store, and share documents locally on your device.
 ● We do not collect or store any scanned documents, images, or content you process within the App.
 ● Your scanned files remain private and are never transmitted to our servers or third-party services unless you choose to share them.

2. HOW WE USE YOUR INFORMATION

We use the collected data solely for the following purposes:

 ● To provide and improve the App's functionality
 ● To analyze App performance and usage trends
 ● To troubleshoot issues and prevent fraud

We do not sell, rent, or share your personal or document data with third parties.

3. THIRD-PARTY SERVICES

The App may integrate with third-party services, such as:

● Cloud storage providers (e.g., iCloud, Google Drive, Dropbox) for file export
● Apple’s services (e.g., iCloud sync)
Any data you share with third-party services is subject to their respective privacy policies. We are not responsible for data processing by third parties.

 
4. DATA SECURITY

We take appropriate security measures to protect your information, including:

● Secure data storage on your device
● Encryption protocols for data transmission where applicable
However, no digital system is 100% secure, and we cannot guarantee absolute security.

 
5. YOUR RIGHTS AND CHOICES

As a user, you have the following rights:

● Access & Deletion: You can delete all stored documents directly from your device.
● Opt-Out: You can disable data collection (such as analytics) in the App settings or your device's privacy settings.
 
6. CHILDREN’S PRIVACY

The App is not intended for children under 13. We do not knowingly collect personal data from minors. If you are a parent or guardian and believe your child has provided us with data, please contact us to request deletion.

 
7. CHANGES TO THIS PRIVACY POLICY

We reserve the right to update this Privacy Policy at any time. Changes will be effective immediately upon posting in the App. Continued use of the App after updates constitutes acceptance of the revised Privacy Policy.

 
8. CONTACT US

If you have any questions about this Privacy Policy, please contact us at: Victor Bondarev
Email: viktor_bondarev@mail.ru

9. DATA RETENTION

We retain non-personal data only for as long as necessary to fulfill the purposes outlined in this Privacy Policy. Any personal data voluntarily provided by you (such as customer support inquiries) will be retained only as long as required to resolve the issue or comply with legal obligations.

 
10. INTERNATIONAL DATA TRANSFERS

Your information is stored and processed on your device, and we do not transfer data to external servers. If you use third-party services for cloud storage, your data may be transferred and processed in accordance with their policies.

 
11. USER CONSENT AND CONTROL

By using the App, you acknowledge and agree to the terms of this Privacy Policy. You have the right to withdraw your consent at any time by uninstalling the App and discontinuing use.

 
12. LEGAL COMPLIANCE

This Privacy Policy complies with applicable data protection laws, including but not limited to:

● General Data Protection Regulation (GDPR) (EU)
● California Consumer Privacy Act (CCPA) (USA)
● Apple’s App Store Review Guidelines

We are committed to ensuring the privacy and security of our users' data in accordance with these regulations.

 
Compliance with Apple’s Requirements: This Privacy Policy complies with Apple’s App Store Review Guidelines, ensuring:

● Transparency in data collection and use
● User control over their data
● Strict data security measures
● No unnecessary tracking or sharing with third parties

By using the App, you acknowledge that you have read and understood this Privacy Policy.
''',
                );
              },
            ),
            _SettingItem(
              title: S.of(context).rules_uses,
              onTap: () {
                _showTextBottomSheet(
                  context,
                  title: S.of(context).rules_uses,
                  text: '''
1. INTRODUCTION Welcome to DOC CAM Scanner App ("App"). These Terms of Use ("Terms") govern your access to and use of the App and related services. By using the App, you agree to comply with these Terms. If you do not agree, please do not use the App.

2. ELIGIBILITY You must be at least 18 years old to use this App. By using the App, you represent that you meet this requirement.

3. LICENSE GRANT We grant you a limited, non-exclusive, non-transferable, revocable license to use the App solely for personal, non-commercial purposes, subject to these Terms.

4. USER DATA AND PRIVACY Your privacy is important to us. Please review our Privacy Policy, which explains how we collect, use, and share your personal data.

5. ACCEPTABLE USE You agree not to:

● Use the App for any illegal or unauthorized purpose.
● Disrupt or interfere with the App’s security or functionality.
● Reverse-engineer, decompile, or disassemble the App.

6. INTELLECTUAL PROPERTY All rights, title, and interest in the App and its content belong to us or our licensors. You may not use any content without our prior written permission.

7. PAYMENTS AND SUBSCRIPTIONS The App may offer in-app purchases and subscriptions through Apple App Store. Payments are processed by Apple, and their terms apply. We do not store or process payment details.

8. TERMINATION We reserve the right to suspend or terminate your access to the App if you violate these Terms.

9. DISCLAIMER OF WARRANTIES The App is provided "as is" without warranties of any kind. We do not guarantee uninterrupted or error-free use.

10. LIMITATION OF LIABILITY To the maximum extent permitted by law, we are not liable for any indirect, incidental, or consequential damages arising from your use of the App.

11. GOVERNING LAW These Terms are governed by the laws of the United States and the State of California.

12. CHANGES TO THESE TERMS We may update these Terms from time to time. Continued use of the App after changes means you accept the new Terms.

13. CONTACT INFORMATION If you have any questions, contact us at viktor_bondarev@mail.ru.

14. THIRD-PARTY SERVICES The App may contain links to third-party websites and services. We are not responsible for the content, policies, or practices of any third-party services. Your interactions with third-party services are solely your responsibility.

15. SUPPORT AND UPDATES We may provide periodic updates to improve functionality and security. You agree to receive these updates as part of your use of the App. If you experience any issues, you may contact our support team at viktor_bondarev@mail.ru.

16. DATA STORAGE AND SECURITY We take reasonable measures to protect your personal data, but we cannot guarantee absolute security. You acknowledge and accept the risks associated with transmitting data over the internet.

17. USER-GENERATED CONTENT If the App allows you to submit content, you grant us a non-exclusive, worldwide, royalty-free license to use, modify, and distribute such content for the operation of the App. You agree not to submit illegal, offensive, or infringing content.

18. SEVERABILITY If any provision of these Terms is found to be invalid or unenforceable, the remaining provisions will continue in full force and effect.

19. ENTIRE AGREEMENT These Terms constitute the entire agreement between you and us regarding the use of the App and supersede any prior agreements or understandings, whether written or oral.

20. DISPUTE RESOLUTION Any disputes arising from these Terms shall be resolved through binding arbitration in accordance with the rules of the American Arbitration Association. You waive your right to participate in class-action lawsuits or class-wide arbitration.

21. INDEMNIFICATION You agree to indemnify, defend, and hold harmless us and our affiliates from any claims, liabilities, damages, losses, or expenses arising from your use of the App or violation of these Terms.

22. FORCE MAJEURE We shall not be held liable for any failure or delay in performance due to circumstances beyond our reasonable control, including natural disasters, acts of war, cyber-attacks, or regulatory changes.

23. APP UPDATES AND MODIFICATIONS We reserve the right to modify or discontinue any aspect of the App at any time without prior notice. Your continued use of the App after updates constitutes acceptance of the changes.


                    ''',
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

void _showLanguageSelectionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: scrollController,
                children: [
                  ListTile(
                    title: Text(
                      S.of(context).english_lang,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Provider.of<LocaleProvider>(
                        context,
                        listen: false,
                      ).setLocale(const Locale('en'));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).russian_lang,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Provider.of<LocaleProvider>(
                        context,
                        listen: false,
                      ).setLocale(const Locale('ru'));
                      Navigator.pop(context);
                    },
                  ),

                  ListTile(
                    title: Text(
                      S.of(context).ukraine_lang,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Provider.of<LocaleProvider>(
                        context,
                        listen: false,
                      ).setLocale(const Locale('uk'));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).espan_lang,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Provider.of<LocaleProvider>(
                        context,
                        listen: false,
                      ).setLocale(const Locale('es'));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      S.of(context).chinese_lang,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Provider.of<LocaleProvider>(
                        context,
                        listen: false,
                      ).setLocale(const Locale('zh'));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
  ).then((selectedLanguage) {
    if (selectedLanguage != null) {
      print('Выбран язык: $selectedLanguage');
    }
  });
}

void _showTextBottomSheet(
  BuildContext context, {
  required String title,
  required String text,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return TextContentBottomSheet(
              title: title,
              text: text,
              scrollController: scrollController,
            );
          },
        ),
  );
}

class TextContentBottomSheet extends StatelessWidget {
  final String title;
  final String text;
  final ScrollController scrollController;

  const TextContentBottomSheet({
    super.key,
    required this.title,
    required this.text,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    super.key,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white)),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8,),
              Text(trailing!, style: const TextStyle(color: Colors.white54)),
            ]
          ],
        ),
      ),
    );
  }
}
