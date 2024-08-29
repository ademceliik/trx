abstract class IUserService {
  Future login({
    required String email,
    required String password,
  });

  Future register({
    required String fullName,
    required String userName,
    required String email,
    required String password,
  });
}
