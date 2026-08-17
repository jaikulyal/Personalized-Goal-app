import '../../../../core/storage/local_storage.dart';
import '../local/profile_local_model.dart';

class ProfileLocalDataSource {
  static const String _profileKey = 'profile';

  Future<void> saveProfile(ProfileLocalModel profile) async {
    await LocalStorage.profileBox.put(_profileKey, profile.toMap());
  }

  Future<ProfileLocalModel?> getProfile() async {
    final data = LocalStorage.profileBox.get(_profileKey);

    if (data is! Map) {
      return null;
    }

    final map = Map<String, dynamic>.from(data);

    return ProfileLocalModel.fromMap(map);
  }

  Future<void> deleteProfile() async {
    await LocalStorage.profileBox.delete(_profileKey);
  }
}
