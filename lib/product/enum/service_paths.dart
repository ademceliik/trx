enum ServicePaths {
  upload("upload"),
  login("api/Users/login"),
  register("api/Users/register"),
  getUserFiles("userfiles"),
  delete("delete"),
  base("http://185.33.234.174/");

  final String path;

  const ServicePaths(this.path);
}
