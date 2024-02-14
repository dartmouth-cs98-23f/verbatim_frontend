
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

var myGroupHandler = Handler(
  handlerFunc: (context, params) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return const LogIn();
    } else {
      SharedPrefs().setCurrentPage('/myGroup');
      String assetName = params["groupName"]![0];

      int? groupId = int.tryParse(params["groupId"]![0]);

      return myGroup(groupName: assetName, groupId: groupId);

      /*
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
        return const globalChallenge();
      }
      */
    }
  },
);

var landingPageHandler = Handler(handlerFunc: (context, parameters) {
  if (SharedPrefs().getEmail() == '' ||
      SharedPrefs().getUserName() == '' ||
      SharedPrefs().getPassword() == '') {
    return const LandingPage();
  } else {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/landingPage');
    return const LandingPage();
  }
});

var friendshipHandler = Handler(handlerFunc: (context, parameters) {
  if (SharedPrefs().getEmail() == '' ||
      SharedPrefs().getUserName() == '' ||
      SharedPrefs().getPassword() == '') {
    return const LandingPage();
  } else {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/friendship');
    String assetName = 'Frances';

    assetName = parameters["friendUsername"]![0];
    return friendship(friendUsername: assetName);
  }
});

var settingsHandler = Handler(handlerFunc: (context, parameters) {
  if (SharedPrefs().getEmail() == '' ||
      SharedPrefs().getUserName() == '' ||
      SharedPrefs().getPassword() == '') {
    return const LogIn();
  } else {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/settings');
    return const settings();
  }
});

//TODO: 
var guestGlobalHandler = Handler(handlerFunc: (context, parameters){
  print("Just cleaning up mu house");
  if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
          print("Ok lets see");
      return const guestGlobal();
  } else {
      // Update the current page in the shared prefs
        print("Whattt anomaly");
      SharedPrefs().setCurrentPage('/globalChallenge');
      return const globalChallenge();
}
});


//TODO: 
var guestSignUpHandler = Handler(handlerFunc: (context, parameters){
    SharedPrefs().setCurrentPage('/guest_signup');

    return const GuestSignUp();
});



Handler onBoardingPage1Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/onboarding_page1');
      return const OnBoardingPage1();
    }
  },
);

var profileHandler = Handler(handlerFunc: (context, parameters) {
  if (SharedPrefs().getEmail() == '' ||
      SharedPrefs().getUserName() == '' ||
      SharedPrefs().getPassword() == '') {
    return const LogIn();
  } else {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/profile');
    return const Profile();
  }
});

var onBoardingPage2Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/onboarding_page2');
      return const OnBoardingPage2();
    }
  },
);

var onBoardingPage3Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/onboarding_page3');
      return const OnBoardingPage3();
    }
  },
);

var onBoardingPage4Handler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/onboarding_page4');
      return const OnBoardingPage4();
    }
  },
);

Handler signUpHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/signup');
    //TODO: check for this

    return const SignUp();
    //return SignUp(data: data);
  },
);

Handler logInHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/login');
    return const LogIn();
  },
);

Handler globalChallengeHandler = Handler(handlerFunc: (context, parameters) {
  // Update the current page in the shared prefs
  SharedPrefs().setCurrentPage('/global_challenge');
  return const globalChallenge();
});

Handler addFriendHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/add_friend');
      return const addFriend();
    }
  },
);

Handler createGroupHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/create_group');
      return const createGroup();
    }
  },
);

Handler forgotPasswordHandler = Handler(
  handlerFunc: (context, parameters) {
    // Update the current page in the shared prefs
    SharedPrefs().setCurrentPage('/forgot_password');
    return const ForgotPassword();
  },
);

Handler signupErrorMessageHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/signup_error_message');
      return const SignupErrorMessage(pageName: 'log in');
    }
  },
);

Handler logoutHandler = Handler(
  handlerFunc: (context, parameters) {
    if (SharedPrefs().getEmail() == '' ||
        SharedPrefs().getUserName() == '' ||
        SharedPrefs().getPassword() == '') {
      return const LogIn();
    } else {
      // Update the current page in the shared prefs
      SharedPrefs().setCurrentPage('/logout');
      return const LogoutPage();
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

