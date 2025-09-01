import 'package:flutter/material.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';

import 'package:flutter/material.dart';

class RevertToDraftScreen extends StatelessWidget {
  const RevertToDraftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar if needed
          CollapsibleSidebar(),

          // Vertical Divider
          VerticalDivider(width: 5, thickness: 3, color: Colors.grey[300]),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Revert Encounter to Draft",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Encounter Info
                  Container(
                    width: 600,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(label: "Encounter ID", value: "E456789"),
                        _InfoRow(label: "Patient Name", value: "John Doe"),
                        _InfoRow(label: "Date of Service", value: "2025-06-20"),
                        _InfoRow(label: "Signed By", value: "Dr. Smith"),
                        _InfoRow(label: "Signed On", value: "2025-06-21, 10:15 AM"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Reason for Reverting
                  Container(
                    width: 600,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Reason for Reverting",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 300,
                          child: DropdownButtonFormField<String>(
                            value: "Incorrect CPT/ICD Codes",
                            items: const [
                              DropdownMenuItem(
                                value: "Incorrect CPT/ICD Codes",
                                child: Text("Incorrect CPT/ICD Codes", style: TextStyle(fontSize: 12)),
                              ),
                              DropdownMenuItem(
                                value: "Incomplete Clinical Note",
                                child: Text("Incomplete Clinical Note", style: TextStyle(fontSize: 12)),
                              ),
                              DropdownMenuItem(
                                value: "Wrong Patient/Encounter Selected",
                                child: Text("Wrong Patient/Encounter Selected", style: TextStyle(fontSize: 12)),
                              ),
                              DropdownMenuItem(
                                value: "Duplicate Encounter",
                                child: Text("Duplicate Encounter", style: TextStyle(fontSize: 12)),
                              ),
                              DropdownMenuItem(
                                value: "Medical Necessity Not Justified",
                                child: Text("Medical Necessity Not Justified", style: TextStyle(fontSize: 12)),
                              ),
                              DropdownMenuItem(
                                value: "Error in Documentation",
                                child: Text("Error in Documentation", style: TextStyle(fontSize: 12)),
                              ),
                              DropdownMenuItem(
                                value: "Additional Tests/Observations",
                                child: Text("Additional Tests/Observations", style: TextStyle(fontSize: 12)),
                              ),
                              DropdownMenuItem(
                                value: "Requested by Biller",
                                child: Text("Requested by Biller", style: TextStyle(fontSize: 12)),
                              ),
                              DropdownMenuItem(
                                value: "Other",
                                child: Text("Other", style: TextStyle(fontSize: 12)),
                              ),
                            ],
                            onChanged: (value) {
                              // Handle selected value
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            style: const TextStyle(fontSize: 12),
                            dropdownColor: Colors.white, // Ensures dropdown menu also has white bg
                          ),
                        ),


                        const SizedBox(height: 10),
                        const Text("If Other - Reason", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextFormField(
                          maxLines: 4,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: "Reason",
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Additional Comments
                  Container(
                    width: 600,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Additional Notes", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextFormField(
                          maxLines: 4,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            hintText: "notes",
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Cancel", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B7BC4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Revert to Draft", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Info row widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}


