import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/feedback/screens/feedback.dart';
import '../utils/images.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with logo
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppImages.logo, // Path to your SVG logo
                  height: 60,
                ),
                const SizedBox(width: 16),
                const Text(
                  'ዜማ ያሬድ',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          // Dark/Light Mode
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark,
              onChanged: (value) {
                if (value) {
                  AdaptiveTheme.of(context).setDark();
                } else {
                  AdaptiveTheme.of(context).setLight();
                }
              },
            ),
          ),
          // Donate to the Project
          ListTile(
            leading: const Icon(Icons.wallet_giftcard),
            title: const Text('Donate to the Project'),
            onTap: () {
              _launchURL(
                  'https://chapa.link/donation/view/DN-mWA575AY8F51'); // Your donation page URL
            },
          ),
          // Feedback Section
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FeedbackPage(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share App'),
            onTap: () {
              Share.share('Check out this great app!');
            },
          ),
          const Spacer(),
          // Social Links as Icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    AppImages.email,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () => _launchURL('malito:natnaeldenbi@gmail.com'),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    AppImages.linkedIn,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () => _launchURL(
                      'https://linkedin.com/in/natnael-tadele-b3534b230/'),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    AppImages.telegram,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () => _launchURL('https://t.me/am_naty'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
