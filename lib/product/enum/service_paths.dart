enum ServicePaths {
  upload("upload"),
  login("api/Users/login"),
  register("api/Users/register"),
  base("http://185.33.234.174/");

  final String path;

  const ServicePaths(this.path);
}
