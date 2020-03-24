import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/myAccount/LoginScreen.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationBloc _authenticationBloc;
  String _versionText = Dictionary.version;
  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _versionText = packageInfo.version != null
            ? packageInfo.version
            : Dictionary.version;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => _authenticationBloc =
            AuthenticationBloc(authRepository: _authRepository)
              ..add(AppStarted()),
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            print(state);

            if (state is AuthenticationFailure) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogTextOnly(
                        description: state.error.toString(),
                        buttonText: "OK",
                        onOkPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                      ));
              Scaffold.of(context).hideCurrentSnackBar();
            } else if (state is AuthenticationLoading) {
              Scaffold.of(context).showSnackBar(
                SnackBar(backgroundColor:Theme.of(context).primaryColor ,
                  content: Row(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text(Dictionary.loading),
                      )
                    ],
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
            } else {
              Scaffold.of(context).hideCurrentSnackBar();
            }
          },
          child: Scaffold(
              appBar: AppBar(
                title: Text(Dictionary.profile),
              ),
              body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (
                  BuildContext context,
                  AuthenticationState state,
                ) {
                  if (state is AuthenticationUnauthenticated||state is AuthenticationLoading) {
                    return LoginScreen(authenticationBloc: _authenticationBloc,);
                   
                  } else if (state is AuthenticationAuthenticated||state is AuthenticationLoading) {
                    return _buildContent(state);
                  } else {
                    return Container();
                  }
                },
              )),
        ));
  }

  Widget _buildContent(AuthenticationAuthenticated state) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Stack(
            children: <Widget>[
              Image.asset('${Environment.iconAssets}backgroundProfile.png'),
              Center(
                child: Container(
                  width: 98,
                  height: 98,
                  child: CircleAvatar(
                    minRadius: 90,
                    maxRadius: 150,
                    backgroundImage: state.record.photoUrlFull != null
                        ? NetworkImage(state.record.photoUrlFull)
                        : ExactAssetImage('${Environment.imageAssets}user.png'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            state.record.name,
            style: TextStyle(
                color: Color(0xff4F4F4F),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Text(state.record.email,
              style: TextStyle(
                color: Color(0xff27AE60),
                fontSize: 14,
              )),
          SizedBox(
            height: 20,
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          height: 20,
                          child: Image.asset(
                              '${Environment.iconAssets}versionLogo.png')),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        Dictionary.versionText,
                        style: TextStyle(color: Color(0xff4F4F4F)),
                      ),
                    ],
                  ),
                  Text(
                    _versionText + ' ' + Dictionary.betaText,
                    style: TextStyle(color: Color(0xff828282)),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color(0xffEB5757),
              onPressed: () {
                _authenticationBloc.add(LoggedOut());
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      Dictionary.textLogoutButton,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
              ),
            ),
          )
        ],
      ),
    ));
  }

    @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }
}
