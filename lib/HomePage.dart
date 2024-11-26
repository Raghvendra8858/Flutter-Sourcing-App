import 'package:flutter/material.dart';
import 'package:flutter_sourcing_app/GlobalClass.dart';
import 'package:provider/provider.dart';

import 'ApiService.dart';
import 'TargetCarGif.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentSliderValue = 2500; // Initial value in thousands
  int _displayValue = 0; // Display value for the text

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(GlobalClass.target==0){
      _showAlertDialog(context);
    }else{
      _displayValue = GlobalClass.target;
    }
  }
  Future<int?> _showAlertDialog(BuildContext context) async {
    _currentSliderValue = 2500; // Reset slider value to initial value

    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: Container(
                height: MediaQuery.of(context).size.height / 2.2,
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: AssetImage('assets/Images/curvedBackground.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Image.asset(
                        'assets/Images/paisa_logo.png',
                        height: 45,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Image.asset(
                        'assets/Images/rupees.png',
                        height: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Monthly',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF6D6D6D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Disbursement Target',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF6D6D6D),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Slider(
                        value: _currentSliderValue.toDouble(),
                        min: 0,
                        max: 10000, // Max value in thousands (10 million)
                        divisions: 10000, // Ensure divisions are set to the number of thousand increments
                        label: '${(_currentSliderValue * 1000).toStringAsFixed(0)}',
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value.toInt();
                          });
                        },
                        onChangeEnd: (value) async{
                          await _setTarget(context, value.toInt());
                          Navigator.of(context).pop(value.toInt());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Value: ${(_currentSliderValue * 1000).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6D6D6D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD42D3F),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80), // Add some space at the top
            Container(
              height: MediaQuery.of(context).size.height / 2.2,
              width: MediaQuery.of(context).size.width-30,
              margin: EdgeInsets.symmetric(horizontal: 5.0), // 5dp margin on left and right
              padding: EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Color(0xFFD42D3F),
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: AssetImage('assets/Images/curvedBackground.png'), // replace with your background image
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  // Logo with top margin
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Image.asset(
                      'assets/Images/paisa_logo.png', // replace with your logo
                      height: 45,
                    ),
                  ),
                  // Rupees image with top margin
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Image.asset(
                      'assets/Images/rupees.png', // replace with your image asset
                      height: 30,
                    ),
                  ),
                  // Monthly text with top margin
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Monthly',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF6D6D6D), // dark grey color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Disbursement Target text with top margin
                  Text(
                      'Comission Target',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF6D6D6D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  // Container with margin from top and bottom
                  SizedBox(height: 10),
                  Text(
                      '₹ ${_displayValue.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD42D3F), // Button background color
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Rectangular corners
                      ),
                    ),
                    onPressed: () async {
                      final selectedValue = await _showAlertDialog(context); // Same functionality
                      if (selectedValue != null) {
                        setState(() {
                          _displayValue = selectedValue * 1000; // Convert to the actual value
                        });
                      }
                    },
                    child: Text(
                      'Reset target',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20), // Add space between sections
            // Bottom section with cards
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TargetCarGif()),
                );
              },
              child: Text(
                'TAP To KNOW YOUR PROGRESS >>>',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFC5C3C3),
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10), // Add space before the row
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Current Earning',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6D6D6D),
                                ),
                              ),

                              // Dynamic text with controller
                              TextField(
                                controller: TextEditingController(text: '\$8000'),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6D6D6D),
                                ),
                                textAlign: TextAlign.center,
                                readOnly: true, // Make it read-only
                                decoration: InputDecoration(
                                  border: InputBorder.none, // Remove underline
                                ),
                              ),
                              Text(
                                '10 People are earning more commission',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6D6D6D),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Card(
                      color: Colors.red[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Earn Maximum Comission',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'AB RUKNA NAHI',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),SizedBox(height: 10),
                              Text(
                                '-->>',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }

  Future<void> _setTarget(BuildContext context, int target) async {
    final api2 = Provider.of<ApiService>(context, listen: false);

    // Convert target to integer before sending
    int targetAmount = target.toInt()*1000;

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      "id": 0,
      "kO_ID": GlobalClass.id,
      "targetCommAmt": targetAmount, // Use integer here
      "month": "Sep",
      "year": 2024,
      // Include the required `targetObj` field if needed
      // "targetObj": someValue
    };

    /*try {
      final response = await api2.setTarget(GlobalClass.token, GlobalClass.dbName, requestBody);
      if (response.statusCode == 200) {
        print('PASS to Save Target');
      } else {
        print('Failed to Save Target');
      }
    } catch (e) {
      print('Error: $e');
    }*/
  }
}

