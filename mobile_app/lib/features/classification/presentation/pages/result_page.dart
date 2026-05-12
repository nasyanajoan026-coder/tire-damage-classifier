import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/classification_result.dart';
import '../../../../core/constants/app_constants.dart';

class ResultPage extends StatelessWidget {
  final ClassificationResult result;
  final File imageFile;

  const ResultPage({super.key, required this.result, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    final best = result.bestModelResult;
    final isDefective = best.isDefective;
    final statusColor = isDefective
        ? const Color(0xFFD32F2F)
        : const Color(0xFF2E7D32);
    final bgColor = isDefective
        ? const Color(0xFFFFF3F3)
        : const Color(0xFFF3FFF3);

    // Hitung ensemble probability (rata-rata ketiga model)
    final allResults = result.allResults;
    double ensembleGood = 0;
    double ensembleDefective = 0;
    for (final r in allResults.values) {
      ensembleGood += r.probabilities['good'] ?? 0;
      ensembleDefective += r.probabilities['defective'] ?? 0;
    }
    ensembleGood /= allResults.length;
    ensembleDefective /= allResults.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Hasil Klasifikasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header title
            const Text(
              'TyreScan — Sistem Inspeksi Ban',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1565C0),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            // Gambar input + Hasil ensemble dalam satu row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📷 Input Gambar',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          imageFile,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Hasil ensemble
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: statusColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🔬 HASIL PREDIKSI ENSEMBLE (3 MODEL)',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isDefective
                              ? 'Ban Rusak / Defective'
                              : 'Ban Bagus / Good',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Confidence: ${best.confidence.toStringAsFixed(2)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isDefective
                              ? '⚠️ BAHAYA — Segera periksa ban'
                              : '✅ AMAN — Ban dalam kondisi baik',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ensemble probability bar
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Probabilitas Ensemble',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ensembleBar('good', ensembleGood, const Color(0xFF2E7D32)),
                  const SizedBox(height: 8),
                  _ensembleBar(
                    'defective',
                    ensembleDefective,
                    const Color(0xFFD32F2F),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detail per model
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Per Model',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _modelDetailCard(
                    'MobileNetV2',
                    result.mobilenetv2,
                    const Color(0xFF1565C0),
                    result.bestModel == 'mobilenetv2',
                  ),
                  const SizedBox(height: 10),
                  _modelDetailCard(
                    'ShuffleNetV2',
                    result.shufflenetv2,
                    const Color(0xFFE65100),
                    result.bestModel == 'shufflenetv2',
                  ),
                  const SizedBox(height: 10),
                  _modelDetailCard(
                    'EfficientNetB0',
                    result.efficientnetb0,
                    const Color(0xFF2E7D32),
                    result.bestModel == 'efficientnetb0',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Info tambahan
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDE7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF9A825)),
              ),
              child: Text(
                isDefective
                    ? '⚠️ Saran: Ban menunjukkan tanda kerusakan. Segera lakukan pemeriksaan ke bengkel terdekat.'
                    : '✅ Saran: Ban dalam kondisi baik. Lakukan pengecekan rutin setiap 10.000 km atau minimal 6 bulan sekali.',
                style: const TextStyle(fontSize: 12, color: Color(0xFF555500)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Klasifikasi Lagi'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ensembleBar(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 18,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${value.toStringAsFixed(2)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _modelDetailCard(
    String name,
    dynamic modelResult,
    Color color,
    bool isBest,
  ) {
    final goodVal = modelResult.probabilities['good'] ?? 0.0;
    final defVal = modelResult.probabilities['defective'] ?? 0.0;
    final isModelDefective = modelResult.isDefective;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBest ? color : color.withOpacity(0.3),
          width: isBest ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris nama model + badge
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (isBest) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'TERBAIK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),

          // Hasil prediksi — baris terpisah supaya tidak overflow
          Text(
            '→ ${isModelDefective ? "Ban Rusak / Defective" : "Ban Bagus / Good"} '
            '(${modelResult.confidence.toStringAsFixed(1)}%) | '
            '${modelResult.inferenceTimeMs.toStringAsFixed(2)} ms',
            style: TextStyle(fontSize: 10, color: color),
          ),
          const SizedBox(height: 8),

          // Bar defective
          _miniBar('Ban Rusak / Defective', defVal, const Color(0xFFD32F2F)),
          const SizedBox(height: 4),
          // Bar good
          _miniBar('Ban Bagus / Good', goodVal, const Color(0xFF2E7D32)),
        ],
      ),
    );
  }

  Widget _miniBar(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
