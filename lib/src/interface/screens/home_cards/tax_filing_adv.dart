// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaxFilingAdvPage(),
    );
  }
}

class TaxFilingAdvPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tax filing and Advisory', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Container(
              height: 200,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.image, color: Colors.grey, size: 40),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'File your taxes with us!',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Very easy and Intuitive way to do tax filing',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => IncomeSourcesPage()),
                            );
                          },
                          child: Text('Start your journey'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'OTHER SERVICES',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            // Service Cards Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 10,
                children: [
                  _ServiceCard(
                    icon: Icons.account_balance,
                    color: Colors.orange[100]!,
                    label: 'Individual Tax Advisory',
                  ),
                  _ServiceCard(
                    icon: Icons.emoji_people,
                    color: Colors.green[100]!,
                    label: 'Retirement Planning',
                  ),
                  _ServiceCard(
                    icon: Icons.credit_card,
                    color: Colors.blue[100]!,
                    label: 'PAN Application',
                  ),
                  _ServiceCard(
                    icon: Icons.edit,
                    color: Colors.green[100]!,
                    label: 'PAN Correction Services',
                  ),
                  _ServiceCard(
                    icon: Icons.family_restroom,
                    color: Colors.lightBlue[100]!,
                    label: 'Succession Planning',
                  ),
                  _ServiceCard(
                    icon: Icons.link,
                    color: Colors.purple[100]!,
                    label: 'PAN – Aadhaar Linking',
                  ),
                  _ServiceCard(
                    icon: Icons.phone,
                    color: Colors.grey[200]!,
                    label: 'On-Call Tax Consultation',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  _ServiceCard({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.black, size: 30),
        ),
        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}


class IncomeSourcesPage extends StatefulWidget {
  @override
  _IncomeSourcesPageState createState() => _IncomeSourcesPageState();
}

class _IncomeSourcesPageState extends State<IncomeSourcesPage> {
  List<bool> _selectedSources = List.filled(8, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Income Tax filing',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What are your income sources?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Select multiple if needed',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // List of Checkboxes in a Scrollable ListView
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return _buildIncomeSourceCheckbox(index);
                },
              ),
            ),

            const SizedBox(height: 24),

            // Bottom Row Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'BACK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondPage()), // Navigate to SecondPage
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9B406),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build each checkbox wrapped inside a bordered container
  Widget _buildIncomeSourceCheckbox(int index) {
    List<String> incomeSources = [
      'NIL income',
      'Rental income',
      'Share Trading income',
      'Professional/Business income',
      'Income from Firm/LLP',
      'Bank interest income',
      'Property Sale income',
      'Other source',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)), // Light grey border
        ),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading, // Align checkbox to the left
          title: Text(
            incomeSources[index],
            style: const TextStyle(fontSize: 16),
          ),
          value: _selectedSources[index],
          activeColor: Colors.black,
          onChanged: (bool? value) {
            setState(() {
              _selectedSources[index] = value ?? false;
            });
          },
        ),
      ),
    );
  }
}





class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // State to track the checkbox selection
  List<bool> _isSelected = [false, false]; // Two options for tracking

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Income Tax filing',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How many rental properties do you own?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select multiple if needed',
              style: TextStyle(
                color: Color.fromARGB(255, 160, 160, 160),
              ),
            ),
            const SizedBox(height: 16),

            // Checkbox Options
            _buildCheckboxOption('Upto 2', 0),
            const SizedBox(height: 8),
            _buildCheckboxOption('More than 2', 1),

            const Spacer(),

            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'BACK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ThirdPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9B406),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build each checkbox option with dynamic state management
  Widget _buildCheckboxOption(String title, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 183, 182, 182), // Light grey border
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading, // Checkbox on the left
        title: Text(title),
        value: _isSelected[index],
        activeColor: Colors.black,
        onChanged: (bool? value) {
          setState(() {
            _isSelected[index] = value ?? false;
          });
        },
      ),
    );
  }
}




class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  // State management for checkboxes
  List<bool> _isSelected = [false, false, false]; // Three options

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Income Tax filing',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How many platforms do you trade on?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select multiple if needed',
              style: TextStyle(color: Color(0xFF9E9E9E)), // Grey color
            ),
            const SizedBox(height: 16),

            // Checkbox Options
            _buildCheckboxOption('Only 1', 0),
            const SizedBox(height: 8),
            _buildCheckboxOption('Between 1-3', 1),
            const SizedBox(height: 8),
            _buildCheckboxOption('More than 3', 2),

            const Spacer(),

            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'BACK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FourthPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9B406),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each checkbox option with dynamic state handling
  Widget _buildCheckboxOption(String title, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB7B6B6)), // Light grey border
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading, // Checkbox on the left
        title: Text(title),
        value: _isSelected[index],
        activeColor: Colors.black,
        onChanged: (bool? value) {
          setState(() {
            _isSelected[index] = value ?? false;
          });
        },
      ),
    );
  }
}





class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  // Track selected options
  List<bool> isChecked = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income Tax filing', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'How many platforms do you trade on?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select multiple if needed',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // List of Checkboxes
            _buildCheckboxTile(0, 'Short term gains (equity)'),
            _buildCheckboxTile(1, 'Long term gains ( equity)'),
            _buildCheckboxTile(2, 'Intraday/ speculation trading'),
            _buildCheckboxTile(3, 'Futures & options (F&O)'),
            _buildCheckboxTile(4, 'Debt oriented mutual funds'),
            
            const Spacer(),

            // Bottom Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'BACK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
               ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FifthPage()), // Change to FifthPage()
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF9B406),
                    padding: EdgeInsets.symmetric(horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'NEXT',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24), // Add padding at the bottom
          ],
        ),
      ),
    );
  }

  // Helper to build each checkbox list item
  Widget _buildCheckboxTile(int index, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)), // Light grey border
        ),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(title, style: const TextStyle(fontSize: 16)),
          value: isChecked[index],
          activeColor: Colors.black,
          onChanged: (bool? value) {
            setState(() {
              isChecked[index] = value ?? false;
            });
          },
        ),
      ),
    );
  }
}







class FifthPage extends StatefulWidget {
  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  // Track selected options for checkboxes
  List<bool> isChecked = [false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Income Tax filing',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'How many transactions are there in Long term gains?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select multiple if needed',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Checkboxes with borders
            _buildCheckboxTile(0, 'Less than 20'),
            _buildCheckboxTile(1, 'More than 20'),

            const Spacer(),

            // Bottom button row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'BACK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SixthPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF9B406),
                    padding: EdgeInsets.symmetric(horizontal: 85, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'NEXT',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper method to build each checkbox list item with a border
  Widget _buildCheckboxTile(int index, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)), // Light grey border
        ),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(title, style: const TextStyle(fontSize: 16)),
          value: isChecked[index],
          activeColor: Colors.black,
          onChanged: (bool? value) {
            setState(() {
              isChecked[index] = value ?? false;
            });
          },
        ),
      ),
    );
  }
}










class SixthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Income Tax filing',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Great! Lets File online',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // List of features with custom hexagon check icons
            _buildFeatureTile('Encrypted Digital Security Platform'),
            _buildFeatureTile('Experience in Income Tax FEMA'),
            _buildFeatureTile('Ease of Use'),
            _buildFeatureTile('Exclusive Platform for NRIs'),

            const SizedBox(height: 24),

            // Price section with crossed-out original price and new price
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)), // Light grey border
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'INR 9500',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'INR 6,500/-',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tag icon section above the Pay Now button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_offer, color: Colors.green), // Tag icon
                const SizedBox(width: 8),
                const Text('Yay! You saved ₹100 on your order',
                    style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 16),

            // Pay Now button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF9B406),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 186, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Pay now',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Plan exclusions section
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFF5F5F5), // Light grey background
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Plan exclusions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Our Plans cover only services towards filing your Income Tax Return in India.',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The below services are outside the scope of this Plan:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- Valuations\n'
                    '- CA Certifications and Tax Audit.\n'
                    '- PAN application / application for changes in PAN details\n'
                    '- Written opinions on taxability\n'
                    '- Submission of response to Income Tax notices / queries\n'
                    '- Handling tax assessments\n'
                    '- Tax planning\n'
                    '-The above services may be availed separately based on discussions with your Tax Advisor.',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper method to build feature list item with a custom hexagon check icon
  Widget _buildFeatureTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          HexagonCheckmark(), // Use custom hexagon checkmark widget
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Custom widget for Hexagon Checkmark
class HexagonCheckmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HexagonClipper(),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.green[100], // Light green background
          border: Border.all(color: Colors.green, width: 3), // Green border
          shape: BoxShape.rectangle,
        ),
        child: const Center(
          child: Icon(Icons.check, color: Colors.green, size: 15),
        ),
      ),
    );
  }
}

// Hexagon clipper to create a hexagonal shape
class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(width * 0.5, 0); // Top center
    path.lineTo(width, height * 0.25); // Top-right corner
    path.lineTo(width, height * 0.75); // Bottom-right corner
    path.lineTo(width * 0.5, height); // Bottom center
    path.lineTo(0, height * 0.75); // Bottom-left corner
    path.lineTo(0, height * 0.25); // Top-left corner
    path.close(); // Close the path to form a hexagon

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}





// Payment Summary Screen





class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Income Tax filing',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coupon and offers section with custom circular icon
            Row(
              children: [
                _buildCircularIcon(Icons.percent_rounded, const Color(0xFF35774F)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Coupons and offers',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => _buildOfferModal(context),
                    );
                  },
                  child: const Text(
                    'View Offers',
                    style: TextStyle(color: Color(0xFF35774F), fontSize: 14),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1.0),

            // Order Confirmation section
            const SizedBox(height: 19),
            
            const Text(
              'Order Confirmation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 19),
            
            const Divider(thickness: 1.0),


            // Payment summary rows
            _buildSummaryRow('Tax Plan', '₹ 500', textColor: Colors.black),
            _buildSummaryRow('Tax & charges', '₹ 49', textColor: Colors.black),
           
            const Divider(thickness: 1.0),
            _buildSummaryRow(
              'Total',
              '₹ 449',
              isBold: true,
              textColor: Colors.black87,
            ),

            const SizedBox(height: 16),

            // Offer message box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.local_offer, color: Color(0xFF35774F), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Yay! You saved ₹100 on your order',
                      style: TextStyle(
                        color: Color(0xFF35774F),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pay Now button
            Center(
             child: ElevatedButton(
                    onPressed: () {
                      // Payment functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9B406),
                      padding: const EdgeInsets.symmetric(horizontal: 180, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Pay now',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  )

            ),
          ],
        ),
      ),
    );
  }

  // Helper to build the modal sheet content
  Widget _buildOfferModal(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Coupons and Offers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Coupon code input box
            Container(
            width: double.infinity,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Enter coupon code',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            ),
          const SizedBox(height: 24),

          // Offers list
          for (var i = 0; i < 5; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[300], // Placeholder color for image
                  margin: EdgeInsets.only(right: 8),
                  ),
                  Expanded(
                  child: Text(
                    '15% off on Kotak credit card\n15% off up to INR 250',
                    style: const TextStyle(fontSize: 14),
                  ),
                  ),
                  ElevatedButton(
                  onPressed: () {
                    // Apply offer functionality
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.black),
                  ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Proceed button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close modal on proceed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9B406),
              padding: const EdgeInsets.symmetric(
                  horizontal: 186, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Proceed',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build summary rows with optional bold and color styles
  Widget _buildSummaryRow(String title, String value,
      {bool isBold = false, Color textColor = Colors.black54}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build a circular icon widget to match the design
  Widget _buildCircularIcon(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.4),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}