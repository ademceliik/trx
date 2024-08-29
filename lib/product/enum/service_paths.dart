enum ServicePaths {
  upload("upload"),
  login("api/User/login"),
  signUp("api/User/register"),
  base("http://185.33.234.174/");

  final String path;

  const ServicePaths(this.path);
}
