import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DuplicatePatientDialog extends StatelessWidget {
  const DuplicatePatientDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360), // reduced width
        child: Padding(
          padding: const EdgeInsets.all(20), // tighter padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Possible Duplicate Detected",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "A patient with similar information already exists in the system. Please review the matched record below before proceeding.",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              const Text(
                "Matched Patient Record",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Patient Info Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [

                    _InfoRow(label: "Patient ID", value: "P982"),
                    _InfoRow(label: "Patient Name", value: "John Doe"),
                    _InfoRow(label: "Gender", value: "Male"),
                    _InfoRow(label: "DOB", value: "05–Sep–1975"),
                    _InfoRow(label: "Facility", value: "Green Valley Clinic"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "What would you like to do?",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),// Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
),
 // fully rounded
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text("Cancel", style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle override
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B7BC4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      elevation: 2,
                    ),
                    child: const Text("Override", style: TextStyle(fontSize: 12)),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(flex: 3, child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
