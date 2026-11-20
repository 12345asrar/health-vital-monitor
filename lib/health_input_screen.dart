import 'package:flutter/material.dart';

import 'result_screen.dart';

class HealthInputScreen extends StatefulWidget {
  const HealthInputScreen({super.key});

  @override
  State<HealthInputScreen> createState() => _HealthInputScreenState();
}

class _HealthInputScreenState extends State<HealthInputScreen> {
  final _formKey = GlobalKey<FormState>();

  final _hba1cController = TextEditingController();
  final _glucoseController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _cholesterolController = TextEditingController();
  final _hdlController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void dispose() {
    _hba1cController.dispose();
    _glucoseController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _cholesterolController.dispose();
    _hdlController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateAndNavigate() {
    if (!_formKey.currentState!.validate()) return;

    final double hba1c = double.tryParse(_hba1cController.text) ?? 5.5;
    final double glucose = double.tryParse(_glucoseController.text) ?? 100.0;
    final double systolic = double.tryParse(_systolicController.text) ?? 120.0;
    final double diastolic = double.tryParse(_diastolicController.text) ?? 80.0;
    final double cholesterol =
        double.tryParse(_cholesterolController.text) ?? 180.0;
    final double hdl = double.tryParse(_hdlController.text) ?? 50.0;
    final double weight = double.tryParse(_weightController.text) ?? 65.0;
    final double heightCm = double.tryParse(_heightController.text) ?? 160.0;

    // حساب BMI
    final double heightM = heightCm / 100;
    final double bmi = (heightM > 0) ? (weight / (heightM * heightM)) : 22.0;

    String bmiStatus;
    if (bmi < 18.5) {
      bmiStatus = 'نقص في الوزن';
    } else if (bmi < 25) {
      bmiStatus = 'وزن طبيعي ومثالي';
    } else if (bmi < 30) {
      bmiStatus = 'زيادة في الوزن';
    } else {
      bmiStatus = 'سمنة';
    }

    // تقييم نقاط الخطر (Risk Scoring Logic)
    int riskPoints = 0;
    final List<String> recommendations = [];

    if (hba1c >= 6.5 || glucose >= 126) {
      riskPoints += 3;
      recommendations.add(
        'المؤشرات تشير لارتفاع سكر الدم، يجب مراجعة طبيب باطنية/غدد صماء.',
      );
    } else if (hba1c >= 5.7 || glucose >= 100) {
      riskPoints += 1;
      recommendations.add(
        'تقليل السكريات والنشويات للوقاية من الدخول في مرحلة السكري.',
      );
    }

    if (systolic >= 140 || diastolic >= 90) {
      riskPoints += 2;
      recommendations.add(
        'مراقبة ضغط الدم بانتظام وتقليل استهلاك الملح في الوجبات.',
      );
    } else if (systolic >= 130 || diastolic >= 85) {
      riskPoints += 1;
    }

    if (cholesterol >= 200 || hdl < 50) {
      riskPoints += 2;
      recommendations.add(
        'يُنصح بتقليل الدهون المشبعة وممارسة نشاط بدني منتظم لتحسين الكوليسترول.',
      );
    }

    if (bmi >= 25) {
      riskPoints += 1;
      recommendations.add(
        'اتباع حمية متوازنة لإنقاص الوزن والوصول لمؤشر كتلة جسم مثالي.',
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        'جميع المؤشرات ممتازة وضمن النطاق الطبيعي، حافظ على نمط حياتك الصحي.',
      );
    }

    String overallRisk;
    Color riskColor;

    if (riskPoints >= 4) {
      overallRisk = 'خطر مرتفع (تنبيه)';
      riskColor = Colors.red;
    } else if (riskPoints >= 2) {
      overallRisk = 'خطر متوسط (يُنصح بالمتابعة)';
      riskColor = Colors.orange;
    } else {
      overallRisk = 'خطر منخفض (مؤشرات جيدة)';
      riskColor = Colors.green;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          bmi: bmi,
          bmiStatus: bmiStatus,
          hba1c: hba1c,
          glucose: glucose,
          systolic: systolic,
          diastolic: diastolic,
          cholesterol: cholesterol,
          hdl: hdl,
          overallRisk: overallRisk,
          riskColor: riskColor,
          recommendations: recommendations,
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدخال البيانات والمؤشرات الحيوية'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField(
                  '(HbA1c %) السكر التراكمي',
                  _hba1cController,
                  'مثال: 5.7',
                ),
                _buildField(
                  '(mg/dL) سكر الدم الصائم/العشوائي',
                  _glucoseController,
                  'مثال: 96 أو 132',
                ),
                _buildField(
                  '(Systolic mmHg) الضغط الانقباضي',
                  _systolicController,
                  'مثال: 120',
                ),
                _buildField(
                  '(Diastolic mmHg) الضغط الانبساطي',
                  _diastolicController,
                  'مثال: 80',
                ),
                _buildField(
                  '(Total Cholesterol) الكوليسترول الكلي',
                  _cholesterolController,
                  'مثال: 148 أو 219',
                ),
                _buildField(
                  '(HDL mg/dL) الكوليسترول الجيد',
                  _hdlController,
                  'مثال: 47 أو 50',
                ),
                _buildField('الوزن (كجم)', _weightController, 'مثال: 65'),
                _buildField('الطول (سم)', _heightController, 'مثال: 160'),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _calculateAndNavigate,
                  child: const Text(
                    'إرسال للفحص والتحليل السريري',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
