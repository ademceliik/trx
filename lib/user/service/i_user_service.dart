abstract class IUserService {
  Future login({
    required String email,
    required String password,
  });

  Future register(
      {required String fullName,
      required String userName,
      required String email,
      required String password,
      required String macAddress});
  Future uploadFile({required String filePath, required String userToken});
  Future getUserFiles({required String userToken});
  Future deleteFile({required String fileName, required String userToken});
}
