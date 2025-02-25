import 'package:flutter/material.dart';

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
                    'Найстройки',
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
              title: 'Подписка на Pro-версию',
              trailing: 'Не активирована',
              onTap: () {
                //
              },
            ),
            _SettingItem(
              title: 'Управлять подпиской',
              onTap: () {
                //
              },
            ),
            _SettingItem(
              title: 'Язык распознавания',
              trailing: 'английский',
              onTap: () {
                //
              },
            ),
            _SettingItem(
              title: 'Политика конфиденциальности',
              onTap: () {
                _showTextBottomSheet(
                  context,
                  title: 'Политика конфиденциальности',
                  text: '''. INTRODUCTION. REGIONAL PATTERNS (CALIFORNIA)

Chebulaev Oleg Valerevich (“we,” “us” or “our”) takes your privacy seriously. This Privacy policy (“Privacy policy”) explains our data protection policy and describes the types of information we may process when you install and/or use “Doc Scanner — scan to PDF” software application for mobile devices (the “App”, “our App”).

When we refer to personal data (or personal information) we mean any information of any kind relating to a natural person who can be identified, directly or indirectly, in particular by reference to such data.

It is a natural person who can be identified directly or indirectly, in particular by reference to an identification number or to one or more factors specific to his or her physical, physiological, mental, economic, cultural or social status.

Our Privacy policy applies to all users, and others who access the App (“Users”).

For the purposes of the GDPR, we are the data controller, unless otherwise stated.

IF YOU ARE A CALIFORNIA RESIDENT PLEASE READ THE FOLLOWING IMPORTANT NOTICE

Under the California Consumer Privacy Act of 2018 (CCPA) California residents shall have the right to request:

 • the categories of personal information that is processed;
 • the categories of sources from which personal information is obtained;
 • the purpose for processing of user personal data;
 • the categories of third parties with whom we may share your personal information;
 • the specific pieces of personal information that we might have obtained about particular user provided that the data given in the request is reliable enough and allows to identify the user.

Please use the navigation links through this Privacy Policy:

PERSONAL INFORMATION
All about the categories of information, its sources and purposes of processing >>

Please mind that according to CCPA personal information does not include de-identified or aggregated consumer information.

SHARING
How your information can be shared >>

Please note that all third parties that are engaged in processing user data are service providers that use such information on the basis of agreement and pursuant to business purpose.

OPT-OUT OPTIONS
If you don’t want us to process your personal information any more please contact us through e-mail to alegch@bk.ru In most cases there is no way to maintain the App’s further operating without functional data therefore you will be advised to remove the App from your device.

If you don’t want us to share device identifiers and geolocation data with service providers please check your device settings to opt out as described below >>

REQUESTS
To submit a verifiable consumer request for access, portability or deletion personal data please contact us through e-mail to alegch@bk.ru. Please include in the text of your appeal the wording "Your rights to maintain confidentiality in the state of California”.

When submitting a verifiable request, you should be ready to:
• Provide sufficient information that allows us to reasonably verify you are the person about whom we collected personal information or an authorized representative, which may include: name, address, city, state, and zip code and email address. We may use this information to surface a series of security questions to you to verify your identity. If you are making a request through an authorized agent acting on your behalf, such authorized agent must provide written authorization confirming or a power of attorney, signed by you.''',
                );
              },
            ),
            _SettingItem(
              title: 'Правила использования',
              onTap: () {
                //
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white)),
            if (trailing != null)
              Text(trailing!, style: const TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
