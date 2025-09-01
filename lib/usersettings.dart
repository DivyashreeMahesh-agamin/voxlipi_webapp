import 'package:flutter/material.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

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
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: const Text("User Settings",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  iconTheme: const IconThemeData(color: Colors.black),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        _buildSection("General Settings", [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Column with Language and Time-Zone
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDropdownOnly("Language", ["English", "Spanish"]),
                                    const SizedBox(height: 16),
                                    _buildDropdownOnly("Time-Zone", ["Auto", "UTC", "EST", "PST"]),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              // Right Column with Date Format
                              Expanded(
                                child: _buildDropdownOnly("Date Format", ["MM/DD/YYYY", "DD/MM/YYYY"]),
                              ),
                            ],
                          ),
                        ]),


                        _buildSection("Visit Workflow", [
                          _buildDropdownRow(
                              "Default Visit Type", ["Enter Address", "Home Visit"]),
                          _buildToggleRow("Auto-Save Notes", true),
                          _buildToggleRow("Show Full Notes", false),
                        ]),
                        _buildSection("Notifications", [
                          _buildToggleRow("Auto-Save Notes", true),
                          _buildToggleRow("Show Full Notes", false),
                          _buildDropdownRow("Unread Alert Remainder",
                              ["Every 6 hrs", "Every 12 hrs"]),
                        ]),
                        _buildSection("Security & Storage", [
                          _buildDropdownRow("Auto Logout Time (mins)",
                              ["5", "10", "15"]),
                          _buildToggleRow("Biometric Login", true),
                        ]),
                        _buildSection("Sync & Storage", [
                          _buildToggleRow("Sync on App Launch", true),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), // Control height
                                backgroundColor: Color(0xFF1B7BC4),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Reduce roundness
                                ),
                              ),
                              child: const Text("Sync", style: TextStyle(fontSize: 12)),
                            ),
                          )

                        ]),
                        _buildSection("Support & Feedback", [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Less rounded corners
                                ),
                              ),
                              child: const Text(
                                "Report an Issue",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("App Version      v1.0.0 (build 115)",
                                style: TextStyle(fontSize: 12)),
                          )
                        ]),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.grey),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Reduced roundness
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1B7BC4),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Reduced roundness
                                ),
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24, // horizontal gap
            runSpacing: 16, // vertical gap
            children: children,
          ),
        ],
      ),
    );
  }


  Widget _buildDropdownRow(String label, List<String> items) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 12))))
                .toList(),
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
  Widget _buildDropdownOnly(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 300,
          height: 46,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 12))))
                .toList(),
            onChanged: (val) {},
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6), // Reduced from 12 to 6
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Transform.scale(
            scale: 0.75, // Adjust size as needed
            child: Switch(
              value: value,
              onChanged: (_) {},
              activeColor: Colors.white,
              activeTrackColor: Color(0xFF1B7BC4),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }


}