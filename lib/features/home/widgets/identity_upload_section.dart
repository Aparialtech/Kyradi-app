import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../widgets/section_card.dart';
import '../models/identity_document_type.dart';

class IdentityUploadSection extends StatelessWidget {
  const IdentityUploadSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.types,
    required this.selectedType,
    required this.typeLabelBuilder,
    required this.statusText,
    required this.previewBytes,
    required this.previewUrl,
    required this.previewPlaceholder,
    required this.onTypeChanged,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onClear,
    required this.takePhotoLabel,
    required this.pickGalleryLabel,
    required this.deleteLabel,
    required this.hasIdentityProof,
  });

  final String title;
  final String subtitle;
  final List<IdentityDocumentType> types;
  final IdentityDocumentType selectedType;
  final String Function(IdentityDocumentType) typeLabelBuilder;
  final String statusText;
  final Uint8List? previewBytes;
  final String? previewUrl;
  final String previewPlaceholder;
  final ValueChanged<IdentityDocumentType> onTypeChanged;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final VoidCallback onClear;
  final String takePhotoLabel;
  final String pickGalleryLabel;
  final String deleteLabel;
  final bool hasIdentityProof;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            icon: Icons.verified_user_outlined,
          ),
          const SizedBox(height: 12),
          SegmentedButton<IdentityDocumentType>(
            segments: types
                .map(
                  (type) => ButtonSegment<IdentityDocumentType>(
                    value: type,
                    label: Text(typeLabelBuilder(type)),
                  ),
                )
                .toList(),
            selected: {selectedType},
            onSelectionChanged: (value) => onTypeChanged(value.first),
          ),
          const SizedBox(height: 12),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          _buildIdentityPreview(context),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: onPickCamera,
                icon: const Icon(Icons.camera_alt),
                label: Text(takePhotoLabel),
              ),
              OutlinedButton.icon(
                onPressed: onPickGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(pickGalleryLabel),
              ),
              if (hasIdentityProof)
                TextButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(deleteLabel),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityPreview(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);
    if (previewBytes != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.memory(
          previewBytes!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    if (previewUrl?.isNotEmpty == true) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          previewUrl!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: 160,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              _buildIdentityPlaceholder(context),
        ),
      );
    }
    return _buildIdentityPlaceholder(context);
  }

  Widget _buildIdentityPlaceholder(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Center(
        child: Text(previewPlaceholder),
      ),
    );
  }
}
