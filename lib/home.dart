import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_social_content_share/flutter_social_content_share.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLogin = false;
  Map _user = {};

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = (await FlutterSocialContentShare.platformVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

  }


  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {

      FacebookAuth.instance.webInitialize(
        appId: "4893566130701909",
        cookie: true,
        xfbml: true,
        version: "v12.0",
      );
    }
    initPlatformState();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login and share with Facebook!"),
      ),
      body: Container(
          child: _isLogin?
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Image.network(_user["picture"]["data"]["url"]),
                    SizedBox(height: 20,),
                    Text(_user["name"]),

                    SizedBox(height: 20,),

                    ElevatedButton(onPressed: () async{
                      await FacebookAuth.instance.logOut().then((value) {
                        setState(() {
                          _isLogin = false;
                        });
                      });

                    }, child: Text("Log out")),

                    SizedBox(height: 20,),

                    //Share to Facebook
                    ElevatedButton(
                        onPressed: () async{
                         await FlutterSocialContentShare.share(
                              type: ShareType.facebookWithoutImage,
                              url: "https://flutter.dev/",
                              quote: "Middle Test.");
                        },
                        child: Text("Share to Facebook")),
                  ],
                ),
              ):Center(child: ElevatedButton(
              onPressed: () async{

                final LoginResult result = await FacebookAuth.instance.login(
                    permissions: ['public_profile', 'email'],
                );
                if (result.status == LoginStatus.success) {
                  final requestData = await FacebookAuth.instance.getUserData(
                    fields: "name, picture"
                  );
                  setState(() {
                    _user = requestData;
                    _isLogin = true;
                  });
                  print(_user);
                } else {
                  print(result.status);
                  print(result.message);
                }
              },
              child: Text("Login with Facebook")))

      ),
    );
  }
}
