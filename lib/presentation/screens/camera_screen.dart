import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:vocabvault/presentation/bloc/vocabulary_bloc.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  TextRecognizer? _textRecognizer;
  XFile? _image;
  Uint8List? _imageBytes;
  String _recognizedText = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _textRecognizer = TextRecognizer();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _image = image;
          _imageBytes = bytes;
          _recognizedText = '';
          _isProcessing = true;
        });
        await _processImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    if (kIsWeb || _textRecognizer == null) {
      setState(() {
        _recognizedText = 'OCR is not supported on web. Please use the mobile app for text recognition.';
        _isProcessing = false;
      });
      return;
    }

    try {
      final inputImage = InputImage.fromFilePath(_image!.path);
      final RecognizedText recognizedText = await _textRecognizer!.processImage(inputImage);

      setState(() {
        _recognizedText = recognizedText.text;
        _isProcessing = false;
      });

      if (_recognizedText.isNotEmpty) {
        _showTextSelectionDialog(_recognizedText);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      }
    }
  }

  void _showTextSelectionDialog(String fullText) {
    final words = fullText.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Words to Learn'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Recognized text:'),
              const SizedBox(height: 8),
              Text(
                fullText,
                style: const TextStyle(fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              const Text('Available words:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: words.take(15).map((word) {
                  return ActionChip(
                    label: Text(word),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _analyzeWord(word);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _analyzeWord(String word) {
    context.read<VocabularyBloc>().add(AnalyzeWordEvent(word));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Analyzing word: $word...')),
    );
  }

  @override
  void dispose() {
    _textRecognizer?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VocabularyBloc, VocabularyState>(
      listener: (context, state) {
        if (state is WordAnalyzed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Word analyzed and saved!')),
          );
        } else if (state is VocabularyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan Text'),
          backgroundColor: const Color(0xFF6366F1),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (kIsWeb) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'OCR text recognition is not available on web. Please use the mobile app for full functionality.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Text(
                'Capture text from images to learn new vocabulary',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_image != null && _imageBytes != null) ...[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (_isProcessing) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 16),
                const Text(
                  'Processing image...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ] else if (_recognizedText.isNotEmpty) ...[
                const Text(
                  'Recognized Text:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_recognizedText),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
