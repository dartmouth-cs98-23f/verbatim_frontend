// Import required packages
import 'dart:html';
import 'package:fluro/fluro.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/screens/createGroup.dart';
import 'package:verbatim_frontend/screens/friendship.dart';
import 'package:verbatim_frontend/screens/guestGlobal.dart';
import 'package:verbatim_frontend/screens/guestSignUp.dart';
import 'package:verbatim_frontend/screens/landingPage.dart';
import 'package:verbatim_frontend/screens/myGroup.dart';
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
  static FluroRouter router = FluroRouter.appRouter;
}

// Function to define all pages to be routed to
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
    '/landingPage',
    handler: landingPageHandler,
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

  Application.router.define(
    '/create_group',
    handler: createGroupHandler,
  );

  Application.router.define(
    '/friendship',
    handler: friendshipHandler,
  );

  Application.router.define(
    '/myGroup',
    handler: myGroupHandler,
  );

  Application.router.define(
    '/guest_global',
    handler: guestGlobalHandler,
  );

  Application.router.define(
    '/guest_signup',
    handler: guestSignUpHandler,
  );
}

// Route to myGroup page when appropriate
var myGroupHandler = Handler(
  handlerFunc: (context, params) {
    if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
        (window.sessionStorage['Email'] ?? "").isEmpty ||
        (window.sessionStorage['Password'] ?? "").isEmpty) {
      return const LogIn();
    } else {
      SharedPrefs.setCurrentPage('/myGroup');
      String assetName = params["groupName"]![0];

      int? groupId = int.tryParse(params["groupId"]![0]);

      return myGroup(groupName: assetName, groupId: groupId);
    }
  },
);

// Route to the landing page when appropriate
var landingPageHandler = Handler(handlerFunc: (context, parameters) {
  // Update the current page in the shared prefs
  SharedPrefs.setCurrentPage('/landingPage');
  return const LandingPage();
});

// Route to the Friendship page when appropriate
var friendshipHandler = Handler(handlerFunc: (context, parameters) {
  if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
      (window.sessionStorage['Email'] ?? "").isEmpty ||
      (window.sessionStorage['Password'] ?? "").isEmpty) {
    SharedPrefs.setCurrentPage('/landingPage');
    return const LandingPage();
  } else {
    // Update the current page in the shared prefs
    SharedPrefs.setCurrentPage('/friendship');
    String assetName = 'Frances';

    assetName = parameters["friendUsername"]![0];
    return friendship(friendUsername: assetName);
  }
});

// Route to the settings page when appropriate
var settingsHandler = Handler(handlerFunc: (context, parameters) {
  if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
      (window.sessionStorage['Email'] ?? "").isEmpty ||
      (window.sessionStorage['Password'] ?? "").isEmpty) {
    SharedPrefs.setCurrentPage('/login');
    return const LogIn();
  } else {
    // Update the current page in the shared prefs
    SharedPrefs.setCurrentPage('/settings');
    return const settings();
  }
});

// Route to the globalChallenge page when appropriate
var guestGlobalHandler = Handler(handlerFunc: (context, parameters) {
  if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
      (window.sessionStorage['Email'] ?? "").isEmpty ||
      (window.sessionStorage['Password'] ?? "").isEmpty) {
    SharedPrefs.setCurrentPage('/guestGlobal');
    return const guestGlobal();
  } else {
    // Update the current page in the shared prefs

    SharedPrefs.setCurrentPage('/globalChallenge');
    return const globalChallenge();
  }
});

// Route to the GuestSignUp page when appropriate
var guestSignUpHandler = Handler(handlerFunc: (context, parameters) {
  SharedPrefs.setCurrentPage('/guest_signup');

  return const GuestSignUp();
});

// Route to the first onBoarding page when appropriate
Handler onBoardingPage1Handler = Handler(
  handlerFunc: (context, parameters) {
    if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
        (window.sessionStorage['Email'] ?? "").isEmpty ||
        (window.sessionStorage['Password'] ?? "").isEmpty) {
      SharedPrefs.setCurrentPage('/login');
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs.setCurrentPage('/onboarding_page1');
      return const OnBoardingPage1();
    }
  },
);

// Route to the profile page when appropriate
var profileHandler = Handler(handlerFunc: (context, parameters) {
  if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
      (window.sessionStorage['Email'] ?? "").isEmpty ||
      (window.sessionStorage['Password'] ?? "").isEmpty) {
    print("WTH:::${window.sessionStorage['UserName'] ?? ""}");
    SharedPrefs.setCurrentPage('/login');
    return const LogIn();
  } else {
    // Update the current page in the shared prefs
    SharedPrefs.setCurrentPage('/profile');
    return const Profile();
  }
});

// Route to the second onBoarding page when appropriate
var onBoardingPage2Handler = Handler(
  handlerFunc: (context, parameters) {
    if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
        (window.sessionStorage['Email'] ?? "").isEmpty ||
        (window.sessionStorage['Password'] ?? "").isEmpty) {
      SharedPrefs.setCurrentPage('/login');
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs.setCurrentPage('/onboarding_page2');
      return const OnBoardingPage2();
    }
  },
);

// Route to the third onboarding page when appropriate
var onBoardingPage3Handler = Handler(
  handlerFunc: (context, parameters) {
    if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
        (window.sessionStorage['Email'] ?? "").isEmpty ||
        (window.sessionStorage['Password'] ?? "").isEmpty) {
      SharedPrefs.setCurrentPage('/login');
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs.setCurrentPage('/onboarding_page3');
      return const OnBoardingPage3();
    }
  },
);

// Route to the fourth onboarding page when appropriate
var onBoardingPage4Handler = Handler(
  handlerFunc: (context, parameters) {
    if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
        (window.sessionStorage['Email'] ?? "").isEmpty ||
        (window.sessionStorage['Password'] ?? "").isEmpty) {
      SharedPrefs.setCurrentPage('/login');
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs.setCurrentPage('/onboarding_page4');
      return const OnBoardingPage4();
    }
  },
);

// Route to the signUp page when appropriate
Handler signUpHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs.setCurrentPage('/signup');
    //TODO: check for this

    return const SignUp();
    //return SignUp(data: data);
  },
);

// Route to the login page when appropriate
Handler logInHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs.setCurrentPage('/login');
    return const LogIn();
  },
);

// Route to the global challenge page when appropriate
Handler globalChallengeHandler = Handler(handlerFunc: (context, parameters) {
  // Update the current page in the shared prefs
  SharedPrefs.setCurrentPage('/global_challenge');
  return const globalChallenge();
});

// Route to the add friend page when appropriate
Handler addFriendHandler = Handler(
  handlerFunc: (context, parameters) {
    if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
        (window.sessionStorage['Email'] ?? "").isEmpty ||
        (window.sessionStorage['Password'] ?? "").isEmpty) {
      SharedPrefs.setCurrentPage('/login');
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs.setCurrentPage('/add_friend');
      return const addFriend();
    }
  },
);

// Route to the create group page when appropriate
Handler createGroupHandler = Handler(
  handlerFunc: (context, parameters) {
    if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
        (window.sessionStorage['Email'] ?? "").isEmpty ||
        (window.sessionStorage['Password'] ?? "").isEmpty) {
      SharedPrefs.setCurrentPage('/login');
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs.setCurrentPage('/create_group');
      return const createGroup();
    }
  },
);

// Route to the forgot password page when appropriate
Handler forgotPasswordHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs.setCurrentPage('/forgot_password');
    return const ForgotPassword();
  },
);

// Route to the error message page when appropriate
Handler signupErrorMessageHandler = Handler(
  handlerFunc: (context, parameters) {
    if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
        (window.sessionStorage['Email'] ?? "").isEmpty ||
        (window.sessionStorage['Password'] ?? "").isEmpty) {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs.setCurrentPage('/signup_error_message');
      return const SignupErrorMessage(pageName: 'log in');
    }
  },
);

// Route to the logout page when appropriate
Handler logoutHandler = Handler(
  handlerFunc: (context, parameters) {
    if ((window.sessionStorage['UserName'] ?? "").isEmpty ||
        (window.sessionStorage['Email'] ?? "").isEmpty ||
        (window.sessionStorage['Password'] ?? "").isEmpty) {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs.setCurrentPage('/logout');
      return const LogoutPage();
    }
  },
);
