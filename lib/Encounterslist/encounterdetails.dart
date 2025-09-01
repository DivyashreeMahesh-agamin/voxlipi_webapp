import 'package:flutter/material.dart';

class ConfirmBillingDialogContent1 extends StatelessWidget {
  final Map<String, dynamic> data;

  const ConfirmBillingDialogContent1({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 18),
                    onPressed: () {
                      Navigator.of(context).pop(); // or your custom back logic
                    },
                  ),

                  const SizedBox(width: 8),
                  const Text(
                    'Encounter Details',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Patient Information with grey border
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Encounter ID", "ENC-002343"),
                    _infoRow("Patient Name", "John Doe"),
                    _infoRow("Gender", "Male"),
                    _infoRow("Date of Birth", "12/04/1965"),
                    _infoRow("Date of Service", data['date']),
                    _infoRow("Facility", "St. Mary's Hospital"),
                    _infoRow("MRN", "56890342"),
                    _infoRow("Insurance", "Aetna PPO"),
                    _infoRow("Auth", "7833423908"),
                    _infoRow("Visit Type", data['visitType']),
                    _infoRow("PCP", data['provider']),
                    _infoRow("Status", data['draftStatus']),
                  ],
                ),
              ),


              const SizedBox(height: 12),

              // ICD & CPT Codes
              Row(
                children: [
                  Expanded(
                    child: _tagBox("ICD Codes", [
                      "I10 (Essential Hypertension)",
                      "E11.9 (Type 2 Diabetes Mellitus)"
                    ]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _tagBox("CPT Codes", [
                      "99213 (Office Visit - Est Pt)",
                      "83036 (Glycohemoglobin Test)"
                    ]),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Clinical Notes
              _noteBox("Clinical Notes", [
                "HPI: Patient reports stable condition with improved glucose control.",
                "ROS: Denies chest pain or shortness of breath",
                "PE: Vitals normal. No new symptoms noted.",
                "A/P: Continue current medications. Recheck labs in 3 months."
              ]),

              const SizedBox(height: 12),

              // Attachments & Signature
              Row(
                children: [
                  Expanded(
                    child: _tagBox(
                      "Attachments",
                      [
                        "Lab_Report_June2025.pdf",
                        "Visit_Summary.pdf"
                      ],
                      highlightItems: true,
                    ),

                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: _tagBox("Signature Details", [
                      "Signed By: Dr. Mark Harris (NP: 871326570)",
                      "Date: 06/21/2025, 08:32 AM"
                    ]),
                  ),

                ],
              ),

              const SizedBox(height: 14),
              Center(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text("Back", style: TextStyle(fontSize: 12,color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 25),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
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

  Widget _tagBox(String title, List<String> items, {bool highlightItems = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 5),
          ...items.map((e) => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 2), // 👈 Reduced from 4 to 2
            decoration: highlightItems
                ? BoxDecoration(
              color: const Color(0xFFE7F5FF),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE7F5FF)),
            )
                : null,
            child: Text(e, style: const TextStyle(fontSize: 12)),
          )),
        ],
      ),
    );
  }



  Widget _noteBox(String title, List<String> lines) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white, // Card color
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300), // Subtle border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Soft shadow
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            ...lines.map(
                  (e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(e, style: const TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
