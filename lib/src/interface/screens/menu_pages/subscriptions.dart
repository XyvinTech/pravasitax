import 'package:flutter/material.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Subscriptions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentPlanCard(),
              SizedBox(height: 20),
              _buildSubscriptionsLabel(),
              SizedBox(height: 16),
              _buildAnnualSubscriptionCard(),
              SizedBox(height: 16),
              _buildMonthlySubscriptionCard(),
              SizedBox(height: 20),
              _buildBenefitsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Current Plan',
            style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(height: 8),
          Text(
            'Free plan',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Upgrade to premium now to enjoy maximum benefits',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
            ElevatedButton(
            onPressed: () {},
            child: Text('Upgrade now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF9B406),
              foregroundColor: Colors.black,
              minimumSize: Size(150, 40), // Adjusted size
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              ),
            ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsLabel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'SUBSCRIPTIONS',
        style: TextStyle(
          color: Colors.green[800],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAnnualSubscriptionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Annual subscription plan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Our Annual Subscription Plan acts as a protective shield for your tax affairs. With our experts at the helm, rest assured that all your tax worries are in capable hands, eliminating the need to fret over individual service costs.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySubscriptionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Annual\nSubscription Plan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹19/mo',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Lorem ipsum dolor sit amet',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          Text(
            'Includes:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildBulletPoint('Prompt submission of Income Tax Return for FY 2023-24 and addressing any subsequent issues at the time of issue of refund by the Department.'),
          _buildBulletPoint('Submission of revised or updated returns as needed'),
          _buildBulletPoint('Unlimited free on-call consultation with Tax Senior; Two free on-call consultation with Tax Partner'),
          _buildBulletPoint('Assistance in responding to e-Campaign queries raised by the Income Tax Department'),
          _buildBulletPoint('PAN related services, including PAN correction and updation, PAN-Aadhaar linking'),
          _buildBulletPoint('Frequent monitoring of your Income Tax Portal for queries or notices from Tax department'),
          _buildBulletPoint('Access to regular awareness sessions on Income Tax'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: Text('SUBSCRIBE NOW'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF9B406),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              minimumSize: Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 16, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits of our plan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        _buildBenefitItem('One year validity from the date of subscription'),
        _buildBenefitItem('365-days access to our Tax Experts'),
        _buildBenefitItem('Priority support'),
        _buildBenefitItem('Discounted rates compared to individual service charges'),
        _buildBenefitItem('Option to onboard a family member along with your plan'),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.arrow_forward, size: 16, color: Color(0xFFF9B406)),
          SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }
}