import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/area/cityListBloc/Bloc.dart';
import 'package:pikobar_flutter/blocs/area/subCityListBloc/Bloc.dart';
import 'package:pikobar_flutter/blocs/checkDistribution/CheckDistributionBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
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
  List<dynamic> cityList, subCityList = [];
  List<dynamic> cityListFiltered, subCityListFiltered = [];
  String cityKeyword, subCityKeyword, cityId, subCityId;
  bool showCityList = false;
  bool showSubCityList = false;
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<CheckDistributionBloc>(
            create: (context) => _checkdistributionBloc = CheckDistributionBloc(
                checkDistributionRepository: CheckDistributionRepository())),
        BlocProvider<CityListBloc>(
            create: (context) => CityListBloc()..add(CityListLoad())),
        BlocProvider<SubCityListBloc>(
            create: (context) => SubCityListBloc()..add(SubCityListLoad())),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar.animatedAppBar(
            title: Dictionary.otherLocation, showTitle: _showTitle),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            BlocBuilder<CheckDistributionBloc, CheckDistributionState>(
                builder: (BuildContext context, CheckDistributionState state) {
          final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0;
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
                          elevation: 0,
                          color: ColorBase.green,
                          textStyle: TextStyle(
                              fontFamily: FontsFamily.roboto,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                          onPressed: state is CheckDistributionLoadingIsOther ||
                                  subCityId == null ||
                                  cityId == null ||
                                  _cityIdController.text == '' ||
                                  _subCityIdController.text == ''
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
          listener: (BuildContext context, CheckDistributionState state) {
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
                  Dictionary.chooseOtherLocation,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: FontsFamily.roboto,
                      height: 1.5,
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 40,
                ),
                _buildCityListBloc(),
                const SizedBox(
                  height: 20,
                ),
                _buildSubCityListBloc(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityListBloc() {
    return BlocBuilder<CityListBloc, CityListState>(
      builder: (BuildContext context, CityListState cityState) {
        return Column(
          children: [
            _buildSearchDropdownField(
                title: Dictionary.city,
                hintText: cityState is CityListLoading
                    ? Dictionary.loading
                    : Dictionary.cityPlaceholder,
                controller: _cityIdController,
                isEdit: true,
                onTap: () {
                  setState(() {
                    showCityList = true;
                  });
                },
                onChanged: (String newQuery) {
                  setState(() {
                    cityKeyword = newQuery;
                    cityId = null;
                    showSubCityList = false;
                    _subCityIdController.text = '';
                  });
                },
                onFieldSubmitted: (String value) {
                  setState(() {
                    showCityList = false;
                  });
                }),
            showCityList
                ? const SizedBox(
                    height: 15,
                  )
                : Container(),
            showCityList ? _buildCityList(cityState) : Container(),
          ],
        );
      },
    );
  }

  Widget _buildCityList(CityListState cityState) {
    if (cityState is CityListLoaded) {
      cityList = cityState.cityList;
      if (cityKeyword != null) {
        cityListFiltered = cityList
            .where((test) =>
                test['name'].toLowerCase().contains(cityKeyword.toLowerCase()))
            .toList();
      } else {
        cityListFiltered = cityList;
      }
    }

    return Container(
      decoration: BoxDecoration(
          color: ColorBase.greyContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorBase.greyBorder, width: 1.5)),
      height: cityListFiltered.isEmpty
          ? MediaQuery.of(context).size.height * 0.1
          : MediaQuery.of(context).size.height * 0.3,
      child: cityListFiltered.isEmpty
          ? Center(
              child: Text(
                Dictionary.emptyDataArea,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14),
              ),
            )
          : ListView.builder(
              itemCount: cityListFiltered.length,
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      _cityIdController.text = cityListFiltered[i]['name'];
                      cityId = cityListFiltered[i]['code'];
                      _subCityIdController.text = '';
                      subCityId = null;
                      showCityList = false;
                      showSubCityList = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey[200], width: 1),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        cityListFiltered[i]['name'],
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

  Widget _buildSubCityListBloc() {
    return BlocBuilder<SubCityListBloc, SubCityListState>(
        builder: (BuildContext context, SubCityListState subCityState) {
      return Column(
        children: [
          _buildSearchDropdownField(
              title: Dictionary.districts,
              controller: _subCityIdController,
              hintText: subCityState is SubCityListLoading
                  ? Dictionary.loading
                  : Dictionary.subCityPlaceholder,
              isEdit: cityId == null ? false : true,
              onTap: cityId == null
                  ? null
                  : () {
                      setState(() {
                        showSubCityList = true;
                      });
                    },
              onChanged: (String newQuery) {
                setState(() {
                  subCityKeyword = newQuery;
                  subCityId = null;
                });
              },
              onFieldSubmitted: (String value) {
                setState(() {
                  showSubCityList = false;
                });
              }),
          showSubCityList
              ? const SizedBox(
                  height: 15,
                )
              : Container(),
          showSubCityList ? _buildSubCityList(subCityState) : Container(),
        ],
      );
    });
  }

  Widget _buildSubCityList(SubCityListState subCityState) {
    if (subCityState is SubCityListLoaded) {
      subCityList = subCityState.subcityList ?? [];
      if (cityId != null || cityId != '') {
        subCityListFiltered = subCityList
            .where((test) =>
                test['code'].toLowerCase().contains(cityId.replaceAll('.', '')))
            .toList();
        if (subCityKeyword != null) {
          subCityListFiltered = subCityListFiltered
              .where((test) => test['name']
                  .toLowerCase()
                  .contains(subCityKeyword.toLowerCase()))
              .toList();
        }
      } else {
        subCityListFiltered = subCityList;
      }
    }

    return Container(
      decoration: BoxDecoration(
          color: ColorBase.greyContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorBase.greyBorder, width: 1.5)),
      height: subCityListFiltered.isEmpty
          ? MediaQuery.of(context).size.height * 0.1
          : MediaQuery.of(context).size.height * 0.3,
      child: subCityListFiltered.isEmpty
          ? Center(
              child: Text(
                Dictionary.emptyDataArea,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14),
              ),
            )
          : ListView.builder(
              itemCount: subCityListFiltered.length,
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      _subCityIdController.text =
                          subCityListFiltered[i]['name'];
                      subCityId = subCityListFiltered[i]['code'];
                      showSubCityList = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey[200], width: 1),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        subCityListFiltered[i]['name'],
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
                fontSize: 12,
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
