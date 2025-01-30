import 'package:flutter/material.dart';

class TaxToolsPage extends StatefulWidget {
  @override
  _TaxToolsPageState createState() => _TaxToolsPageState();
}

class _TaxToolsPageState extends State<TaxToolsPage> {
  String selectedIncomeType = '';
  double income = 0.0;
  double tds = 0.0;
  bool showResults = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Tax Refund Estimator', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This tool gives an estimate of your probable NRI Tax Refund'),
            SizedBox(height: 16),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select income type',
                      ),
                      value: selectedIncomeType.isNotEmpty ? selectedIncomeType : null,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedIncomeType = newValue!;
                        });
                      },
                      items: <String>['Rental income', 'Share trading']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text('Add income', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixText: 'INR ',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          income = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text('TDS', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixText: 'INR ',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          tds = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.add, color: Color(0xFF093152)),
                          label: Text('ADD', style: TextStyle(color: Color(0xFF093152))),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(color: Color(0xFF093152)),
                            minimumSize: Size(183, 36),
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: Icon(Icons.delete, color: Color.fromARGB(255, 212, 40, 28)),
                          label: Text('DELETE', style: TextStyle(color: Color(0xFF86221B))),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(color: Color(0xFF86221B)),
                            minimumSize: Size(183, 36),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildResultRow('Total income', '₹ ${income.toStringAsFixed(2)}'),
            SizedBox(height: 5),
            _buildResultRow('Total Taxable income', '₹ ${(income * 0.8).toStringAsFixed(2)}'),
            SizedBox(height: 5),
            _buildResultRow('TDS Collected', '₹ ${tds.toStringAsFixed(2)}', textColor: const Color.fromARGB(255, 194, 53, 43)),
            SizedBox(height: 5),
            _buildResultRow('Actual Tax', '₹ ${(income * 0.05).toStringAsFixed(2)}'),
            Divider(color: Colors.grey),
            _buildResultRow('Total refund', '₹ ${(tds - income * 0.05).toStringAsFixed(2)}', textColor: const Color.fromARGB(255, 65, 149, 67)),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 17, color: Colors.black),
                children: [
                  TextSpan(text: 'Please read '),
                  TextSpan(
                    text: 'Disclaimer',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                  TextSpan(text: ' before proceeding'),
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Claim Refund'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF9B406),
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  _showModalBottomSheet(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.white, // Changed to Colors.white
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Color(0xFF4CAF50), size: 40),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for your booking',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(height: 8),
              Text(
                'A certified counselor will contact you soon!',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey.shade300),
              _buildFeatureSection('Hassle free warranty', 'Lorem ipsum dolor sit amet consectetur. Diam orci pretium sed volutpat elit. Vulputate in amet ac pulvinar.'),
              Divider(color: Colors.grey.shade300),
              _buildFeatureSection('Online consultation', 'Lorem ipsum dolor sit amet consectetur. Diam orci pretium sed volutpat elit. Vulputate in amet ac pulvinar.'),
              Divider(color: Colors.grey.shade300),
              _buildFeatureSection('Dedicated support', 'Lorem ipsum dolor sit amet consectetur. Diam orci pretium sed volutpat elit. Vulputate in amet ac pulvinar.'),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Return home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF9B406),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }
}
