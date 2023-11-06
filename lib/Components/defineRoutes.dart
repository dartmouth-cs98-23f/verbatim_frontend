import 'package:fluro/fluro.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/screens/forgotPassword.dart';
import 'package:verbatim_frontend/screens/globalChallenge.dart';
import 'package:verbatim_frontend/screens/logIn.dart';
import 'package:verbatim_frontend/screens/onboardingPage1.dart';
import 'package:verbatim_frontend/screens/onboardingPage2.dart';
import 'package:verbatim_frontend/screens/onboardingPage3.dart';
import 'package:verbatim_frontend/screens/onboardingPage4.dart';
import 'package:verbatim_frontend/screens/signUp.dart';
import 'package:verbatim_frontend/screens/signupErrorMessage.dart';

class Application {
  static FluroRouter router = FluroRouter();
}

void defineRoutes() {
  Application.router.define(
    '/onboarding_page1',
    handler: onBoardingPage1Handler,
  );

  Application.router.define(
    '/onboarding_page2',
    handler: onBoardingPage2Handler,
  );

  Application.router.define(
    '/onboarding_page3',
    handler: onBoardingPage3Handler,
  );

  Application.router.define(
    '/onboarding_page4',
    handler: onBoardingPage4Handler,
  );

  Application.router.define(
    '/signup',
    handler: signUpHandler,
  );

  Application.router.define(
    '/login',
    handler: logInHandler,
  );

  Application.router.define(
    '/global_challenge',
    handler: globalChallengeHandler,
  );

  Application.router.define(
    '/add_friend',
    handler: addFriendHandler,
  );

  Application.router.define(
    '/forgot_password',
    handler: forgotPasswordHandler,
  );

  Application.router.define(
    '/signup_error_message',
    handler: signupErrorMessageHandler,
  );
}

var onBoardingPage1Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      return OnBoardingPage1();
    }
  },
);

var onBoardingPage2Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      return OnBoardingPage2();
    }
  },
);

var onBoardingPage3Handler = Handler(
    handlerFunc: (context, parameters) {
      if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
        return LogIn();
      } else {
        return OnBoardingPage3();
      }
    },
);

var onBoardingPage4Handler = Handler(
    handlerFunc: (context, parameters) {
      if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
        return LogIn();
      } else {
        return OnBoardingPage4();
      }
    },
);

var signUpHandler = Handler(
  handlerFunc: (context, parameters) {
    return SignUp();
  },
);

var logInHandler = Handler(
  handlerFunc: (context, parameters) {
    return LogIn();
  },
);

var globalChallengeHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      print('\nEmail here in define routes: ${SharedPrefs().getEmail()}');
      return globalChallenge();
    }
  },
);

var addFriendHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      return addFriend();
    }
  },
);

var forgotPasswordHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      return ForgotPassword();
    }
  },
);

var signupErrorMessageHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      return SignupErrorMessage(pageName: 'log in');
    }
  },
);
