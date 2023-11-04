import 'package:fluro/fluro.dart';
import 'package:verbatim_frontend/screens/onboardingPage1.dart';

import '../screens/signUp.dart';
import '../screens/signupinErrorMessage.dart';

class Application {
  static FluroRouter router = FluroRouter();
}

void defineRoutes() {
  Application.router.define(
    '/signup',
    handler: Handler(
      handlerFunc: (context, parameters) {
        return SignUp();
      },
    ),
  );

  Application.router.define(
    '/onboardingpage1',
    handler: Handler(
      handlerFunc: (context, parameters) {
        return OnBoardingPage1();
      },
    ),
  );

  Application.router.define(
    '/signupErrorMessage',
    handler: Handler(
      handlerFunc: (context, parameters) {
        return SignupErrorMessage();
      },
    ),
  );

  // Add more routes as needed
}
