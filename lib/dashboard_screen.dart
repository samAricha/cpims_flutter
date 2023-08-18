import 'package:flutter/material.dart';

import 'api_service.dart';


class DashboardScreen extends StatefulWidget {
  final String accessToken;

  const DashboardScreen({super.key, required this.accessToken});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> _dashboardData = {};

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    try {
      const apiUrl = 'https://dev.cpims.net/api/dashboard';

      final dashboardData = await ApiService.fetchDashboardData(apiUrl, widget.accessToken);

      setState(() {
        _dashboardData = dashboardData;
      });
    } catch (e) {
      print('Error fetching dashboard data: $e');
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              title: 'Organization Unit',
              value: "${_dashboardData['org_unit']}\n${_dashboardData['org_unit_id']}",
            ),
            SizedBox(height: 16.0),
            _buildCard(
              title: 'Number of Government Organizations',
              value: _dashboardData['government'].toString(),
            ),
            SizedBox(height: 16.0),
            _buildCard(
              title: 'Number of NGOs',
              value: _dashboardData['ngo'].toString(),
            ),
            SizedBox(height: 16.0),
            _buildCard(
              title: 'Number of Children',
              value: _dashboardData['children'].toString(),
            ),
            SizedBox(height: 16.0),
            _buildCard(
              title: 'Number of Caregivers',
              value: _dashboardData['caregivers'].toString(),
            ),
            SizedBox(height: 16.0),
            _buildCard(
              title: 'Case Records',
              value: _dashboardData['case_records'].toString(),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String value}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
