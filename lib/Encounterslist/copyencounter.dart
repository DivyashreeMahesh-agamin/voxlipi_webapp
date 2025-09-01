import 'package:flutter/material.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';

class CopyEncounterScreen extends StatefulWidget {
  @override
  State<CopyEncounterScreen> createState() => _CopyEncounterScreenState();
}

class _CopyEncounterScreenState extends State<CopyEncounterScreen> {
  String selectedVisitType = "Follow-Up";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CollapsibleSidebar(),
          VerticalDivider(width: 1, thickness: 1, color: Colors.grey[300]),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Copy Encounter",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Patient Info Box
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Patient Name", "John Hopkins"),
                        _buildInfoRow("Original Encounter Date", "06/10/2025"),
                        _buildInfoRow("Visit Type", "Follow-Up"),
                        _buildInfoRow("Rendering Provider", "Dr. Mary NFP"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  copyEncounterDetailsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget copyEncounterDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Copy Encounter Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        // New Encounter Date
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(text: 'New Encounter Date '),
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),

        const SizedBox(height: 6),
        SizedBox(
          height: 36,
          width: 200,
          child: TextFormField(
            initialValue: "06/20/2025",
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF6F6F6),
              suffixIcon: const Icon(Icons.calendar_today, size: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            style: const TextStyle(fontSize: 12),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "New Visit Type",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            _visitRadio("Initial"),
            _visitRadio("Follow-Up"),
            _visitRadio("Discharge"),
            _visitRadio("Others"),
          ],
        ),

        const SizedBox(height: 20),

        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black87, fontSize: 12),
            children: [
              TextSpan(text: "Notes, ICDs, CPTs will be copied. "),
              TextSpan(
                text: "Voice dictation will not be copied.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 18),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                "A signed encounter for this date already exists. Proceed?",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B7BC4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text("View Existing Encounter", style: TextStyle(fontSize: 13)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B7BC4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text("Override & Continue", style: TextStyle(fontSize: 13)),
            ),
          ],
        ),

        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text("Cancel", style: TextStyle(fontSize: 13)),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B7BC4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text("Copy Now", style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _visitRadio(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: label,
          groupValue: selectedVisitType,
          onChanged: (value) {
            setState(() {
              selectedVisitType = value!;
            });
          },
          visualDensity: VisualDensity.compact,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
