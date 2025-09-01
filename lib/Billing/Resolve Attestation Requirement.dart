import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResolveAttestationRequirementDialog extends StatefulWidget {
  @override
  _ResolveAttestationRequirementDialogState createState() =>
      _ResolveAttestationRequirementDialogState();
}

class _ResolveAttestationRequirementDialogState
    extends State<ResolveAttestationRequirementDialog> {
  String? _selectedRadioValue;
  String? _selectedAction; // initially null


  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: const [
                  Icon(Icons.arrow_back, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Resolve Attestation Requirement',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _buildInfoCard(),
              const SizedBox(height: 12),

              // Action Required Section
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
                      text: const TextSpan(
                        text: 'Action Required',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    _buildRadioOption("Mark as “Attestation Not Required” and proceed to billing"),
                    _buildRadioOption("Send to MD for Attestation"),
                    const SizedBox(height: 12),
                    const Text("Additional Notes", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(height: 6),
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

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Cancel", style: TextStyle(fontSize: 12,color: Colors.black),),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _selectedAction == null
                        ? null // Disabled when not selected
                        : () {
                      Navigator.pop(context); // Enabled when selected
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B7BC4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Confirm & Resolve", style: TextStyle(fontSize: 12)),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 0.75, // Reduce radio button size
            child: Radio<String>(
              value: value,
              groupValue: _selectedAction,
              activeColor: Color(0xFF1B7BC4), // Blue when selected
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              onChanged: (val) {
                setState(() {
                  _selectedAction = val;
                });
              },
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: Colors.black), // Blue text
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
          _buildInfoRow("Patient Name", "Olivia Patel"),
          _buildInfoRow("Date of Service", "2025–06–06"),
          _buildInfoRow("Signed By", "Nancy Moore, NPP"),
          _buildInfoRow("Status", "Signed (Attestation Pending)"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
