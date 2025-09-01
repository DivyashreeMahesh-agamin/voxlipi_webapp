import 'package:flutter/material.dart';

class ConfirmBillingDialogContent extends StatefulWidget {
  @override
  _ConfirmBillingDialogContentState createState() => _ConfirmBillingDialogContentState();
}

class _ConfirmBillingDialogContentState extends State<ConfirmBillingDialogContent> {
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
              // Title
              Row(
                children: [
                  const Icon(Icons.arrow_back, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Confirm Billing Status',
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
                    _buildInfoRow("Encounter ID", "ENC - 2025 - 0067"),
                    _buildInfoRow("Patient Name", "John Smith"),
                    _buildInfoRow("Date of Service", "2025-06-10"),
                    _buildInfoRow("Rendering Provider", "Dr. Amanda Ray (MD)"),
                    _buildInfoRow("Billing NPI", "1882347662"),
                    _buildInfoRow("Attestation", "No"),
                    _buildInfoRow("Billing Eligibility", "Billable", valueColor: Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15), // adjust as needed
                child: Text(
                  "Add Optional Annotation",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),



              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // 👈 Align with header
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Billing Confirmation:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 4), // Optional small space below label
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the left
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Transform.scale(
                                          scale: 0.75, // 👈 Makes only the radio button smaller
                                          child: Radio<String>(
                                            value: 'billed',
                                            groupValue: _billingChoice,
                                            activeColor: Colors.blue, // 👈 Blue when selected
                                            onChanged: (value) => setState(() => _billingChoice = value),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'Confirm this encounter as "Billed"',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0), // 👈 Small vertical space between options
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Transform.scale(
                                          scale: 0.75,
                                          child: Radio<String>(
                                            value: 'queue',
                                            groupValue: _billingChoice,
                                            activeColor: Colors.blue,
                                            onChanged: (value) => setState(() => _billingChoice = value),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'Move to "In Billing Queue"',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18), // Space between label and TextField
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

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontSize: 12,color: Colors.black),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      backgroundColor: const Color(0xFF1B7BC4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    child: const Text("Confirm"),
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
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
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
