import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vocabvault/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class VocabularyRemoteDataSource {
  Future<Either<Failure, Map<String, dynamic>>> analyzeWord(String word);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  // อ่านค่า Gemini API key จากไฟล์ .env โดยใช้ flutter_dotenv
  // สร้างไฟล์ .env ที่ root ของโปรเจค และเพิ่มบรรทัด:
  // GEMINI_API_KEY=your_real_api_key_here
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  @override
  Future<Either<Failure, Map<String, dynamic>>> analyzeWord(String word) async {
    // ลองตามลำดับ: gemini-pro (stable), gemini-2.0-flash, gemini-1.5-pro
    // หากไม่พบ ให้ตรวจสอบได้ที่: https://ai.google.dev/models
    final modelName = dotenv.env['GEMINI_MODEL_NAME'] ?? 'gemini-pro';
    
    try {
      if (_apiKey.isEmpty) {
        return const Left(GeminiFailure(
            message: 'กรุณาใส่ Gemini API Key ในไฟล์ .env (ตัวแปร GEMINI_API_KEY)'));
      }

      final model = GenerativeModel(
        model: modelName,
        apiKey: _apiKey,
      );

      final prompt = '''
      Analyze the English word "$word". 
      Return the result strictly in JSON format with the following keys:
      "word": the word itself,
      "pronunciation": phonetics (e.g., /həˈləʊ/),
      "meaning": Thai translation,
      "contextMeaning": short explanation in Thai,
      "exampleSentences": a list of 2 English sentences using the word,
      "category": one of these: noun, verb, adjective, adverb, preposition, conjunction, pronoun, determiner, other.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      final text = response.text;
      if (text == null) return const Left(GeminiFailure(message: 'No response from AI'));

      // ทำความสะอาดข้อความ JSON ที่อาจมี Markdown ติดมา
      final cleanJson = text.replaceAll('```json', '').replaceAll('```', '').trim();
      final Map<String, dynamic> data = jsonDecode(cleanJson);
      
      return Right(data);
    } catch (e) {
      final errorMsg = e.toString();
      // ตรวจสอบว่าเป็น error "model not found"
      if (errorMsg.contains('not found') || errorMsg.contains('not supported')) {
        return Left(GeminiFailure(
            message: 'Model "$modelName" ไม่พบหรือไม่รองรับ\n'
                'โปรดตั้งค่า GEMINI_MODEL_NAME ใน .env ให้เป็นโมเดลที่รองรับ\n'
                'ตัวเลือก: gemini-pro, gemini-2.0-flash, gemini-1.5-pro\n'
                'ดูรายชื่อเต็มที่: https://ai.google.dev/models'));
      }
      // ตรวจสอบว่าเป็น error "quota exceeded"
      if (errorMsg.contains('quota') || errorMsg.contains('exceeded') || errorMsg.contains('limit')) {
        return Left(GeminiFailure(
            message: '🚫 ใช้ Gemini API เกินโควต้าฟรีแล้ว\n\n'
                '💡 วิธีแก้ไข:\n'
                '1. รอให้โควต้ารีเซ็ต (ประมาณ 1 ชั่วโมง)\n'
                '2. อัปเกรดเป็น Google AI Studio Pro\n'
                '3. หรือเปลี่ยนเป็นโมเดลที่มีโควต้ามากขึ้น\n\n'
                '🔗 ดูรายละเอียด: https://ai.google.dev/gemini-api/docs/rate-limits'));
      }
      return Left(GeminiFailure(message: errorMsg));
    }
  }
}
