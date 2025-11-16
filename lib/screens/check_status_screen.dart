import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

class CheckStatusScreen extends StatefulWidget {
  const CheckStatusScreen({super.key});

  @override
  State<CheckStatusScreen> createState() => _CheckStatusScreenState();
}

class _CheckStatusScreenState extends State<CheckStatusScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Map<String, dynamic>? _registrationData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRegistrationData();
  }

  Future<void> _loadRegistrationData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final doc = await _firestore.collection('registrations').doc(userId).get();
      if (mounted) {
        setState(() {
          if (doc.exists) {
            _registrationData = doc.data();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  double _getFormSubmittedProgress() {
    return _registrationData != null ? 1.0 : 0.0;
  }

  double _getDocumentVerificationProgress() {
    if (_registrationData == null) return 0.0;
    final status = _registrationData!['status'] as String?;
    return (status == 'accepted') ? 1.0 : 0.0;
  }

  double _getApprovalProgress() {
    if (_registrationData == null) return 0.0;
    final status = _registrationData!['status'] as String?;
    return (status == 'accepted') ? 1.0 : 0.0;
  }

  String _getStatusMessage() {
    if (_registrationData == null) {
      return 'Please submit your registration form first';
    }
    final status = _registrationData!['status'] as String?;
    if (status == 'accepted') {
      return 'Your application has been approved!';
    } else if (status == 'pending') {
      return 'Your application is under review';
    }
    return 'Status: ${status ?? 'Pending'}';
  }

  Color _getStatusColor() {
    if (_registrationData == null) return Colors.grey;
    final status = _registrationData!['status'] as String?;
    if (status == 'accepted') return AppTheme.accentColor;
    return AppTheme.warningColor;
  }

  Widget _buildModernProgressItem(
    String title,
    double percent,
    Color color,
    IconData icon,
    int delay,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.modernCardDecoration(
        borderRadius: 20,
        hasShadow: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.subheadingStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(percent * 100).toInt()}%',
                      style: AppTheme.bodyStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearPercentIndicator(
              lineHeight: 8.0,
              percent: percent,
              backgroundColor: Colors.grey[200],
              progressColor: color,
              barRadius: const Radius.circular(4),
              padding: EdgeInsets.zero,
              animation: true,
              animationDuration: 1000,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: delay.ms)
        .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: delay.ms);
  }

  String _getLastUpdated() {
    if (_registrationData == null) return 'N/A';
    final updatedAt = _registrationData!['updatedAt'];
    if (updatedAt == null) return 'N/A';
    try {
      final timestamp = updatedAt as Timestamp;
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Application Status',
          style: AppTheme.subheadingStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.white),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryColor.withOpacity(0.7),
                  Colors.white.withOpacity(0.95),
                ],
              ),
            ),
          ),
          SafeArea(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Status Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: AppTheme.modernCardDecoration(
                            borderRadius: 24,
                            hasShadow: true,
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _getStatusColor().withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _registrationData == null
                                      ? Icons.info_outline
                                      : _registrationData!['status'] == 'accepted'
                                          ? Icons.check_circle
                                          : Icons.pending,
                                  color: _getStatusColor(),
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _getStatusMessage(),
                                style: AppTheme.subheadingStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_registrationData != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Last updated: ${_getLastUpdated()}',
                                  style: AppTheme.bodyStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(delay: 100.ms, duration: 600.ms, curve: Curves.elasticOut),
                        
                        const SizedBox(height: 24),
                        
                        Text(
                          'Progress Overview',
                          style: AppTheme.headingStyle(fontSize: 24, color: Colors.black87),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 200.ms)
                            .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 200.ms),
                        
                        const SizedBox(height: 16),
                        
                        _buildModernProgressItem(
                          'Form Submission',
                          _getFormSubmittedProgress(),
                          AppTheme.accentColor,
                          Icons.check_circle,
                          300,
                        ),
                        
                        _buildModernProgressItem(
                          'Document Verification',
                          _getDocumentVerificationProgress(),
                          AppTheme.warningColor,
                          Icons.assignment_turned_in,
                          400,
                        ),
                        
                        _buildModernProgressItem(
                          'Approval',
                          _getApprovalProgress(),
                          AppTheme.primaryColor,
                          Icons.verified_user,
                          500,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
