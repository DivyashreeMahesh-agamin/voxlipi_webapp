import 'package:flutter/material.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';

class EncounterFinalizationScreen extends StatefulWidget {
  const EncounterFinalizationScreen({super.key});

  @override
  State<EncounterFinalizationScreen> createState() =>
      _EncounterFinalizationScreenState();
}

class _EncounterFinalizationScreenState
    extends State<EncounterFinalizationScreen> {
  String _selectedAction = '';
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CollapsibleSidebar(),
          VerticalDivider(width: 5, thickness: 3, color: Colors.grey[300]),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Encounter Finalization',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _infoCard(),
                      const SizedBox(height: 8),
                      _signatureCard(),
                      const SizedBox(height: 8),
                      _buttonRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: child,
      ),
    );
  }

  Widget _infoCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _InfoRow(label: 'Patient Name', value: 'John Hopkins'),
          _InfoRow(label: 'Encounter Date', value: '07/08/2025'),
          _InfoRow(label: 'Visit Type', value: 'Follow-Up'),
          _InfoRow(label: 'Documented By', value: 'Dr. Mary (NPP)'),
          _InfoRow(label: 'Notes Status', value: 'Finalized by NPP'),
        ],
      ),
    );
  }

  Widget _signatureCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Signature Action Required',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Detected Action: ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text: 'Co-Sign Required', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Actions',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          _buildRadio('Sign Off & Complete'),
          _buildRadio('I Attest'),
          _buildRadio('Reviewed Without Signature'),
          const SizedBox(height: 12),
          const Text(
            'Enter Reason',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _reasonController,
            maxLines: 4,
            style: const TextStyle(fontSize: 12),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Text',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'MD Signature Confirmation',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '"Dr. John Doe on 07/08/2025  at 15:34"',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRadio(String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      horizontalTitleGap: 4,
      minLeadingWidth: 16,
      leading: Transform.scale(
        scale: 0.8, // Adjust the size of the radio icon
        child: Radio<String>(
          value: value,
          groupValue: _selectedAction,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: (val) {
            setState(() {
              _selectedAction = val!;
            });
          },
        ),
      ),
      title: Text(
        value,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }



  Widget _buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionButton('Cancel', Colors.white, Colors.black, () {}),
        const SizedBox(width: 12),
        _actionButton('Save Draft', Color(0xFF1B7BC4), Colors.white, () {}),
        const SizedBox(width: 12),
        _actionButton('Submit', Color(0xFF1B7BC4), Colors.white, () {}),
      ],
    );
  }

  Widget _actionButton(
      String label,
      Color bgColor,
      Color textColor,
      VoidCallback onPressed,
      ) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 12)),
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

