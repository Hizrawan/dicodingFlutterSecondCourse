enum NavigationRoute {
  onboardingRoute("/onboarding"),
  loginRoute("/login"),
  mainRoute("/"),
  detailRoute("/detail"),
  settingsRoute("/settings");

  const NavigationRoute(this.name);
  final String name;
}
