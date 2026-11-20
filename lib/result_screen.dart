import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double bmi;
  final String bmiStatus;
  final double hba1c;
  final double glucose;
  final double systolic;
  final double diastolic;
  final double cholesterol;
  final double hdl;
  final String overallRisk;
  final Color riskColor;
  final List<String> recommendations;

  const ResultScreen({
    super.key,
    required this.bmi,
    required this.bmiStatus,
    required this.hba1c,
    required this.glucose,
    required this.systolic,
    required this.diastolic,
    required this.cholesterol,
    required this.hdl,
    required this.overallRisk,
    required this.riskColor,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقرير الفحص الصحي والتقييم'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة التقييم العام ومستوى الخطر
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: riskColor.withValues(alpha: 0.12),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      riskColor == Colors.green
                          ? Icons.check_circle_outline
                          : (riskColor == Colors.orange ? Icons.warning_amber_rounded : Icons.error_outline),
                      size: 56,
                      color: riskColor,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'مستوى المخاطر الصحية الإجمالي',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      overallRisk,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: riskColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // مؤشر كتلة الجسم (BMI)
            _buildMetricCard(
              title: 'مؤشر كتلة الجسم (BMI)',
              value: '${bmi.toStringAsFixed(1)} kg/m²',
              status: bmiStatus,
              icon: Icons.accessibility_new,
              accentColor: Colors.blueAccent,
            ),
            const SizedBox(height: 12),

            // السكر التراكمي وسكر الدم الصائم
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bloodtype, color: Colors.redAccent),
                        SizedBox(width: 8),
                        Text(
                          'فحوصات سكر الدم',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('السكر التراكمي (HbA1c):', style: TextStyle(color: Colors.grey[700])),
                        Text(
                          hba1c > 0 ? '$hba1c %' : 'غير مسجل',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('سكر الدم الصائم (FPG):', style: TextStyle(color: Colors.grey[700])),
                        Text(
                          glucose > 0 ? '$glucose mg/dL' : 'غير مسجل',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ضغط الدم والدهون
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.pinkAccent),
                        SizedBox(width: 8),
                        Text(
                          'ضغط الدم ومؤشرات الدهون',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ضغط الدم (الانقباضي/الانبساطي):', style: TextStyle(color: Colors.grey[700])),
                        Text(
                          systolic > 0 ? '${systolic.toInt()} / ${diastolic.toInt()} mmHg' : 'غير مسجل',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الكوليسترول الكلي:', style: TextStyle(color: Colors.grey[700])),
                        Text(
                          cholesterol > 0 ? '$cholesterol mg/dL' : 'غير مسجل',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الكوليسترول النافع (HDL):', style: TextStyle(color: Colors.grey[700])),
                        Text(
                          hdl > 0 ? '$hdl mg/dL' : 'غير مسجل',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // التوصيات والإرشادات
            if (recommendations.isNotEmpty) ...[
              const Text(
                'التوصيات والإرشادات الطبية المخصصة:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...recommendations.map((rec) => Card(
                    color: Colors.teal.shade50,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_right, color: Colors.teal),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              rec,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('إجراء فحص جديد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String status,
    required IconData icon,
    required Color accentColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: accentColor.withValues(alpha: 0.15),
              child: Icon(icon, color: accentColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
