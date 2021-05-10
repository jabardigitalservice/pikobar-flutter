import 'package:collection/collection.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/emergencyNumber/Bloc.dart';
import 'package:pikobar_flutter/blocs/emergencyNumber/EmergencyNumberBloc.dart';
import 'package:pikobar_flutter/blocs/emergencyNumber/EmergencyNumberEvent.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/EmergencyNumber.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/IsolationCenterModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';
import 'package:pikobar_flutter/repositories/EmergencyNumberRepository.dart';
import 'package:pikobar_flutter/screens/phonebook/PhoneBookDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/Connection.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ListViewPhoneBooks extends StatefulWidget {
  String searchQuery;
  TextEditingController searchController = TextEditingController();
  ValueChanged<String> onChanged;

  ListViewPhoneBooks(
      {Key key, this.searchQuery, this.searchController, this.onChanged})
      : super(key: key);

  @override
  _ListViewPhoneBooksState createState() => _ListViewPhoneBooksState();
}

class _ListViewPhoneBooksState extends State<ListViewPhoneBooks> {
  bool isConnected = false;
  EmergencyNumberBloc _emergencyNumberBloc;
  ScrollController _scrollController;
  final EmergencyNumberRepository _emergencyNumberRepository =
      EmergencyNumberRepository();
  List<String> listItemTitleTab = [];

  @override
  void initState() {
    super.initState();
    checkConnection();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  checkConnection() async {
    isConnected = await Connection().checkConnection(kUrlGoogle);
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmergencyNumberBloc>(
            create: (context) => _emergencyNumberBloc = EmergencyNumberBloc(
                emergencyNumberRepository: _emergencyNumberRepository)),
        BlocProvider<RemoteConfigBloc>(
            create: (context) => RemoteConfigBloc()..add(RemoteConfigLoad())),
      ],
      child: BlocBuilder<EmergencyNumberBloc, EmergencyNumberState>(
        builder: (BuildContext context, EmergencyNumberState state) {
          return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
            builder: (BuildContext context, RemoteConfigState remoteState) {
              return remoteState is RemoteConfigLoaded
                  ? buildTab(remoteState.remoteConfig)
                  : Container();
            },
          );
        },
      ),
    );
  }

  Widget buildTab(RemoteConfig remoteConfig) {
    final List<dynamic> getLabel = RemoteConfigHelper.decode(
        remoteConfig: remoteConfig,
        firebaseConfig: FirebaseConfig.emergencyNumberTab,
        defaultValue: FirebaseConfig.emergencyNumberTabDefaultValue);

    final List<dynamic> getEmergencyCall = RemoteConfigHelper.decode(
        remoteConfig: remoteConfig,
        firebaseConfig: FirebaseConfig.emergencyCall,
        defaultValue: FirebaseConfig.emergencyCallDefaultValue);

    for (var i = 0; i < getLabel.length; i++) {
      listItemTitleTab.add(getLabel[i]['name']);
    }

    return CustomBubbleTab(
      isStickyHeader: true,
      titleHeader: Dictionary.phoneBookEmergency,
      scrollController: _scrollController,
      showTitle: _showTitle,
      searchBar: CustomAppBar.buildSearchField(widget.searchController,
          Dictionary.findEmergencyPhone, widget.onChanged),
      indicatorColor: ColorBase.green,
      labelColor: Colors.white,
      listItemTitleTab: listItemTitleTab,
      unselectedLabelColor: ColorBase.netralGrey,
      onTap: (index) {
        if (index == 0) {
          AnalyticsHelper.setLogEvent(getLabel[0]['analytics']);
        } else if (index == 1) {
          _emergencyNumberBloc.add(ReferralHospitalLoad());
          AnalyticsHelper.setLogEvent(getLabel[1]['analytics']);
        } else if (index == 2) {
          _emergencyNumberBloc.add(CallCenterLoad());
          AnalyticsHelper.setLogEvent(getLabel[2]['analytics']);
        } else if (index == 3) {
          _emergencyNumberBloc.add(GugusTugasWebLoad());
          AnalyticsHelper.setLogEvent(getLabel[3]['analytics']);
        } else if (index == 4) {
          _emergencyNumberBloc.add(IsolationCenterLoad());
          AnalyticsHelper.setLogEvent(getLabel[4]['analytics']);
        }
      },
      tabBarView: <Widget>[
        buildEmergencyNumberTab(getEmergencyCall),
        buildReferralHospitalTab(),
        buildCallCenterTab(),
        buildWebGugusTugasTab(),
        buildIsolationCenterTab()
      ],
      isExpand: true,
    );
  }

  /// Function to build Emergency Number Screen
  Widget buildEmergencyNumberTab(List<dynamic> tempGetEmergencyCall) {
    final List<EmergencyNumberModel> getEmergencyCall = tempGetEmergencyCall
        .map((itemWord) => EmergencyNumberModel.fromJson(itemWord))
        .toList();
    List<EmergencyNumberModel> getEmergencyCallFilter;
    if (widget.searchQuery != null) {
      /// Filtering data by search
      getEmergencyCallFilter = getEmergencyCall
          .where((test) => test.title
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()))
          .toList();
    } else {
      getEmergencyCallFilter = getEmergencyCall;
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverToBoxAdapter(
                child: getEmergencyCallFilter.isEmpty
                    ? isConnected
                        ? EmptyData(
                            message: Dictionary.emptyData,
                            desc: Dictionary.descEmptyData,
                            isFlare: false,
                            image: "${Environment.imageAssets}not_found.png",
                          )
                        : EmptyData(
                            message: Dictionary.errorConnection,
                            desc: '',
                            isFlare: false,
                            image: "${Environment.imageAssets}not_found.png",
                          )
                    : ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        children: <Widget>[
                          Column(
                            children:
                                getListEmergencyCall(getEmergencyCallFilter),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
              )
            ],
          );
        },
      ),
    );
  }

  /// Function to build Referral Hospital Screen
  Widget buildReferralHospitalTab() {
    return SafeArea(
      top: false,
      bottom: false,
      child: BlocBuilder<EmergencyNumberBloc, EmergencyNumberState>(
          builder: (BuildContext context, EmergencyNumberState state) {
        Map<dynamic, List<ReferralHospitalModel>> dataNomorDarurat;
        dynamic tempListCityName;

        if (state is ReferralHospitalLoaded) {
          final Map<dynamic, List<ReferralHospitalModel>> groupByCity =
              groupBy(state.referralHospitalList, (obj) => obj.city);

          /// Checking search field
          if (widget.searchQuery != null) {
            /// Filtering data by search
            final List<ReferralHospitalModel> tempList = state
                .referralHospitalList
                .where((test) => test.name
                    .toLowerCase()
                    .contains(widget.searchQuery.toLowerCase()))
                .toList();
            dataNomorDarurat = groupBy(tempList, (obj) => obj.city);
            tempListCityName = dataNomorDarurat.keys.toList();
          } else {
            dataNomorDarurat = groupByCity;
            tempListCityName = dataNomorDarurat.keys.toList();
          }
        }

        return CustomScrollView(
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  state is ReferralHospitalLoaded
                      ? dataNomorDarurat.isEmpty
                          ? isConnected
                              ? EmptyData(
                                  message: Dictionary.emptyData,
                                  desc: Dictionary.descEmptyData,
                                  isFlare: false,
                                  image:
                                      "${Environment.imageAssets}not_found.png",
                                )
                              : EmptyData(
                                  message: Dictionary.errorConnection,
                                  desc: '',
                                  isFlare: false,
                                  image:
                                      "${Environment.imageAssets}not_found.png",
                                )
                          : Column(
                              children: getListContent(
                                  listReferralHospitalModel: dataNomorDarurat,
                                  nameModel: Dictionary.referralHospitalModel,
                                  listCityName: tempListCityName),
                            )
                      : Column(
                          children: _buildLoading(),
                        )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Function to build Call Center Screen
  Widget buildCallCenterTab() {
    return SafeArea(
        top: false,
        bottom: false,
        child: BlocBuilder<EmergencyNumberBloc, EmergencyNumberState>(
          builder: (BuildContext context, EmergencyNumberState state) {
            List<CallCenterModel> dataCallCenter;

            if (state is CallCenterLoaded) {
              /// Checking search field
              if (widget.searchQuery != null) {
                /// Filtering data by search
                dataCallCenter = state.callCenterList
                    .where((test) => test.nameCity
                        .toLowerCase()
                        .contains(widget.searchQuery.toLowerCase()))
                    .toList();
              } else {
                dataCallCenter = state.callCenterList;
              }
            }

            return CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    children: <Widget>[
                      state is CallCenterLoaded
                          ? dataCallCenter.isEmpty
                              ? isConnected
                                  ? EmptyData(
                                      message: Dictionary.emptyData,
                                      desc: Dictionary.descEmptyData,
                                      isFlare: false,
                                      image:
                                          "${Environment.imageAssets}not_found.png",
                                    )
                                  : EmptyData(
                                      message: Dictionary.errorConnection,
                                      desc: '',
                                      isFlare: false,
                                      image:
                                          "${Environment.imageAssets}not_found.png",
                                    )
                              : Column(
                                  children: getListContent(
                                      callCenterModel: dataCallCenter,
                                      nameModel: Dictionary.callCenterModel,
                                      listCityName: null),
                                )
                          : Column(
                              children: _buildLoading(),
                            )
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }

  /// Function to build Web Gugus Tugas Screen
  Widget buildWebGugusTugasTab() {
    return SafeArea(
      top: false,
      bottom: false,
      child: BlocBuilder<EmergencyNumberBloc, EmergencyNumberState>(
          builder: (BuildContext context, EmergencyNumberState state) {
        List<GugusTugasWebModel> dataWebGugusTugas;

        if (state is GugusTugasWebLoaded) {
          /// Checking search field
          if (widget.searchQuery != null) {
            /// Filtering data by search
            dataWebGugusTugas = state.gugusTugasWebModel
                .where((test) => test.name
                    .toLowerCase()
                    .contains(widget.searchQuery.toLowerCase()))
                .toList();
          } else {
            dataWebGugusTugas = state.gugusTugasWebModel;
          }
        }

        return CustomScrollView(
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  state is GugusTugasWebLoaded
                      ? dataWebGugusTugas.isEmpty
                          ? isConnected
                              ? EmptyData(
                                  message: Dictionary.emptyData,
                                  desc: Dictionary.descEmptyData,
                                  isFlare: false,
                                  image:
                                      "${Environment.imageAssets}not_found.png",
                                )
                              : EmptyData(
                                  message: Dictionary.errorConnection,
                                  desc: '',
                                  isFlare: false,
                                  image:
                                      "${Environment.imageAssets}not_found.png",
                                )
                          : Column(
                              children: getListContent(
                                  gugusTugasWebModel: dataWebGugusTugas,
                                  nameModel: Dictionary.gugusTugasWebModel,
                                  listCityName: null),
                            )
                      : Column(
                          children: _buildLoading(),
                        )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Function to build Referral Isolation Center Screen
  Widget buildIsolationCenterTab() {
    return SafeArea(
      top: false,
      bottom: false,
      child: BlocBuilder<EmergencyNumberBloc, EmergencyNumberState>(
          builder: (BuildContext context, EmergencyNumberState state) {
        Map<dynamic, List<IsolationCenterModel>> dataIsolationCenter;
        dynamic tempListCityName;

        if (state is IsolationCenterLoaded) {
          final Map<dynamic, List<IsolationCenterModel>> groupByCity =
              groupBy(state.isolationCenterModel, (obj) => obj.city);

          /// Checking search field
          if (widget.searchQuery != null) {
            /// Filtering data by search
            final List<IsolationCenterModel> tempList = state
                .isolationCenterModel
                .where((test) => test.name
                    .toLowerCase()
                    .contains(widget.searchQuery.toLowerCase()))
                .toList();
            dataIsolationCenter = groupBy(tempList, (obj) => obj.city);
            tempListCityName = dataIsolationCenter.keys.toList();
          } else {
            dataIsolationCenter = groupByCity;
            tempListCityName = dataIsolationCenter.keys.toList();
          }
        }

        return CustomScrollView(
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  state is IsolationCenterLoaded
                      ? dataIsolationCenter.isEmpty
                          ? isConnected
                              ? EmptyData(
                                  message: Dictionary.emptyData,
                                  desc: Dictionary.descEmptyData,
                                  isFlare: false,
                                  image:
                                      "${Environment.imageAssets}not_found.png",
                                )
                              : EmptyData(
                                  message: Dictionary.errorConnection,
                                  desc: '',
                                  isFlare: false,
                                  image:
                                      "${Environment.imageAssets}not_found.png",
                                )
                          : Column(
                              children: getListContent(
                                  listIsolationCenterModel: dataIsolationCenter,
                                  nameModel: Dictionary.isolationCenterModel,
                                  listCityName: tempListCityName),
                            )
                      : Column(
                          children: _buildLoading(),
                        )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Build list of Content
  List<Widget> getListContent(
      {Map<dynamic, List<ReferralHospitalModel>> listReferralHospitalModel,
      Map<dynamic, List<IsolationCenterModel>> listIsolationCenterModel,
      List<GugusTugasWebModel> gugusTugasWebModel,
      List<CallCenterModel> callCenterModel,
      @required List<dynamic> listCityName,
      @required String nameModel}) {
    List<Widget> list = List();
    if (nameModel == Dictionary.gugusTugasWebModel) {
      listCityName = gugusTugasWebModel;
    } else if (nameModel == Dictionary.callCenterModel) {
      listCityName = callCenterModel;
    }
    for (int i = 0; i < listCityName.length; i++) {
      Column column = Column(
        children: <Widget>[
          Card(
              elevation: 0,
              margin: EdgeInsets.symmetric(
                  vertical: 12, horizontal: Dimens.contentPadding),
              child: itemCard(
                  referralHospitalModel: listReferralHospitalModel != null
                      ? listReferralHospitalModel[listCityName[i]]
                      : null,
                  isolationCenterModel: listIsolationCenterModel != null
                      ? listIsolationCenterModel[listCityName[i]]
                      : null,
                  callCenterModel:
                      callCenterModel != null ? callCenterModel[i] : null,
                  gugusTugasWebModel:
                      gugusTugasWebModel != null ? gugusTugasWebModel[i] : null,
                  cityName: nameModel == Dictionary.gugusTugasWebModel ||
                          nameModel == Dictionary.callCenterModel
                      ? null
                      : listCityName[i],
                  nameAnalytics: Analytics.tappedphoneBookEmergencyDetail,
                  nameModel: nameModel))
        ],
      );

      list.add(column);
    }
    return list;
  }

  Column itemCard(
      {List<ReferralHospitalModel> referralHospitalModel,
      List<IsolationCenterModel> isolationCenterModel,
      GugusTugasWebModel gugusTugasWebModel,
      CallCenterModel callCenterModel,
      @required String cityName,
      @required String nameAnalytics,
      @required String nameModel}) {
    if (nameModel == Dictionary.gugusTugasWebModel) {
      cityName = gugusTugasWebModel.name;
    } else if (nameModel == Dictionary.callCenterModel) {
      cityName = callCenterModel.nameCity;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhoneBookDetail(
                  documentReferralHospital: referralHospitalModel,
                  documentCallCenterModel: callCenterModel,
                  documentGugusTugasWebModel: gugusTugasWebModel,
                  isolationCenterModel: isolationCenterModel,
                  nameCity: cityName,
                  nameModel: nameModel,
                ),
              ),
            );

            AnalyticsHelper.setLogEvent(
                nameAnalytics, <String, dynamic>{'title': cityName});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: ColorBase.greyContainer,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          height: 25,
                          child: Image.asset(
                              nameModel == Dictionary.gugusTugasWebModel
                                  ? '${Environment.iconAssets}web_underline.png'
                                  : '${Environment.iconAssets}phone.png')),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  cityName == null
                      ? Skeleton(
                          height: 5,
                          width: MediaQuery.of(context).size.width / 4,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(cityName,
                              style: TextStyle(
                                  color: ColorBase.grey800,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontsFamily.roboto,
                                  fontSize: 14)),
                        ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build list of Emergency Number
  List<Widget> getListEmergencyCall(List<EmergencyNumberModel> snapshot) {
    List<Widget> list = List();

    ListTile _cardTile(EmergencyNumberModel document) {
      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
        leading: Container(
          decoration: BoxDecoration(
              color: ColorBase.greyContainer,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(height: 25, child: Image.network(document.image)),
          ),
        ),
        title: Text(
          document.title,
          style: TextStyle(
              color: ColorBase.grey800,
              fontWeight: FontWeight.bold,
              fontFamily: FontsFamily.roboto,
              fontSize: 14),
        ),
        onTap: () {
          if (document.action == 'call') {
            _launchURL(document.phoneNumber, 'number');

            AnalyticsHelper.setLogEvent(
                Analytics.tappedphoneBookEmergencyTelp, <String, dynamic>{
              'title': document.title,
              'telp': document.phoneNumber
            });
          } else if (document.action == 'whatsapp') {
            _launchURL(document.phoneNumber, 'whatsapp',
                message: document.message);

            AnalyticsHelper.setLogEvent(
                Analytics.tappedphoneBookEmergencyWa, <String, dynamic>{
              'title': document.title,
              'wa': document.phoneNumber
            });
          }
        },
      );
    }

    Widget _card(EmergencyNumberModel document) {
      return Card(elevation: 0, child: _cardTile(document));
    }

    for (int i = 0; i < snapshot.length; i++) {
      Column column = Column(
        children: <Widget>[
          _card(snapshot[i]),
        ],
      );

      list.add(column);
    }
    return list;
  }

  List<Widget> _buildLoading() {
    List<Widget> list = List();
    for (var i = 0; i < 8; i++) {
      Column column = Column(children: <Widget>[
        Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Skeleton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            height: 25,
                            child: Image.asset(
                                '${Environment.iconAssets}phone.png')),
                        const SizedBox(
                          width: 40,
                        ),
                        Skeleton(
                          height: 5,
                          width: MediaQuery.of(context).size.width / 4,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ]);
      list.add(column);
    }
    return list;
  }

  _launchURL(String launchUrl, tipeURL, {String message}) async {
    String url;
    if (tipeURL == 'number') {
      url = 'tel:${launchUrl.replaceAll(RegExp(r'(\s+)'), '')}';
    } else if (tipeURL == 'web') {
      url = launchUrl;
    } else {
      url = Uri.encodeFull(
          'whatsapp://send?phone=${launchUrl.replaceAll('+', '')}&text=$message');
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig
        .setDefaults(<String, dynamic>{FirebaseConfig.emergencyCall: []});

    try {
      await remoteConfig.fetch(expiration: Duration(minutes: 5));
      await remoteConfig.activateFetched();
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    return remoteConfig;
  }

  @override
  void dispose() {
    _emergencyNumberBloc.close();
    super.dispose();
  }
}
