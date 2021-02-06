import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigScreen extends StatefulWidget {
  RemoteConfigScreen({Key key}) : super(key: key);

  @override
  _RemoteConfigScreenState createState() => _RemoteConfigScreenState();
}

class _RemoteConfigScreenState extends State<RemoteConfigScreen> {
  String user, job, versionPointed;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final remoteConfig = await RemoteConfig.instance;
      final defaults = <String, dynamic>{
        'user': 'Haritha Madhushanka',
        'job': 'Trainee Software Engineer',
        'version_pointed': 'Default Build from App'
      };

      setState(() {
        user = defaults['user'];
        job = defaults['job'];
        versionPointed = defaults['version_pointed'];
      });

      await remoteConfig.fetch(expiration: const Duration(minutes: 2));
      await remoteConfig.setDefaults(defaults);
      await remoteConfig.activateFetched();
      setState(() {
        user = remoteConfig.getString('user');
        job = remoteConfig.getString('job');
        versionPointed = remoteConfig.getString('version_pointed');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Config Test'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                          'These two values are being\nretrieved from Remote Config',
                          style: TextStyle(fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: Icon(
                        Icons.arrow_circle_down_rounded,
                      ),
                    ),
                    Text('User: ${user}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text('Job: ${job}',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                    "This value is being retrieved\naccording to the app's version.\nIf the app version is 1.0.0 the app\nshows 'Alpha'.\n\nIf the app version is 1.0.1, the app\nshows 'Final'.\nYou can change the app version in\nthe pubsec.yaml file",
                    style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Icon(
                  Icons.arrow_circle_down_rounded,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('${versionPointed}',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
