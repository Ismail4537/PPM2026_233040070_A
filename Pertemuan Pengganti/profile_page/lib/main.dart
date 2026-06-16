import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfileData {
  final String avatarUrl;
  final Uint8List? avatarBytes;
  final String profileName;
  final String subtitle;
  final String about;
  final String education;
  final String location;
  final String contact;
  final String skills;

  ProfileData({
    required this.avatarUrl,
    this.avatarBytes,
    required this.profileName,
    required this.subtitle,
    required this.about,
    required this.education,
    required this.location,
    required this.contact,
    required this.skills,
  });

  ProfileData copyWith({
    String? avatarUrl,
    Uint8List? avatarBytes,
    String? profileName,
    String? subtitle,
    String? about,
    String? education,
    String? location,
    String? contact,
    String? skills,
  }) {
    return ProfileData(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      profileName: profileName ?? this.profileName,
      subtitle: subtitle ?? this.subtitle,
      about: about ?? this.about,
      education: education ?? this.education,
      location: location ?? this.location,
      contact: contact ?? this.contact,
      skills: skills ?? this.skills,
    );
  }

  ImageProvider? get imageProvider {
    if (avatarBytes != null) {
      return MemoryImage(avatarBytes!);
    }
    if (avatarUrl.isNotEmpty) {
      return NetworkImage(avatarUrl);
    }
    return null;
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData profile = ProfileData(
    avatarUrl: '',
    profileName: 'Ismail Abdul Fathan',
    subtitle: 'Mahasiswa Teknik Informatika',
    about:
        'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan pengembangan game.',
    education: 'Universitas Pasundan — Semester 6\nIPK: 3.75',
    location: 'Bandung, Indonesia',
    contact: 'horispararoh457@gmail.com\n+62 877-2000-8578',
    skills: 'Flutter • Dart • UI Design',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(leading: Icon(Icons.settings), title: Text('Pengaturan')),
            ListTile(leading: Icon(Icons.info), title: Text('Tentang')),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === HEADER PROFIL ===
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: profile.imageProvider,
                    child: profile.imageProvider == null
                        ? const Icon(
                            Icons.person_rounded,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.profileName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // === BARIS STATISTIK (Row + Expanded) ===
            Row(
              children: [
                Expanded(
                  child: _StatBox(label: 'Post', value: '12'),
                ),
                Expanded(
                  child: _StatBox(label: 'Teman', value: '128'),
                ),
                Expanded(
                  child: _StatBox(label: 'Like', value: '1.2K'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // === SECTION CARD ===
            _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: profile.about,
            ),
            _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: profile.education,
            ),
            _SectionCard(
              icon: Icons.location_on,
              title: 'Lokasi',
              content: profile.location,
            ),
            _SectionCard(
              icon: Icons.star,
              title: 'Skills',
              content: profile.skills,
            ),
            _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: profile.contact,
            ),
            const SizedBox(height: 80), // ruang agar FAB tidak nutupi konten
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openEditProfile,
        label: const Text('Edit'),
        icon: const Icon(Icons.edit),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Pesan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        onTap: (i) {},
      ),
    );
  }

  void _openEditProfile() async {
    final updatedProfile = await Navigator.push<ProfileData>(
      context,
      MaterialPageRoute(builder: (_) => EditProfilePage(profile: profile)),
    );

    if (updatedProfile != null) {
      setState(() {
        profile = updatedProfile;
      });
    }
  }
}

class EditProfilePage extends StatefulWidget {
  final ProfileData profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _aboutController;
  late final TextEditingController _educationController;
  late final TextEditingController _locationController;
  late final TextEditingController _contactController;
  late final TextEditingController _skillsController;
  Uint8List? _pickedAvatarBytes;

  ImageProvider? get _currentAvatarProvider {
    if (_pickedAvatarBytes != null) {
      return MemoryImage(_pickedAvatarBytes!);
    }
    return widget.profile.imageProvider;
  }

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController(text: widget.profile.about);
    _educationController = TextEditingController(
      text: widget.profile.education,
    );
    _locationController = TextEditingController(text: widget.profile.location);
    _contactController = TextEditingController(text: widget.profile.contact);
    _skillsController = TextEditingController(text: widget.profile.skills);
    _pickedAvatarBytes = widget.profile.avatarBytes;
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _educationController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Foto Profil',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _currentAvatarProvider,
                      child: _currentAvatarProvider == null
                          ? const Icon(
                              Icons.person,
                              size: 56,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Ganti Foto dari Galeri'),
              ),
            ),
            const Divider(height: 32, thickness: 1),
            _buildTextField('Tentang Saya', _aboutController, maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField('Pendidikan', _educationController, maxLines: 2),
            const SizedBox(height: 16),
            _buildTextField('Lokasi', _locationController),
            const SizedBox(height: 16),
            _buildTextField('Kontak', _contactController, maxLines: 2),
            const SizedBox(height: 16),
            _buildTextField('Skills', _skillsController),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage == null) {
      return;
    }

    final bytes = await pickedImage.readAsBytes();
    setState(() {
      _pickedAvatarBytes = bytes;
    });
  }

  void _saveProfile() {
    final updated = widget.profile.copyWith(
      avatarUrl: _pickedAvatarBytes != null ? '' : widget.profile.avatarUrl,
      avatarBytes: _pickedAvatarBytes,
      about: _aboutController.text.trim(),
      education: _educationController.text.trim(),
      location: _locationController.text.trim(),
      contact: _contactController.text.trim(),
      skills: _skillsController.text.trim(),
    );
    Navigator.pop(context, updated);
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
