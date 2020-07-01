import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/provider/SpaceShipData.dart';
import 'package:Komeet/screens/Tutoriel/choose_profile_picture.dart';
import 'package:Komeet/screens/Tutoriel/choose_username.dart';
import 'package:Komeet/screens/Tutoriel/create_avatar_screen.dart';
import 'package:Komeet/screens/Tutoriel/first_mission_screen.dart';
import 'package:Komeet/screens/Tutoriel/tutorial_mission_screen.dart';
import 'package:Komeet/screens/main/add_step_screen.dart';
import 'package:Komeet/screens/main/community_mission_screen.dart';
import 'package:Komeet/screens/main/congratulation_screen.dart';
import 'package:Komeet/screens/main/get_premium_screen.dart';
import 'package:Komeet/screens/main/mission_request_screen.dart';
import 'package:Komeet/screens/main/send_invitation_screen.dart';
import 'package:Komeet/screens/main/space_pass_screen.dart';
import 'provider/feedData.dart';
import 'provider/profilBrainData.dart';
import 'provider/LoginRegisterData.dart';
import 'provider/SearchAutoData.dart';
import 'screens/Goals/category_screen.dart';
import 'screens/Goals/create_community_mission.dart';
import 'screens/main/Chat_Screen.dart';
import 'screens/main/calendar_screen.dart';
import 'screens/main/feed_screen.dart';
import 'screens/main/friend_list_screen.dart';
import 'screens/main/friend_profil_screen.dart';
import 'screens/main/friend_request_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/main/mission_chat_screen.dart';
import 'screens/main/mission_post_screen.dart';
import 'screens/main/menu_screen.dart';
import 'screens/main/user_list_chat.dart';
import 'screens/main/profil_screen.dart';
import 'screens/main/search_screen.dart';

import 'screens/Tutoriel/complete_profil_screen.dart';
import 'screens/Goals/create_goals.dart';
import 'screens/connexion/create_profile.dart';
import 'screens/loading_screen.dart';
import 'screens/connexion/login_screen.dart';
import 'screens/connexion/register_screen.dart';
import 'screens/Goals/set_goals_screens.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/connexion/HomeScreen.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
//  InAppPurchaseConnection.enablePendingPurchases();
  runApp(Phoenix(child: MyApp()));
}
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['comfort zone', 'adventure'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
);

InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  // TODO ANDROID BANNER ID
//  adUnitId: "ca-app-pub-1019750920692164/6379187192",
  // TODO IOS BANNER ID
  adUnitId: "ca-app-pub-1019750920692164/3879826995",
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(
      // TODO ANDROID APP ID
//      appId: 'ca-app-pub-1019750920692164~8062110007',
      // TODO IOS APP ID
    appId: "ca-app-pub-1019750920692164~4241954921",
    );
    myInterstitial.load();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: SearchAutoData(),
        ),
        ChangeNotifierProvider.value(
          value: LoginRegisterData(),
        ),
        ChangeNotifierProvider.value(
          value: ProfilBrainData(),
        ),
        ChangeNotifierProvider.value(value: MissionData()),
        ChangeNotifierProvider.value(value: FeedData()),
        ChangeNotifierProvider.value(
          value: SpaceShipBrainData(),
        ),
      ],
      child: MaterialApp(
        title: 'Komeet',
        theme: ThemeData(),
        initialRoute: LoadingScreen.id,
        routes: {
          LoadingScreen.id: (context) => LoadingScreen(),
          ChooseUsername.id: (context) => ChooseUsername(),
          ChooseProfilPicture.id: (context) => ChooseProfilPicture(),
          HomeScreen.id: (context) => HomeScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          CompleteScreen.id: (context) => CompleteScreen(),
          ChooseGoalScreen.id: (context) => ChooseGoalScreen(),
          LoadingProfile.id: (context) => LoadingProfile(),
          CreateGoals.id: (context) => CreateGoals(),
          MainScreen.id: (context) => MainScreen(),
          FeedScreen.id: (context) => FeedScreen(),
          SearchScreen.id: (context) => SearchScreen(),
          MenuScreen.id: (context) => MenuScreen(),
          CalendarScreen.id: (context) => CalendarScreen(),
          ProfilScreen.id: (context) => ProfilScreen(),
          CategoryScreen.id: (context) => CategoryScreen(),
          FriendsListChatScreen.id: (context) => FriendsListChatScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          MissionChatScreen.id: (context) => MissionChatScreen(),
          PostMissionScreen.id: (context) => PostMissionScreen(),
          FriendProfilScreen.id: (context) => FriendProfilScreen(),
          FriendRequestScreen.id: (context) => FriendRequestScreen(),
          CreateCommunityMission.id: (context) => CreateCommunityMission(),
          FriendsListScreen.id: (context) => FriendsListScreen(),
          CongratulationScreen.id: (context) => CongratulationScreen(),
          SendInvitationScreen.id: (context) => SendInvitationScreen(),
          MissionRequestScreen.id: (context) => MissionRequestScreen(),
          AddStepScreen.id: (context) => AddStepScreen(),
          CreateAvatarScreen.id: (context) => CreateAvatarScreen(),
          CommunityMissionScreen.id: (context) => CommunityMissionScreen(),
          SpacePassScreen.id: (context) => SpacePassScreen(),
          GetPremiumScreen.id: (context) => GetPremiumScreen(),
          FirstMissionScreen.id: (context) => FirstMissionScreen(),
          TutorialMissionScreen.id: (context) => TutorialMissionScreen(),
        },
      ),
    );
  }
}
