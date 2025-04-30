abstract class AuthRepository {
  Future<void> registerUser(String email, String password);
  Future<bool> loginUser(String email, String password);
  Future<void> logoutUser();
  Future<String?> getUserEmail();
}
