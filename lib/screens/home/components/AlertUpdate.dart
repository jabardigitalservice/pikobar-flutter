import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/utilities/checkVersion.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';

class AlertUpdate extends StatefulWidget {
  @override
  _AlertUpdateState createState() => _AlertUpdateState();
}

class _AlertUpdateState extends State<AlertUpdate> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoteConfigBloc, RemoteConfigState>(
      listener: (context, state) async {
        if (state is RemoteConfigLoaded) {
          await checkForceUpdate(context, state.remoteConfig);
        }
      },
      child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
        builder: (context, state) {
          return state is RemoteConfigLoaded
              ? _buildContent(state.remoteConfig)
              : Container();
        },
      ),
    );
  }

  _buildContent(RemoteConfig remoteConfig) {

    return FutureBuilder<bool>(
      future: checkVersion(remoteConfig),
      builder: (context, status) {
        if (status.hasData && status.data) {
          return Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.green[700], ColorBase.green],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(0.0, 0.5),
                    stops: [0.0, 1.0]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(Dictionary.updateAppAvailable,
                        style: TextStyle(color: Colors.white,
                          fontFamily: FontsFamily.sourceSansPro,)),
                  ),

                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
                      decoration: BoxDecoration(
                        color: ColorBase.yellow,
                        border: Border.all(
                            color: Colors.grey[300], width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Text(Dictionary.update, style: TextStyle(
                          color: Colors.white,
                          fontFamily: FontsFamily.sourceSansPro,
                          fontWeight: FontWeight.bold),),
                    ),
                    onTap: () {
                      launchExternal(remoteConfig.getString(
                          FirebaseConfig.storeUrl));
                    },
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
