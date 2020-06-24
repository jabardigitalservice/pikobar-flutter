import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/importantinfo/importantInfoList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/screens/home/components/ImportantInfoScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class ImportantInfoListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteConfigBloc>(
            create: (context) => RemoteConfigBloc()..add(RemoteConfigLoad())),
        BlocProvider<ImportantInfoListBloc>(
        create: (context) => ImportantInfoListBloc())
      ],
      child: ImportantInfo(),
    );
  }
}


class ImportantInfo extends StatefulWidget {

  @override
  _ImportantInfoState createState() => _ImportantInfoState();
}

class _ImportantInfoState extends State<ImportantInfo> with SingleTickerProviderStateMixin {
  ImportantInfoListBloc _importantInfoListBloc;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.news);

    super.initState();
    _importantInfoListBloc = BlocProvider.of<ImportantInfoListBloc>(context);
    _importantInfoListBloc.add(ImportantInfoListLoad(Collections.importantInfor));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: Dictionary.importantInfo,
        ),
        body: ImportantInfoScreen()
    );
  }



  @override
  void dispose() {
    _importantInfoListBloc.close();
    super.dispose();
  }
}
