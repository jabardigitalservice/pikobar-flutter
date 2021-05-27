import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckDistributionBloc.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';
import 'package:pikobar_flutter/screens/checkDistribution/CheckDistributionDetailScreen.dart';

class CheckDistributionOtherScrenn extends StatefulWidget {
  @override
  _CheckDistributionOtherScrennState createState() =>
      _CheckDistributionOtherScrennState();
}

class _CheckDistributionOtherScrennState
    extends State<CheckDistributionOtherScrenn> {
  ScrollController _scrollController;
  final _cityIdController = TextEditingController();
  final _subCityIdController = TextEditingController();
  List<dynamic> listCity, listSubCity;
  List<dynamic> listCityFiltered, listSubCityFiltered;
  String cityKeyword, subCityKeyword, cityId, subCityId;
  bool showListCity = false;
  bool showListSubCity = false;
  CheckDistributionBloc _checkdistributionBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.13 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckDistributionBloc>(
      create: (context) => _checkdistributionBloc = CheckDistributionBloc(
          checkDistributionRepository: CheckDistributionRepository()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar.animatedAppBar(
            title: Dictionary.otherLocation, showTitle: _showTitle),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            BlocBuilder<CheckDistributionBloc, CheckDistributionState>(
                builder: (BuildContext context, CheckDistributionState state) {
          final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
          return showFab
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.contentPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundedButton(
                          title: state is CheckDistributionLoadingIsOther
                              ? Dictionary.loading
                              : Dictionary.checkLocationSpread,
                          borderRadius: BorderRadius.circular(8),
                          elevation: 0.0,
                          color: ColorBase.green,
                          textStyle: TextStyle(
                              fontFamily: FontsFamily.roboto,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                          onPressed: state is CheckDistributionLoadingIsOther ||
                                  subCityId == null ||
                                  cityId == null
                              ? null
                              : () {
                                  _checkdistributionBloc.add(
                                      LoadCheckDistribution(
                                          isOther: true,
                                          cityId: cityId.replaceAll('.', ''),
                                          subCityId: subCityId));
                                }),
                    ],
                  ),
                )
              : Container();
        }),
        body: BlocListener<CheckDistributionBloc, CheckDistributionState>(
          listener: (context, state) {
            // Show dialog error message
            // When check distribution failed to load
            if (state is CheckDistributionFailure) {
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
              // Move to detail screen
              // When check distribution successfully loaded
            } else if (state is CheckDistributionLoaded) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckDistributionDetail(
                          state: state,
                        )),
              );
            } else {
              Scaffold.of(context).hideCurrentSnackBar();
            }
          },
          child: SingleChildScrollView(
              controller: _scrollController, child: _buildContent()),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
            child: AnimatedOpacity(
              opacity: _showTitle ? 0 : 1,
              duration: Duration(milliseconds: 250),
              child: Text(
                Dictionary.otherLocation,
                style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Pilih lokasi sesuai dengan yang ingin Anda cari di bawah ini',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: FontsFamily.roboto,
                      height: 1.5,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 40,
                ),
                _buildSearchDropdownField(
                    title: 'Kota/Kabupaten',
                    hintText: Dictionary.cityPlaceholder,
                    controller: _cityIdController,
                    isEdit: true,
                    onTap: () {
                      setState(() {
                        showListCity = true;
                      });
                    },
                    onChanged: (String newQuery) {
                      setState(() {
                        cityKeyword = newQuery;
                      });
                    },
                    onFieldSubmitted: (String value) {
                      setState(() {
                        showListCity = false;
                      });
                    }),
                showListCity
                    ? SizedBox(
                        height: 15,
                      )
                    : Container(),
                showListCity
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(kAreas)
                            .orderBy('name')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) return Container();
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                              listCity = snapshot.data.docs.toList();
                              return _buildListCity();
                          }
                        })
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                _buildSearchDropdownField(
                    title: 'Kecamatan',
                    controller: _subCityIdController,
                    hintText: Dictionary.subCityPlaceholder,
                    isEdit: cityId == null ? false : true,
                    onTap: cityId == null
                        ? null
                        : () {
                            setState(() {
                              showListSubCity = true;
                            });
                          },
                    onChanged: (String newQuery) {
                      setState(() {
                        subCityKeyword = newQuery;
                      });
                    },
                    onFieldSubmitted: (String value) {
                      setState(() {
                        showListSubCity = false;
                      });
                    }),
                showListSubCity
                    ? SizedBox(
                        height: 15,
                      )
                    : Container(),
                showListSubCity
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(kSubAreas)
                            .orderBy('name')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) return Container();
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                              listSubCity = snapshot.data.docs.toList();
                              return _buildListSubCity();
                          }
                        })
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCity() {
    if (cityKeyword != null) {
      listCityFiltered = listCity
          .where((test) =>
              test['name'].toLowerCase().contains(cityKeyword.toLowerCase()))
          .toList();
    } else {
      listCityFiltered = listCity;
    }
    return Container(
      decoration: BoxDecoration(
          color: ColorBase.greyContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorBase.greyBorder, width: 1.5)),
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
          itemCount: listCityFiltered.length,
          itemBuilder: (BuildContext context, int i) {
            return InkWell(
              onTap: () {
                setState(() {
                  FocusScope.of(context).unfocus();
                  _cityIdController.text = listCityFiltered[i]['name'];
                  cityId = listCityFiltered[i]['code'];
                  _subCityIdController.text = '';
                  subCityId = null;
                  showListCity = false;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.grey[200], width: 1),
                )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    listCityFiltered[i]['name'],
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontFamily: FontsFamily.roboto,
                        fontSize: 14),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildListSubCity() {
    if (cityId != null) {
      listSubCityFiltered = listSubCity
          .where((test) =>
              test['code'].toLowerCase().contains(cityId.replaceAll('.', '')))
          .toList();
      if (subCityKeyword != null) {
        listSubCityFiltered = listSubCityFiltered
            .where((test) => test['name']
                .toLowerCase()
                .contains(subCityKeyword.toLowerCase()))
            .toList();
      }
    } else {
      listSubCityFiltered = listSubCity;
    }

    return Container(
      decoration: BoxDecoration(
          color: ColorBase.greyContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorBase.greyBorder, width: 1.5)),
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
          itemCount: listSubCityFiltered.length,
          itemBuilder: (BuildContext context, int i) {
            return InkWell(
              onTap: () {
                setState(() {
                  FocusScope.of(context).unfocus();
                  _subCityIdController.text = listSubCityFiltered[i]['name'];
                  subCityId = listSubCityFiltered[i]['code'];
                  showListSubCity = false;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.grey[200], width: 1),
                )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    listSubCityFiltered[i]['name'],
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontFamily: FontsFamily.roboto,
                        fontSize: 14),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildSearchDropdownField(
      {String title,
      TextEditingController controller,
      String hintText,
      validation,
      TextInputType textInputType,
      bool isEdit,
      ValueChanged<String> onChanged,
      Function onTap,
      Function onFieldSubmitted,
      int maxLines}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[800],
                fontFamily: FontsFamily.roboto,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: maxLines != null ? maxLines : 1,
            style: isEdit
                ? TextStyle(
                    color: Colors.black,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14)
                : TextStyle(
                    color: ColorBase.disableText,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14),
            enabled: isEdit,
            validator: validation,
            textCapitalization: TextCapitalization.words,
            controller: controller,
            decoration: InputDecoration(
                fillColor: ColorBase.greyContainer,
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[800],
                  size: 30,
                ),
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                    color: ColorBase.netralGrey,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5))),
            keyboardType:
                textInputType != null ? textInputType : TextInputType.text,
            onChanged: onChanged,
            onTap: onTap,
            onFieldSubmitted: onFieldSubmitted,
          )
        ],
      ),
    );
  }
}
