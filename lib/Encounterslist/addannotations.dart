import 'package:flutter/material.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';

class AddAnnotationScreen extends StatelessWidget {
  const AddAnnotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar
          CollapsibleSidebar(),

          // Vertical Divider
          VerticalDivider(width: 1, thickness: 1, color: Colors.grey[300]),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add Annotation",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Patient Info Card
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 700,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _InfoRow(label: "Patient Name", value: "John Hopkins"),
                            _InfoRow(label: "Encounter Date", value: "07/08/2025"),
                            _InfoRow(label: "Rendering Provider", value: "Dr. Test"),
                            _InfoRow(label: "Status", value: "Signed & Locked"),
                          ],
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 700, // Reduced from 700
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Original Clinical Notes",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(height: 12),

                            // Reduced height TextFormField
                            SizedBox(
                              height: 60,
                              child: TextFormField(
                                initialValue: "*Patient stable, continue meds.........*",
                                maxLines: null,
                                readOnly: true,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            const Text("Add Annotation",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 12),

                            const Text("Annotation Type", style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 6),

// Reduced width Dropdown
                            SizedBox(
                              width: 250, // Adjust width as needed
                              height: 40,
                              child: DropdownButtonFormField<String>(
                                value: "Clinical",
                                items: const [
                                  DropdownMenuItem(
                                    value: "Clinical",
                                    child: Text("Clinical", style: TextStyle(fontSize: 12)),
                                  ),
                                  DropdownMenuItem(
                                    value: "Billing",
                                    child: Text("Billing", style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                                onChanged: (value) {},
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),

                            const SizedBox(height: 10),
                            const Text("Add Notes", style: TextStyle(fontSize: 12)),
                            const SizedBox(height: 6),

                            // Smaller comment box
                            SizedBox(
                              height: 60,
                              child: TextFormField(
                                maxLines: 4,
                                style: const TextStyle(fontSize: 12),
                                decoration: const InputDecoration(
                                  hintText: "notes",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.75, // Adjust between 0.6–0.9 for smaller checkbox
                                  child: Checkbox(
                                    value: false, // control with a variable in StatefulWidget
                                    onChanged: (val) {
                                      // setState(() => yourCheckboxValue = val!);
                                    },
                                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeColor: Colors.blue,
                                  ),
                                ),

                                const Text(
                                  "Mark as visible to Biller",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Adjust as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Signature",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        const Text("Dr. Test", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24), // Optional: keeps spacing below the signature


                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Cancel",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1B7BC4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Save Annotation & Return",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
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
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
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

