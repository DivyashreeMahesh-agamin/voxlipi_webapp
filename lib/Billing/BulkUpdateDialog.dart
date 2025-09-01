import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BulkUpdateDialog extends StatefulWidget {
  const BulkUpdateDialog({super.key});

  @override
  State<BulkUpdateDialog> createState() => _BulkUpdateDialogState();
}

class _BulkUpdateDialogState extends State<BulkUpdateDialog> {
  String? _selectedStatus;
  final TextEditingController _reasonController = TextEditingController();
  bool _isAllSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 580,
          constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(20),
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
                  children: const [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Bulk Update Selected Encounters",
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 535, // 👈 Increase this as needed
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DataTable(
                        headingRowHeight: 32,
                        dataRowMinHeight: 36,
                        dataRowMaxHeight: 38,
                        horizontalMargin: 8,
                        columnSpacing: 20, // 👈 Increase spacing between columns
                        headingRowColor: MaterialStateProperty.all(const Color(0xFFE7F5FF)),
                        columns: const [
                          DataColumn(label: Text("")),
                          DataColumn(label: Text("Encounter ID", style: TextStyle(fontSize: 12))),
                          DataColumn(label: Text("Patient Name", style: TextStyle(fontSize: 12))),
                          DataColumn(label: Text("DOS", style: TextStyle(fontSize: 12))),
                          DataColumn(label: Text("Current Status", style: TextStyle(fontSize: 12))),
                          DataColumn(label: Text("")),
                        ],
                        rows: [
                          _dataRow("ENC-1024", "John Smith", "2024-06-12"),
                          _dataRow("ENC-1025", "Jane Doe", "2024-06-13"),
                          _dataRow("ENC-1026", "Tom White", "2024-06-10"),
                          _dataRow("ENC-1027", "Sara Lee", "2024-06-09"),
                          _dataRow("ENC-1028", "Raj Mehta", "2024-06-08"),
                        ],
                      ),
                    ),
                  ),
                ),



                const SizedBox(height: 16),

                const Text("Select New Billing Status", style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _buildRadio("Mark as Billed"),
                _buildRadio("Mark as in Billing Queue"),
                _buildRadio("Mark as Not Billable"),
                const SizedBox(height: 16),

                const Text("Reason for Status Update *", style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: _reasonController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Text",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                          "Cancel", style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B7BC4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                          "Submit Bulk Update", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _dataRow(String id, String name, String dos) {
    return DataRow(cells: [
      const DataCell(Checkbox(value: false, onChanged: null)),
      DataCell(Text(id, style: const TextStyle(fontSize: 12))),
      DataCell(Text(name, style: const TextStyle(fontSize: 12))),
      DataCell(Text(dos, style: const TextStyle(fontSize: 12))),
      const DataCell(Text("Ready to Bill", style: TextStyle(fontSize: 12))),
      DataCell(
        PopupMenuButton<String>(
          onSelected: (value) {
            print("Selected action: $value for $id");
          },
          itemBuilder: (context) =>
          [
            const PopupMenuItem(value: 'view', child: Text('View')),
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          icon: const Icon(Icons.more_horiz, size: 15),
        ),
      ),
    ]);
  }

  Widget _buildRadio(String label) {
    return RadioListTile<String>(
      title: Text(label, style: const TextStyle(fontSize: 12)),
      value: label,
      groupValue: _selectedStatus,
      onChanged: (val) => setState(() => _selectedStatus = val),
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
    );
  }

}