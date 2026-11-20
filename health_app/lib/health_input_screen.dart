import 'package:flutter/material.dart';

class HealthInputScreen extends StatefulWidget {
  const HealthInputScreen({super.key});

  @override
  State<HealthInputScreen> createState() => _HealthInputScreenState();
}

class _HealthInputScreenState extends State<HealthInputScreen> {
  final _formKey = GlobalKey<FormState>();

  // حقول الإدخال الطبية
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

  Widget _buildField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => (value == null || value.isEmpty) ? 'يرجى إدخال القيمة' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدخال البيانات والمؤشرات الحيوية'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildField('السكر التراكمي (HbA1c %)', _hba1cController, 'مثال: 5.7'),
              _buildField('سكر الدم الصائم (mg/dL)', _glucoseController, 'مثال: 110'),
              _buildField('الضغط الانقباضي (Systolic mmHg)', _systolicController, 'مثال: 120'),
              _buildField('الضغط الانبساطي (Diastolic mmHg)', _diastolicController, 'مثال: 80'),
              _buildField('الكوليسترول الكلي (Total Cholesterol)', _cholesterolController, 'مثال: 190'),
              _buildField('الكوليسترول الجيد (HDL mg/dL)', _hdlController, 'مثال: 50'),
              _buildField('الوزن (كجم)', _weightController, 'مثال: 70'),
              _buildField('الطول (سم)', _heightController, 'مثال: 170'),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري تحليل المؤشرات الحيوية...')),
                    );
                  }
                },
                child: const Text('إرسال للفحص والتحليل السريري', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
