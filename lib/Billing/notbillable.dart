import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MarkAsNotBillableDialog extends StatefulWidget {
  @override
  _MarkAsNotBillableDialogState createState() => _MarkAsNotBillableDialogState();
}

class _MarkAsNotBillableDialogState extends State<MarkAsNotBillableDialog> {
  final TextEditingController _otherReasonController = TextEditingController();

  String? _selectedReason;
  final TextEditingController _notesController = TextEditingController();
  bool isFormValid = false;
  void _validateForm() {
    setState(() {
      isFormValid = _selectedReason != null && _selectedReason!.isNotEmpty;
    });
  }
  @override
  void initState() {
    super.initState();
    _validateForm();
  }


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
                    'Mark Encounter as Not Billable',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),

                ],
              ),
              const SizedBox(height: 8),

              // Encounter Info
              _buildInfoCard(),

              const SizedBox(height: 10),

              // Reason Selection + Notes
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Reason for Not Billing",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.black, // ensure the main text is visible
                            ),
                          ),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRadio("Patient not eligible"),
                        _buildRadio("Missing documentation"),
                        _buildRadio("Provider error"),
                        _buildRadio("Other"),

                        // Show the textbox if "Other" is selected
                        if (_selectedReason == "Other")
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0, top: 4.0),
                            child: TextField(
                              controller: _otherReasonController,
                              onChanged: (val) {
                                _validateForm(); // Optional: revalidate when input changes
                              },
                              decoration: InputDecoration(
                                hintText: "Please specify the reason",
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),



                    const SizedBox(height: 5),
                    const Text("Additional Notes", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      maxLength: 250, // Optional: Adds counter
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(250), // Enforces input cap
                      ],
                      validator: (value) {
                        if (value != null && value.length > 250) {
                          return 'Additional Note cannot exceed 250 characters';
                        }
                        return null;
                      },
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "Text",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Warning
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.warning, color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "Are you sure you want to mark this encounter as "),
                            TextSpan(
                              text: "Not Billable?",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                            TextSpan(text: "\nThis will remove it from the billing queue and freeze the note."),
                          ],
                        ),
                        style: TextStyle(fontSize: 12),
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
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      textStyle: const TextStyle(fontSize: 12,color: Colors.black),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                      // Confirm logic
                      Navigator.pop(context);
                    }
                        : null, // disable if invalid
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      backgroundColor: const Color(0xFF1B7BC4),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Confirm & Mark Not Billable"),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // Optional small spacing between radios
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Makes row size wrap its content
        children: [
          Transform.scale(
            scale: 0.75, // Shrinks just the radio button
            child: Radio<String>(
              value: value,
              groupValue: _selectedReason,
              activeColor: Colors.blue, // Blue when selected
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrinks tap area
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              onChanged: (val) => setState(() {
                _selectedReason = val;
                _validateForm();
              }),

            ),
          ),
          const SizedBox(width: 4), // Tiny gap between radio and label
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Encounter ID", "ENC - 2025 - 0107"),
          _buildInfoRow("Patient Name", "Noah Anderson"),
          _buildInfoRow("Date of Service", "2025–06–05"),
          _buildInfoRow("Rendering Provider", "Dr. Alicia Wong (MD)"),
          _buildInfoRow("Billing NPI", "1234567893"),
          _buildInfoRow("Current Status", "Ready to Bill"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
