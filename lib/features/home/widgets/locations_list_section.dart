import 'package:flutter/material.dart';
import '../../../core/drop_locations.dart';
import '../../../widgets/gradient_button.dart';
import '../../../widgets/section_card.dart';

typedef DeliverySelectionChanged = void Function(
  String? id,
  DropLocation? location,
);

class LocationsListSection extends StatelessWidget {
  const LocationsListSection({
    super.key,
    required this.deliveryTitle,
    required this.deliverySubtitle,
    required this.reservationTitle,
    required this.reservationSubtitle,
    required this.deliveryPointLabel,
    required this.destinationLabel,
    required this.transitRouteLabel,
    required this.deliveryOptionLabel,
    required this.locations,
    required this.selectedDeliveryId,
    required this.destinationCtrl,
    required this.onDeliveryChanged,
    required this.onTransitRoute,
    required this.buildReservationTile,
  });

  final String deliveryTitle;
  final String deliverySubtitle;
  final String reservationTitle;
  final String reservationSubtitle;
  final String deliveryPointLabel;
  final String destinationLabel;
  final String transitRouteLabel;
  final String Function(DropLocation location) deliveryOptionLabel;
  final List<DropLocation> locations;
  final String? selectedDeliveryId;
  final TextEditingController destinationCtrl;
  final DeliverySelectionChanged onDeliveryChanged;
  final VoidCallback onTransitRoute;
  final Widget Function(DropLocation location) buildReservationTile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: deliveryTitle,
                subtitle: deliverySubtitle,
                icon: Icons.route_outlined,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey(selectedDeliveryId),
                initialValue: selectedDeliveryId,
                decoration: InputDecoration(
                  labelText: deliveryPointLabel,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                isExpanded: true,
                items: locations
                    .map(
                      (location) => DropdownMenuItem<String>(
                        value: location.id,
                        child: Text(deliveryOptionLabel(location)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  DropLocation? selected;
                  if (value != null) {
                    for (final location in locations) {
                      if (location.id == value) {
                        selected = location;
                        break;
                      }
                    }
                  }
                  onDeliveryChanged(value, selected);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: destinationCtrl,
                decoration: InputDecoration(
                  labelText: destinationLabel,
                  prefixIcon: const Icon(Icons.directions_transit),
                ),
              ),
              const SizedBox(height: 16),
              GradientButton(
                text: transitRouteLabel,
                onPressed: onTransitRoute,
                leading: const Icon(Icons.directions_transit),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: reservationTitle,
                subtitle: reservationSubtitle,
                icon: Icons.apartment_outlined,
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: locations.length,
                itemBuilder: (context, index) =>
                    buildReservationTile(locations[index]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
