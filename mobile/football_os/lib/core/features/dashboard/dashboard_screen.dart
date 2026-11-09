import 'package:flutter/material.dart';

import 'package:football_os/core/networking/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();

  String _status = 'Checking backend connection...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkBackend();
  }

  Future<void> _checkBackend() async {
    try {
      final result = await _apiService.checkHealth();

      if (!mounted) return;

      setState(() {
        _status = result['message'] as String;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _status = 'Backend connection failed: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101411),
      appBar: AppBar(
        title: const Text('FOOTBALL OS'),
        backgroundColor: const Color(0xFF101411),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sports_soccer,
                size: 90,
                color: Color(0xFFD4AF37),
              ),
              const SizedBox(height: 24),
              const Text(
                'BEYOND THE GAME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator(
                  color: Color(0xFFD4AF37),
                )
              else
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _checkBackend,
                child: const Text('Test connection again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}