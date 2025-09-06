enum NavigationRoute {
  onboardingRoute("/onboarding"),
  loginRoute("/login"),
  mainRoute("/"),
  detailRoute("/detail");

  const NavigationRoute(this.name);
  final String name;
}
