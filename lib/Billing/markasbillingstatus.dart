import 'package:flutter/material.dart';

class MarkasbillingstatusDialogContent extends StatefulWidget {
  @override
  _MarkasbillingstatusDialogContentState createState() => _MarkasbillingstatusDialogContentState();
}

class _MarkasbillingstatusDialogContentState extends State<MarkasbillingstatusDialogContent> {
  String? _billingChoice;
  final TextEditingController _annotationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row
              Row(
                children: [
                  const Icon(Icons.arrow_back, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Mark Encounter as Not Billable',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),

                ],
              ),
              const SizedBox(height: 10),

              // Info Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Encounter ID", "ENC - 2025 - 0092"),
                    _buildInfoRow("Patient Name", "Olivia Brown"),
                    _buildInfoRow("Date of Service", "2025-06-10"),
                    _buildInfoRow("Rendering Provider", "Dr. Samuel Lee (NPP - Attested)"),
                    _buildInfoRow("Billing NPI", "1812978345"),
                    _buildInfoRow("Attestation", "Completed"),
                    _buildInfoRow("Billing Eligibility", "Eligible", valueColor: Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0), // Adjust as needed
                child: const Text(
                  "Add Internal Notes",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Notes and Radio Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12), // Add vertical space
                          child: Text(
                            "Action Confirmation:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center, // 👈 aligns vertically centered
                          children: [
                            Transform.scale(
                              scale: 0.9, // Shrinks just the radio button
                              child: Radio<String>(
                                value: 'billed',
                                groupValue: _billingChoice,
                                activeColor: Colors.blue,
                                onChanged: (value) => setState(() => _billingChoice = value),
                              ),
                            ),
                            const SizedBox(width: 4), // Optional spacing
                            Expanded(
                              child: Text(
                                'Confirm moving to “In Billing Queue"',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        )

                      ],
                    ),

                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12), // Space between label and TextField
                          child: Text(
                            "Additional Notes",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _annotationController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "Text",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      textStyle: const TextStyle(fontSize: 12,color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      backgroundColor: const Color(0xFF1B7BC4),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Confirm & Move"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: valueColor ?? Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
