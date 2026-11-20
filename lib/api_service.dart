import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  // يمكن تعديل الرابط لاحقاً بعنوان السيرفر الفعلي
  static const String baseUrl = 'http://10.0.2.2:8000'; 
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // حفظ التوكن محلياً بشكل آمن
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // جلب التوكن المحفوظ
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // إرسال القياسات والمؤشرات الحيوية لتحليل السكري والضغط
  Future<Map<String, dynamic>> sendHealthMetrics({
    required double hba1c,
    required double fastingGlucose,
    required double systolicBP,
    required double diastolicBP,
    required double cholesterol,
    required double hdl,
    required double weight,
    required double height,
  }) async {
    final url = Uri.parse('$baseUrl/api/predict-risk');
    final token = await getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'hba1c': hba1c,
        'fasting_glucose': fastingGlucose,
        'systolic_bp': systolicBP,
        'diastolic_bp': diastolicBP,
        'cholesterol': cholesterol,
        'hdl': hdl,
        'weight': weight,
        'height': height,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('فشل في إرسال البيانات: ${response.statusCode}');
    }
  }
}
