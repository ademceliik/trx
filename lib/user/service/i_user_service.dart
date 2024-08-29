abstract class IUserService {
  Future login({
    required String email,
    required String password,
  });
}
