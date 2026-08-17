import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/local/profile_local_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileLocalDataSource _profileDataSource = ProfileLocalDataSource();

  final ImagePicker _imagePicker = ImagePicker();

  ProfileLocalModel? _profile;

  //bool _isLoading = true;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileDataSource.getProfile();

      if (!mounted) return;

      setState(() {
        _profile = profile;
        // _isLoading = false;
      });
    } catch (error) {
      debugPrint('Profile loading error: $error');

      if (!mounted) return;

      setState(() {
        //  _isLoading = false;
      });
    }
  }

  Future<void> _pickProfilePhoto() async {
    if (_isPickingImage) return;

    setState(() {
      _isPickingImage = true;
    });

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile == null) {
        return;
      }

      final currentProfile = _profile;

      if (currentProfile == null) {
        debugPrint('Cannot save profile photo because profile does not exist.');
        return;
      }

      final updatedProfile = currentProfile.copyWith(
        photoPath: pickedFile.path,
        updatedAt: DateTime.now(),
      );

      await _profileDataSource.saveProfile(updatedProfile);

      if (!mounted) return;

      setState(() {
        _profile = updatedProfile;
      });
    } catch (error) {
      debugPrint('Profile photo selection error: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to select profile photo.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<void> _removeProfilePhoto() async {
    final currentProfile = _profile;

    if (currentProfile == null) {
      return;
    }

    final updatedProfile = currentProfile.copyWith(
      clearPhoto: true,
      updatedAt: DateTime.now(),
    );

    try {
      await _profileDataSource.saveProfile(updatedProfile);

      if (!mounted) return;

      setState(() {
        _profile = updatedProfile;
      });
    } catch (error) {
      debugPrint('Profile photo removal error: $error');
    }
  }

  Future<void> _showPhotoOptions() async {
    if (_isPickingImage) return;

    final hasPhoto =
        _profile?.photoPath != null && _profile!.photoPath!.isNotEmpty;

    final selectedOption = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                Text(
                  'Profile photo',
                  style: AppTextStyles.title.copyWith(fontSize: 20),
                ),

                const SizedBox(height: AppSpacing.lg),

                _photoOption(
                  icon: Icons.photo_library_outlined,
                  title: hasPhoto ? 'Change photo' : 'Choose from gallery',
                  onTap: () {
                    Navigator.of(context).pop('gallery');
                  },
                ),

                if (hasPhoto) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _photoOption(
                    icon: Icons.delete_outline_rounded,
                    title: 'Remove photo',
                    destructive: true,
                    onTap: () {
                      Navigator.of(context).pop('remove');
                    },
                  ),
                ],

                const SizedBox(height: AppSpacing.sm),

                _photoOption(
                  icon: Icons.close_rounded,
                  title: 'Cancel',
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;

    if (selectedOption == 'gallery') {
      await _pickProfilePhoto();
    } else if (selectedOption == 'remove') {
      await _removeProfilePhoto();
    }
  }

  Widget _photoOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool destructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: destructive
                ? Colors.red.withValues(alpha: 0.05)
                : AppColors.gold.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: destructive ? Colors.redAccent : AppColors.goldDark,
              ),

              const SizedBox(width: AppSpacing.md),

              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: destructive ? Colors.redAccent : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.lg,
                AppSpacing.screen,
                120,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'PROFILE',
                    style: AppTextStyles.label.copyWith(
                      letterSpacing: 1.5,
                      color: AppColors.gold,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text(
                    'Your space.',
                    style: AppTextStyles.display.copyWith(fontSize: 38),
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  Text(
                    'Manage your personal information and preferences.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.muted,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildProfileHeader(),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildSectionTitle('ACCOUNT'),

                  const SizedBox(height: AppSpacing.md),

                  _buildProfileOption(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal information',
                    subtitle: 'Name and email',
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  _buildProfileOption(
                    icon: Icons.lock_outline_rounded,
                    title: 'Password',
                    subtitle: 'Update your password',
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildSectionTitle('PREFERENCES'),

                  const SizedBox(height: AppSpacing.md),

                  _buildProfileOption(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: 'Manage reminders and alerts',
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  _buildProfileOption(
                    icon: Icons.tune_rounded,
                    title: 'Preferences',
                    subtitle: 'Customize your experience',
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  _buildSectionTitle('APP'),

                  const SizedBox(height: AppSpacing.md),

                  _buildProfileOption(
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    subtitle: 'Version and app information',
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final photoPath = _profile?.photoPath;

    final hasPhoto =
        photoPath != null &&
        photoPath.isNotEmpty &&
        File(photoPath).existsSync();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showPhotoOptions,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.35),
                    ),
                  ),
                  child: ClipOval(
                    child: hasPhoto
                        ? Image.file(
                            File(photoPath),
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.goldDark,
                            size: 30,
                          ),
                  ),
                ),

                Positioned(
                  right: -3,
                  bottom: -3,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                    child: _isPickingImage
                        ? const Padding(
                            padding: EdgeInsets.all(5),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt_rounded,
                            size: 13,
                            color: AppColors.primary,
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _profile?.name.isNotEmpty == true
                      ? _profile!.name
                      : 'Your Profile',
                  style: AppTextStyles.title.copyWith(fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppSpacing.xs),

                Text(
                  _profile?.email.isNotEmpty == true
                      ? _profile!.email
                      : 'Set up your personal details',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.muted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.label.copyWith(
        letterSpacing: 1.3,
        color: AppColors.gold,
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.goldDark, size: 22),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
