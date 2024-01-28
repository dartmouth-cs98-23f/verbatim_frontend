import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';
import 'package:verbatim_frontend/gameObject.dart';
import 'package:verbatim_frontend/screens/addFriend.dart';
import 'package:verbatim_frontend/screens/createGroup.dart';
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
import '../screens/landingPage.dart';

class Application {
  static FluroRouter router = FluroRouter.appRouter;
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
    '/my_group/:param1/:param2',
    handler: myGroupHandler,
  );
}

var myGroupHandler = Handler(
  handlerFunc: (context, params) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      var groupName = Uri.decodeComponent(params['param1']?[0] ?? '');
      var addedUsernamesString =
          Uri.decodeComponent(params['param2']?[0] ?? '');
      var addedUsernames = addedUsernamesString.split(',');

      if (groupName.isNotEmpty && addedUsernames.isNotEmpty) {
        String myGroupUrl = '/my_group/$groupName/${addedUsernames.join(',')}';
        // SharedPrefs().setCurrentPage(myGroupUrl);
        SharedPrefs().setCurrentPage('/my_group');

        return myGroup(
          groupName: groupName,
          addedUsernames: addedUsernames,
        );
      } else {
        return globalChallenge();
      }
    }
  },
);


var landingPageHandler = Handler(
        handlerFunc:(context, parameters) {
      if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
        return LandingPage();
      } else {
        // Update the current page in the shared prefs
        SharedPrefs().setCurrentPage('/landingPage');
        return LandingPage();
      }
    }
);

var settingsHandler = Handler(
    handlerFunc:(context, parameters) {
      if (SharedPrefs().getEmail() == '' || SharedPrefs().getUserName() == '' || SharedPrefs().getPassword() == '') {
        return LogIn();
      } else {
        // Update the current page in the shared prefs
        SharedPrefs().setCurrentPage('/settings');
        return settings();
      }

Handler onBoardingPage1Handler = Handler(
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

Handler signUpHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/signup');
    //TODO: check for this

    return SignUp(data: GameObject('','','',''));
  },
);

Handler logInHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/login');
    return LogIn();
  },
);

Handler globalChallengeHandler = Handler(
  handlerFunc: (context, parameters) {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/global_challenge');
      return globalChallenge();
);

Handler addFriendHandler = Handler(
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

Handler createGroupHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/create_group');
      return createGroup();
    }
  },
);

Handler forgotPasswordHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/forgot_password');
    return ForgotPassword();
  },
);

Handler signupErrorMessageHandler = Handler(
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

Handler logoutHandler = Handler(
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

 


/*
var myGroupHandler = Handler(
  handlerFunc: (BuildContext context, params) {
    print('Handling myGroup route');
    String? groupName = params['groupName']?.first;
    List<String>? addedUsernames = params['addedUsernames']?.cast<String>();
    print('Arguments: GroupName: $groupName, AddedUsernames: $addedUsernames');

    print('Parameters: $params');

    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/my_group');

      print(
          'Arguments: GroupName: $groupName, AddedUsernames: $addedUsernames');

      if (groupName != null && addedUsernames != null) {
        return myGroup(groupName: groupName, addedUsernames: addedUsernames);
      } else {
        print('Failed to find arguments');
        return globalChallenge();
      }
    }
  },
);
*/

