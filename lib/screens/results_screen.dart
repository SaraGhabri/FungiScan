import 'package:flutter/material.dart';
import 'dart:io';
import '../services/diagnosis_service.dart';
import '../services/gemini_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ResultsScreen extends StatefulWidget {
  final String imagePath;

  const ResultsScreen({super.key, required this.imagePath});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final DiagnosisService _diagnosisService = DiagnosisService();
  final GeminiService _geminiService = GeminiService();
  Map<String, double>? _results;
  String? _recommendation;
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    try {
      final results = await _diagnosisService.getDiagnosis(widget.imagePath);
      String? recommendation;

      if (results.isNotEmpty) {
        final disease =
            results.entries.reduce((a, b) => a.value > b.value ? a : b).key;
        recommendation = await _geminiService.getRecommendations(disease);
      }

      if (mounted) {
        setState(() {
          _results = results;
          _recommendation = recommendation;
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
      print('Error processing image: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: kIsWeb
                  ? Image.network(widget.imagePath, fit: BoxFit.cover)
                  : Image.file(File(widget.imagePath), fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detected Disease:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_isProcessing)
                    const Center(child: CircularProgressIndicator())
                  else if (_results != null && _results!.isNotEmpty)
                    ..._buildResults()
                  else
                    const Text('No diseases detected'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResults() {
    final sortedResults = _results!.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return [
      Text(
        'Most likely: ${sortedResults.first.key} (${(sortedResults.first.value * 100).toStringAsFixed(2)}%)',
        style: const TextStyle(fontSize: 18),
      ),
      const SizedBox(height: 16),
      const Text(
        'All Predictions:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...sortedResults.map((entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${entry.key}: ${(entry.value * 100).toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 16),
            ),
          )),
      if (_recommendation != null) ...[
        const SizedBox(height: 24),
        const Text(
          'Treatment Recommendations:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _recommendation!,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ];
  }
}
