import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
 import 'package:flutter_sourcing_app/Models/branch_model.dart';
import 'package:provider/provider.dart';
 import 'collection.dart';
import 'Models/borrower_list_model.dart';
import 'Models/group_model.dart';
import 'api_service.dart';
import 'application_forms.dart';
import 'brrower_list_item.dart';
import 'first_esign.dart';
import 'global_class.dart';
import 'house_visit_form.dart';


class BorrowerList extends StatefulWidget {
  final BranchDataModel BranchData;
  final GroupDataModel GroupData;
  final String page;

  BorrowerList({
    required this.BranchData,
    required this.GroupData,
    required this.page,
  });

  @override
  _BorrowerListState createState() => _BorrowerListState();
}

class _BorrowerListState extends State<BorrowerList> {
  List<BorrowerListDataModel> _borrowerItems = [];


  @override
  void initState() {
    super.initState();
   // if(widget.page =="E SIGN"){
      _fetchBorrowerList(1);
   // }else{
   //   _fetchBorrowerList(0);
 //   }
  }

  Future<void> _fetchBorrowerList(int type) async {
    EasyLoading.show(status: 'Loading...',);

    final apiService = Provider.of<ApiService>(context, listen: false);

    await apiService.BorrowerList(
      GlobalClass.token,
      GlobalClass.dbName,

      widget.GroupData.groupCode,
     widget.BranchData.branchCode,
      GlobalClass.creator.toString(),
      type

    ).then((response) {
      if (response.statuscode == 200) {
        setState(() {
          if(widget.page=="APPLICATION FORM"){

          }
          _borrowerItems = response.data;

        });
        EasyLoading.dismiss();
print("object++12");
      } else {
        setState(() {

        });
        EasyLoading.dismiss();

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: /*_isLoading
          ? Center(child: CircularProgressIndicator())*/
          /*:*/ Column(
        children: [
          SizedBox(height: 50),
          Padding(padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: Center(
                      child: Icon(Icons.arrow_back_ios_sharp, size: 16),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Center(
                  child: Image.asset(
                    'assets/Images/logo_white.png', // Replace with your logo asset path
                    height: 40,
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.only(bottom: 0, top: 0, left: 10, right: 10),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              style: TextStyle(
                  fontFamily: "Poppins-Regular"
              ),
              decoration: InputDecoration(

                hintText: 'Search...',
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _borrowerItems.length,
              itemBuilder: (context, index) {
                final item = _borrowerItems[index];
                return BorrowerListItem(
                  name: item.fullName,
                  fiCode: item.fiCode.toString(),
                  //mobile: item.pPhone,
                  creator: item.creator,
                 // address: item.currentAddress,
                  pic:item.profilePic,
                  onTap: () {
                    switch (widget.page) {
                      case 'APPLICATION FORM':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplicationPage(
                              BranchData: widget.BranchData,
                              GroupData: widget.GroupData,
                              selectedData: item,
                            ),
                          ),
                        );
                        break;
                      case 'E SIGN':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstEsign(
                              BranchData: widget.BranchData,
                              GroupData: widget.GroupData,
                              selectedData: item,
                            ),
                          ),
                        );
                        break;
                        case 'HouseVisit':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouseVisitForm(
                              BranchData: widget.BranchData,
                              GroupData: widget.GroupData,
                              selectedData: item,
                            ),
                          ),
                        );
                        break;
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
