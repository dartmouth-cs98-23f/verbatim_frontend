import 'package:fluro/fluro.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/screens/forgotPassword.dart';
import 'package:verbatim_frontend/screens/logout.dart';
import '../screens/globalChallenge.dart';
import '../screens/logIn.dart';
import '../screens/profile.dart';
import '../screens/onboardingPage1.dart';
import '../screens/onboardingPage2.dart';
import '../screens/onboardingPage3.dart';
import '../screens/onboardingPage4.dart';
import '../screens/signUp.dart';
import '../screens/signupErrorMessage.dart';
import '../screens/settings.dart';

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
    '/settings',
    handler: settingsHandler,
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
    '/profile',
    handler: profileHandler,
  );

  Application.router.define(
    '/signup_error_message',
    handler: signupErrorMessageHandler,
  );

  Application.router.define(
    '/logout',
    handler: logoutHandler,
  );
}

var onBoardingPage1Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/onboarding_page1');
      return OnBoardingPage1();
    }
  },
);

var profileHandler = Handler(handlerFunc: (context, parameters) {
  if (SharedPrefs().getEmail() == '' ||
      SharedPrefs().getUserName() == '' ||
      SharedPrefs().getPassword() == '') {
    return LogIn();
  } else {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/profile');
    return Profile();
  }
});

var settingsHandler = Handler(handlerFunc: (context, parameters) {
  // if (SharedPrefs().getEmail() == '' ||
  //     SharedPrefs().getUserName() == '' ||
  //     SharedPrefs().getPassword() == '') {
  //   return LogIn();
  // } else {
  //   // Update the current page in the shared prefs
  //   SharedPrefs().setCurrentPage('/settings');
  //   return settings();
  // }
  // Update the current page in the shared prefs
  SharedPrefs().setCurrentPage('/settings');
  return settings();
});

var onBoardingPage2Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/onboarding_page2');
      return OnBoardingPage2();
    }
  },
);

var onBoardingPage3Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/onboarding_page3');
      return OnBoardingPage3();
    }
  },
);

var onBoardingPage4Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/onboarding_page4');
      return OnBoardingPage4();
    }
  },
);

var signUpHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/signup');
    return SignUp();
  },
);

var logInHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/login');
    return LogIn();
  },
);

var globalChallengeHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/global_challenge');
      return globalChallenge();
    }
  },
);

var addFriendHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/add_friend');
      return addFriend();
    }
  },
);

var forgotPasswordHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/forgot_password');
    return ForgotPassword();
  },
);

var signupErrorMessageHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/signup_error_message');
      return SignupErrorMessage(pageName: 'log in');
    }
  },
);

var logoutHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/logout');
      return LogoutPage();
    }
  },
);
