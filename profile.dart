import 'package:event_booking_app/pages/signup.dart';
import 'package:event_booking_app/services/auth.dart';
import 'package:event_booking_app/services/shared_pref.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email, id;

  getthesahredpref() async {
    id = await SharedpreferenceHelper().getUserId();
    image = await SharedpreferenceHelper().getUserImage();
    name = await SharedpreferenceHelper().getUserName();
    email = await SharedpreferenceHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getthesahredpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: image == null
          ? const Center(child: CircularProgressIndicator())
              : Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffe3e6ff),
                    Color.fromRGBO(157, 80, 109, 1),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Profile',
                      style: TextStyle(
                            fontSize: 32,
                        fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 75, 73, 73),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                              decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 217, 112, 8),
                                borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                name?.isNotEmpty == true 
                                    ? name![0].toUpperCase() 
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ProfileInfoCard(
                          icon: Icons.person_outline,
                          title: 'Name',
                          value: name ?? 'User',
                        ),
                        const SizedBox(height: 16),
                        ProfileInfoCard(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: email ?? 'user@example.com',
                        ),
                        const SizedBox(height: 32),
                        ProfileActionButton(
                          icon: Icons.contact_support_outlined,
                          title: 'Contact Us',
                          onTap: () {
                            // TODO: Implement contact us functionality
                          },
                        ),
                        const SizedBox(height: 16),
                        ProfileActionButton(
                          icon: Icons.logout,
                          title: 'LogOut',
                              onTap: () {
                                AuthMethods().SignOut().then((value) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                    ),
                                  );
                                });
                              },
                        ),
                        const SizedBox(height: 16),
                        ProfileActionButton(
                          icon: Icons.delete_outline,
                          title: 'Delete Account',
                              onTap: () {
                                AuthMethods().deleteuser().then((value) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                    ),
                                  );
                                });
                              },
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
                                ),
                                child: Row(
                                  children: [
          Icon(icon, size: 24, color: const Color.fromARGB(255, 217, 112, 8)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                                    Text(
                title,
                                      style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 75, 73, 73),
                                      ),
                                    ),
                                  ],
                            ),
                          ],
                        ),
    );
  }
}

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileActionButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color.fromARGB(255, 217, 112, 8);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDestructive ? Colors.red.shade300 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isDestructive ? Colors.red : accentColor,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : const Color.fromARGB(255, 75, 73, 73),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              size: 24,
              color: isDestructive ? Colors.red : Colors.grey,
            ),
                  ],
                ),
              ),
    );
  }
}
