import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class CheckDistributionOtherScrenn extends StatefulWidget {
  @override
  _CheckDistributionOtherScrennState createState() =>
      _CheckDistributionOtherScrennState();
}

class _CheckDistributionOtherScrennState
    extends State<CheckDistributionOtherScrenn> {
  ScrollController _scrollController;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.animatedAppBar(
          title: Dictionary.otherLocation, showTitle: _showTitle),
      body: SingleChildScrollView(
          controller: _scrollController, child: _buildContent()),
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

                ///Menu Mode with overriden icon and dropdown buttons
                Row(
                  children: [
                    Expanded(
                      child: DropdownSearch<String>(
                        validator: (v) => v == null ? "required field" : null,
                        hint: "Select a country",
                        mode: Mode.MENU,
                        popupItemBuilder: _customPopupItemBuilderExample,
                        popupShape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: ColorBase.greyBorder, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        popupBackgroundColor: ColorBase.greyContainer,
                        showSearchBox: true,
                        dropdownSearchDecoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: ColorBase.greyBorder, width: 1.5)),
                          fillColor: ColorBase.greyContainer,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: ColorBase.greyBorder, width: 1.5)),
                        ),
                        showAsSuffixIcons: true,
                        dropdownButtonBuilder: (_) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[800],
                            size: 30,
                          ),
                        ),
                        showSelectedItem: true,
                        items: [
                          "Brazil",
                          "Italia (Disabled)",
                          "Tunisia",
                          'Canada'
                        ],
                        onChanged: print,
                        popupItemDisabled: (String s) => s.startsWith('I'),
                        selectedItem: "Tunisia",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, String item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.grey[200], width: 1),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          item,
          style: TextStyle(
              color: Colors.grey[800],
              fontFamily: FontsFamily.roboto,
              fontSize: 14),
        ),
      ),
    );
  }
}
