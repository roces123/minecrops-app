import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CropDetailScreen extends StatelessWidget {
  final Map<String, dynamic> cropData;
  const CropDetailScreen({super.key, required this.cropData});

  String _get(Map<String, dynamic> map, List<String> keys) {
    for (var k in keys) {
      if (map.containsKey(k) && map[k] != null) {
        final value = map[k];
        final stringValue = value.toString().trim();

        if (stringValue.isNotEmpty) {
          return stringValue;
        }
      }
    }
    return '';
  }

  bool _getIsCommon(Map<String, dynamic> map, List<String> keys) {
    for (var k in keys) {
      if (map.containsKey(k) && map[k] != null) {
        final value = map[k];
        if (value is bool) {
          return value;
        }
        if (value is String) {
          final lower = value.toLowerCase().trim();
          return lower == 'true' || lower == '1';
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final id = cropData['_docId'] ?? 'detail';
    final name = _get(cropData, ['Name', 'name', 'cropName']);
    final imageUrl = _get(cropData, ['Image Url', 'imageUrl', 'image', 'ImageUrl', 'imageurl']);
    final scientific = _get(cropData, ['Scientific Name', 'scientificName', 'scientific name']);
    final description = _get(cropData, ['Description', 'description', 'Details', 'details']);
    final soil = _get(cropData, ['Soil Type', 'SoilType', 'soilType', 'soil']);
    final growthDuration = _get(cropData, ['Growth Duration', 'growthDuration', 'duration']);
    final plantingSpacing = _get(cropData, ['Planting Spacing', 'plantingSpacing', 'spacing']);
    final bestSeason = _get(cropData, ['Best Season', 'Best Seasons', 'bestSeasons', 'seasons']);
    final harvestSeason = _get(cropData, ['Harvest Season', 'harvestSeason', 'harvest']);
    final fertilizationStages = _get(cropData, ['Fertilization Stages', 'fertilizationStages', 'fertStages']);
    final fertilizers = _get(cropData, ['Fertilizers', 'fertilizers', 'fertilizer']);
    final pests = _get(cropData, ['Pests', 'pests', 'Common Pests']);
    final pesticides = _get(cropData, ['Pesticides', 'pesticides', 'pesticide']);
    final isCommon = _getIsCommon(cropData, ['IsCommon', 'isCommon']);


    return Scaffold(
      appBar: AppBar(
        title: Text(name.isEmpty ? 'Crop Details' : name),
        backgroundColor: const Color(0xFF6B8E23),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              Hero(
                tag: id,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
                  },
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 220,
                    child: Center(child: Icon(Icons.broken_image, size: 48)),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty ? 'Unnamed Crop' : name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (isCommon)
                    const Text(
                        '⭐ Common Crop',
                        style: TextStyle(fontSize: 14, color: Color(0xFF6B8E23), fontWeight: FontWeight.bold)
                    ),
                  const SizedBox(height: 8),
                  if (scientific.isNotEmpty) ...[
                    Text.rich(
                      TextSpan(
                        text: 'Scientific Name: ',
                        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: scientific,
                            style: const TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (description.isNotEmpty) ...[
                    const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(description, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 16),
                  ],

                  if (soil.isNotEmpty) ...[
                    Text.rich(
                      TextSpan(
                        text: 'Best Soil Type: ',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: soil,
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (growthDuration.isNotEmpty) ...[
                    Text.rich(
                      TextSpan(
                        text: 'Growth Duration: ',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: growthDuration,
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (plantingSpacing.isNotEmpty) ...[
                    Text.rich(
                      TextSpan(
                        text: 'Planting Spacing: ',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: plantingSpacing,
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (bestSeason.isNotEmpty || harvestSeason.isNotEmpty) ...[
                    const Text('Best Season / Months', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    if (bestSeason.isNotEmpty)
                      Text('Planting: $bestSeason', style: const TextStyle(fontSize: 14)),
                    if (harvestSeason.isNotEmpty)
                      Text('Harvesting: $harvestSeason', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 16),
                  ],

                  if (fertilizationStages.isNotEmpty || fertilizers.isNotEmpty) ...[
                    const Text('Fertilization Stages', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    if (fertilizationStages.isNotEmpty)
                      Text('$fertilizationStages', style: const TextStyle(fontSize: 14)),
                    const Text('Fertilizers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    if (fertilizers.isNotEmpty)
                      Text('$fertilizers', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 16),
                  ],
                  if (pests.isNotEmpty || pesticides.isNotEmpty) ...[
                    const Text('Common Pests & Diseases', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    if (pests.isNotEmpty)
                      Text('Pests: $pests', style: const TextStyle(fontSize: 14)),
                    const Text('Pesticides', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    if (pesticides.isNotEmpty)
                      Text('$pesticides', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}