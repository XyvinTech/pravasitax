import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pravasitax_flutter/src/data/providers/auth_provider.dart';
import 'package:pravasitax_flutter/src/data/providers/user_provider.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/documents.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/help_center.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/my_filings.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/about.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/my_posts.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/privacy_policy.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/saved_news.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/subscriptions.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/termsandconditions.dart';
import 'package:pravasitax_flutter/src/interface/screens/menu_pages/notification_setting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/models/user_model.dart';

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userDetails = ref
        .watch(
          userDetailsProvider(authState.token ?? ''),
        )
        .whenData((data) => data as User);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header with close button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(),
          // Profile content
          Expanded(
            child: userDetails.when(
              data: (user) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey,
                              child:
                                  const Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (user.email != null) ...[
                                SizedBox(height: 4),
                                Text(
                                  user.email!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                              if (user.mobile != null) ...[
                                SizedBox(height: 4),
                                Text(
                                  user.mobile!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                              if (user.residingCountry != null) ...[
                                SizedBox(height: 4),
                                Text(
                                  user.residingCountry!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              _showEditProfileModal(
                                  context, ref, user, authState.token ?? '');
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    _buildSectionHeader('ACCOUNT'),

                    // _buildListTile(
                    //   context,
                    //   Icons.help_outline,
                    //   'Help Center',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => HelpCenterPage()),
                    //     );
                    //   },
                    // ),
                    // Container(color: Color(0xFFD9D9D9), height: 1),
                    // _buildListTile(
                    //   context,
                    //   Icons.rule,
                    //   'My Filings',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => MyFilingsPage()),
                    //     );
                    //   },
                    // ),
                    // Container(color: Color(0xFFD9D9D9), height: 1),
                    // _buildListTile(
                    //   context,
                    //   Icons.rule,
                    //   'About Us',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => AboutPage()),
                    //     );
                    //   },
                    // ),
                    // Container(color: Color(0xFFD9D9D9), height: 1),
                    // _buildListTile(
                    //   context,
                    //   Icons.file_present_outlined,
                    //   'Documents',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => DocumentsPage()),
                    //     );
                    //   },
                    // ),
                    // Container(color: Color(0xFFD9D9D9), height: 1),
                    // _buildListTile(
                    //   context,
                    //   Icons.subscriptions_outlined,
                    //   'Subscriptions',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => SubscriptionsPage()),
                    //     );
                    //   },
                    // ),
                    // Container(color: Color(0xFFD9D9D9), height: 1),
                    // _buildListTile(
                    //   context,
                    //   Icons.post_add_outlined,
                    //   'My Posts',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => MyPostsPage()),
                    //     );
                    //   },
                    // ),
                    // Container(color: Color(0xFFD9D9D9), height: 1),
                    // _buildListTile(
                    //   context,
                    //   Icons.rule,
                    //   'Privacy Policy',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => PrivacyPolicyPage()),
                    //     );
                    //   },
                    // ),
                    // Container(color: Color(0xFFD9D9D9), height: 1),
                    // _buildListTile(
                    //   context,
                    //   Icons.save_alt_outlined,
                    //   'Saved News',
                    //   onTap: () => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => SavedNewsPage()),
                    //   ),
                    // ),
                    // Container(color: Color(0xFFD9D9D9), height: 1),
                    // _buildListTile(
                    //   context,
                    //   Icons.rule,
                    //   'Terms and Conditions',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => TermsAndConditionsPage()),
                    //     );
                    //   },
                    // ),
                    // Container(color: Color(0xFFD9D9D9), height: 1),
                    // _buildListTile(
                    //   context,
                    //   Icons.rule_outlined,
                    //   'Notification Settings',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => NotificationSettingsPage()),
                    //     );
                    //   },
                    // ),

                    Container(color: Color(0xFFF2F2F2), height: 15),
                    _buildListTile(context, Icons.logout, 'Logout', onTap: () {
                      _showLogoutDialog(context);
                    }),
                    Container(color: Color(0xFFF2F2F2), height: 15),
                    _buildListTile(
                        context, Icons.delete_forever, 'Delete Account',
                        onTap: () {
                      _showDeleteAccountDialog(context);
                    }),
                    Container(color: Color(0xFFF2F2F2), height: 100),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading profile: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileModal(
      BuildContext context, WidgetRef ref, User user, String token) {
    final nameController = TextEditingController(text: user.name);
    final mobileController = TextEditingController(text: user.mobile ?? '');
    final countryCodeController =
        TextEditingController(text: user.countryCode ?? '+91');
    final residingCountryController =
        TextEditingController(text: user.residingCountry ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: countryCodeController,
                            decoration: InputDecoration(
                              labelText: "Code",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            controller: mobileController,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: residingCountryController,
                      decoration: InputDecoration(
                        labelText: "Residing Country",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (user.email != null) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: user.email,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "Email ID",
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Center(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final updateState = ref.watch(userProvider);

                          return updateState.when(
                            data: (_) => ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  try {
                                    await ref
                                        .read(userProvider.notifier)
                                        .updateUser(
                                          userToken: token,
                                          name: nameController.text,
                                          mobile: mobileController.text,
                                          countryCode:
                                              countryCodeController.text,
                                          residingCountry:
                                              residingCountryController.text,
                                        );

                                    // Refresh user details
                                    ref.refresh(userDetailsProvider(token));

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Profile updated successfully')),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to update profile: $e')),
                                      );
                                    }
                                  }
                                }
                              },
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF9B406),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 48,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            loading: () => CircularProgressIndicator(),
                            error: (error, _) => Column(
                              children: [
                                Text('Error: $error',
                                    style: TextStyle(color: Colors.red)),
                                ElevatedButton(
                                  onPressed: () {
                                    ref.refresh(userProvider);
                                  },
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title,
      {Function()? onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: const Color(0xFF797474)),
      ),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      trailing: SvgPicture.asset(
        'assets/icons/polygon.svg',
        height: 16,
        width: 16,
        color: const Color(0xFFC4C4C4),
      ),
      onTap: onTap ?? () {},
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            Consumer(
              builder: (context, ref, child) {
                return TextButton(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/',
                        (route) => false,
                      );
                    }
                  },
                  child: const Text("Logout"),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
              "Are you sure you want to delete your account? This action is irreversible."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
