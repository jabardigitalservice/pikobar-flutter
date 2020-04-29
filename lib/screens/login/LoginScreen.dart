import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/myAccount/OnboardLoginScreen.dart';

class LoginScreen extends StatefulWidget {
  final String title;

  LoginScreen({this.title});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationBloc _authenticationBloc;

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
              _scaffoldKey.currentState.hideCurrentSnackBar();
            } else if (state is AuthenticationLoading) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
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
            } else if (state is AuthenticationAuthenticated) {
              _scaffoldKey.currentState.hideCurrentSnackBar();
              Navigator.of(context).pop(true);
            } else {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: CustomAppBar.setTitleAppBar(widget.title != null ? widget.title : Dictionary.login),
            ),
            body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (
                  BuildContext context,
                  AuthenticationState state,
                  ) {
                  return OnBoardingLoginScreen(
                    authenticationBloc: _authenticationBloc,
                    positionBottom: 20.0,
                  );
              },
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }

}
