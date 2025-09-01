import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:webappnursingapp/Billing/BulkUpdateDialog.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';
import 'package:webappnursingapp/Billing/Resolve%20Attestation%20Requirement.dart';
import 'package:webappnursingapp/Billing/markasbilled.dart';
import 'package:webappnursingapp/Billing/markasbillingstatus.dart';
import 'package:webappnursingapp/Billing/notbillable.dart';

class ReadyToBillPage extends StatefulWidget {

  @override
  _ReadyToBillState createState() => _ReadyToBillState();
}
class _ReadyToBillState extends State<ReadyToBillPage> {
  TextEditingController _filterSearchController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<bool> _selectedRows = List.generate(5, (_) => false);

  List<List<dynamic>> _allRows = []; // All raw data
  List<List<dynamic>> _filteredRows = []; // Filtered data shown in the table
  DateTime? _fromDate;
  DateTime? _toDate;

  bool _isAllSelected = false;



  @override
  void initState() {
    super.initState();

    _allRows = [
      ["John Smith", "2025-06-10", "Dr. Amanda Ray", "Dr. Amanda Ray", "1882347662", "No", "Billable", "0–3 days", Colors.orange],
      ["Mike Johnson", "2025-06-08", "Dr. Steven Patel", "Rachal Thomas", "1448752019", "Yes", "Billable", ">7 days", Colors.red],
      ["Eva Adams", "2025-06-03", "-", "-", "-", "Yes", "Not Billed", ">7 days", Colors.red],
      ["Anika Joseph", "2025-06-11", "Dr. Ravi Iyer", "-", "122093440", "Missing", "Not Billed", "4–7 days", Colors.orangeAccent],
      ["Carlos Hernandez", "2025-06-12", "Susan Greene", "Dr. Leonard McKay", "1883312998", "Yes", "Billable", "0–3 days", Colors.orange],
    ];

    _filteredRows = List.from(_allRows);

    _searchController.addListener(_filterRows);
  }
  void _filterRows() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredRows = List.from(_allRows);
      } else {
        _filteredRows = _allRows.where((row) {
          // Check if any string field contains the query
          return row.sublist(0, 8).any((cell) =>
              cell.toString().toLowerCase().contains(query));
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final GlobalKey _funnelKey = GlobalKey();
  OverlayEntry? _filterPopup;
  OverlayEntry? _filterSubMenu;

  final List<String> _filters = [
    "Facility",
    "Date of Service",
    "Visit Type",
    "Rendering Provider",
    "Status",
  ];
  List<String> _filterOptionsMap(String filter) {
    switch (filter) {
      case "Facility":
        return ["Main Hospital", "Outreach Center"];
      case "Date of Service":
        return ["Today", "This Week", "This Month", "Custom Range"]; // Add this option
      case "Visit Type":
        return ["Emergency", "Routine"];
      case "Rendering Provider":
        return ["Dr. Smith", "Dr. Lee"];
      case "Status":
        return ["Approved", "Pending", "Denied"];
      default:
        return ["Option A", "Option B"];
    }
  }
  void _onFilterOptionSelected(String filter, String option) {
    if (filter == "Date of Service" && option == "Custom Range") {
      _showDateRangePicker(context);
    } else {
      // Apply other filters normally (today, this week, this month)
      print('Selected option: $option');
    }
  }


  void _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
        // Filter your data based on _fromDate and _toDate
      });
    }
  }

  void showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          color: Colors.white,
          width: 450, // fixed width like your screenshot
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: const [
                  Icon(Icons.arrow_back, size: 20),
                  SizedBox(width: 8),
                  Text("Notifications",
                      style: TextStyle(fontSize:14, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),

              // Notifications List
              _buildNotificationCard(
                context,
                title: "Co–Sign Required",
                subtitle: "2 encounters pending MD co-sign/attestation",
                buttonLabel: "View Encounter",
                cardColor: const Color(0xFFFFF5F5),
                borderColor: Colors.red,
                buttonColor: Colors.red,
                onPressed: () {
                  Navigator.pop(context); // close popup

                },
              ),
              const SizedBox(height: 8),
              _buildNotificationCard(
                context,
                title: "Overdue Tasks",
                subtitle: "Vitals not recorded for 1 visit (Elijah Thompson)\nDischarge summary pending (Marine Johnson)",
                buttonLabel: "View Tasks",
                cardColor: Colors.white,
                borderColor: Colors.grey.shade300,
                buttonColor: const Color(0xFF1B7BC4),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              _buildNotificationCard(
                context,
                title: "New Assignment",
                subtitle: "1 new patient assigned: Johnathan Miller",
                buttonLabel: "Go To Patients",
                cardColor: Colors.white,
                borderColor: Colors.grey.shade300,
                buttonColor: const Color(0xFF1B7BC4),
                onPressed: () {
                  Navigator.pop(context);

                },
              ),
              const SizedBox(height: 8),
              _buildNotificationCard(
                context,
                title: "Visit Finalization Reminder",
                subtitle: "1 visit marked complete but missing clinical note",
                buttonLabel: "Add Clinical Notes",
                cardColor: Colors.white,
                borderColor: Colors.grey.shade300,
                buttonColor: const Color(0xFF1B7BC4),
                onPressed: () {
                  Navigator.pop(context);

                },
              ),
              const SizedBox(height: 10),

              // Clear All Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background
                  foregroundColor: Colors.black, // Black text
                  elevation: 0, // No shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black), // Black border
                  ),
                ),
                child: const Text("Clear All"),
              ),

            ],
          ),
        ),
      ),
    );
  }


  void _showFilterPopup(BuildContext context) {
    _removeAllPopups();

    final renderBox = _funnelKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context);
    if (renderBox == null || overlay == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _filterPopup = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeAllPopups,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: position.dx,
            top: position.dy + size.height + 5,
            child: Material(
              elevation: 6,
              color: Colors.transparent,
              child: Container(
                width: 160,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF1B7BC4), width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _filters.map((filter) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _showFilterSubMenu(context, filter, position),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: filter == "Option 2" ? Color(0xFF1B7BC4) : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(filter, style: const TextStyle(fontSize: 12))),
                              const Icon(Icons.chevron_right, size: 16),
                            ],
                          ),
                        ),
                      ),
                    );

                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_filterPopup!);
  }


  void _showFilterSubMenu(BuildContext context, String filter, Offset basePosition) {
    _filterSubMenu?.remove();
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final allOptions = _filterOptionsMap(filter);
    final TextEditingController _filterSearchController = TextEditingController();
    List<String> filteredOptions = List.from(allOptions);

    // Track selected checkboxes
    final Map<String, bool> selectedValues = {
      for (var option in allOptions) option: false,
    };

    // Track custom range
    DateTime? customStart;
    DateTime? customEnd;

    _filterSubMenu = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void updateFilter(String query) {
              setState(() {
                filteredOptions = allOptions
                    .where((option) => option.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

            return Positioned(
              left: basePosition.dx + 180,
              top: basePosition.dy + 40,
              child: Material(
                elevation: 6,
                color: Colors.transparent,
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFF1B7BC4), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search field
                      SizedBox(
                        width: 200,
                        height: 40,
                        child: TextField(
                          controller: _filterSearchController,
                          onChanged: updateFilter,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "Search",
                            hintStyle: const TextStyle(fontSize: 12),
                            prefixIcon: const Icon(Icons.search, size: 16),
                            suffixIcon: _filterSearchController.text.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                _filterSearchController.clear();
                                updateFilter('');
                              },
                            )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (filteredOptions.isEmpty)
                        const Text('No results', style: TextStyle(fontSize: 12))
                      else
                        ...filteredOptions.map((option) {
                          return MouseRegion(
                            cursor: SystemMouseCursors.basic,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.grey,
                                checkboxTheme: CheckboxThemeData(
                                  fillColor: MaterialStateProperty.resolveWith((states) {
                                    if (states.contains(MaterialState.selected)) {
                                      return Color(0xFF1B7BC4);
                                    }
                                    return Colors.white;
                                  }),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              child: CheckboxListTile(
                                dense: true,
                                visualDensity:
                                const VisualDensity(horizontal: -4, vertical: -4),
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  option == "Custom Range" && customStart != null && customEnd != null
                                      ? "$option: ${customStart!.toLocal().toString().split(' ')[0]} → ${customEnd!.toLocal().toString().split(' ')[0]}"
                                      : option,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                value: selectedValues[option],
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (val) async {
                                  if (filter == "Date of Service" && option == "Custom Range") {
                                    // Open date range picker
                                    final picked = await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now().add(Duration(days: 365)),
                                    );

                                    if (picked != null) {
                                      setState(() {
                                        customStart = picked.start;
                                        customEnd = picked.end;
                                        selectedValues.updateAll((key, value) => false);
                                        selectedValues[option] = true;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      selectedValues[option] = val ?? false;
                                    });
                                  }
                                },
                              ),
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(_filterSubMenu!);
  }



  void _removeAllPopups() {
    _filterPopup?.remove();
    _filterPopup = null;

    _filterSubMenu?.remove();
    _filterSubMenu = null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar
          CollapsibleSidebar(),

          // Divider
          VerticalDivider(width: 5, thickness: 3, color: Colors.grey[300]),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const Text(
                        "Ready to Bill Encounter List",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(), // Pushes the icon to the end
                      InkWell(
                        onTap: () => showNotificationDialog(context),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.notifications, color: Color(0xFF1B7BC4)),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 20), // Keep this for spacing below


                  // Filters
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    SizedBox(
                    width: 280,
                    height: 40,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                            : null,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                  ),
                      const SizedBox(width: 16),
                      IconButton(
                        key: _funnelKey,
                        icon: const Icon(Icons.filter_alt),
                        iconSize: 20,
                        onPressed: () => _showFilterPopup(context),
                      ),

                      IconButton(
                        iconSize: 20,
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          _searchController.clear(); // Clear the search input
                          setState(() {
                            _filteredRows = List.from(_allRows); // Reset to full data
                            _selectedRows = List.generate(_filteredRows.length, (_) => false); // Reset selection
                          });
                        },
                      ),


                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 300,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 1000),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(const Color(0xFFE7F5FF)),
                              columnSpacing: 12,
                              dataRowHeight: 40,
                              headingRowHeight: 42,
                              horizontalMargin: 8,
                              dividerThickness: 0.0,
                              columns: [
                                DataColumn(
                                  label: Transform.scale(
                                    scale: 0.65,
                                    child: Checkbox(
                                      value: _isAllSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          _isAllSelected = value!;
                                          for (int i = 0; i < _selectedRows.length; i++) {
                                            _selectedRows[i] = _isAllSelected;
                                          }
                                        });
                                      },
                                      activeColor: Color(0xFF1B7BC4),
                                      checkColor: Colors.white,
                                    ),
                                  ),
                                ),

                                // Checkbox header placeholder
                                const DataColumn(label: HeaderCell("Patient Name")),
                                const DataColumn(label: HeaderCell("DOS")),
                                const DataColumn(label: HeaderCell("Rendering Provider")),
                                const DataColumn(label: HeaderCell("Supervising Provider")),
                                const DataColumn(label: HeaderCell("Billing NPI")),
                                const DataColumn(label: HeaderCell("Attestation")),
                                const DataColumn(label: HeaderCell("Billing Eligibility")),
                                const DataColumn(label: HeaderCell("Aging")),
                                const DataColumn(label: HeaderCell("Action")),
                              ],
                              rows: _buildDataRows(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),



                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildPagination(),
                  ),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const SizedBox.shrink(), // Remove icon if not needed
                            label: const Text(
                              "Export to CSV",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12, // Smaller font
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B7BC4),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Tighter padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6), // Slightly more rounded
                              ),
                              minimumSize: const Size(0, 36), // Limit button height
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Main button
                              ElevatedButton(
                                onPressed: () {

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1B7BC4),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      bottomLeft: Radius.circular(6),
                                    ),
                                  ),
                                  minimumSize: const Size(0, 36),
                                ),
                                child: const Text(
                                  "Bulk Update Selected",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                ),
                              ),

                              // Dropdown button (joined seamlessly)
                              Container(
                                height: 28, // your fixed height
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1B7BC4),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                                child: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'Mark as Billed') {
                                      // Handle
                                    } else if (value == 'Billing Queue') {
                                      // Handle
                                    }
                                  },
                                  color: Colors.white,
                                  offset: const Offset(-120, 28), // matches height
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20), // 🔹 smaller icon
                                  padding: EdgeInsets.zero, // 🔹 removes extra space
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      height: 40,
                                      value: 'Mark as Billed',
                                      child: Text('Mark as Billed', style: TextStyle(fontSize: 12)),
                                    ),
                                    const PopupMenuDivider(height: 1),
                                    const PopupMenuItem(
                                      height: 40,
                                      value: 'Billing Queue',
                                      child: Text('Mark as in Billing Queue', style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              )

                            ],
                          )


                        ],
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


  // Pagination
  Widget _buildPagination() {
    int currentPage = 1;
    int totalPages = 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Back button
          IconButton(
            onPressed: currentPage > 1 ? () {} : null,
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xFF1B7BC4),
            ),
          ),
          const Text(
            "Back",
            style: TextStyle(
              color: Color(0xFF1B7BC4),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),

          const SizedBox(width: 8),

          // Page numbers 1–5
          ...List.generate(5, (index) {
            int page = index + 1;
            bool isCurrent = page == currentPage;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: isCurrent
                      ? const Color(0xFF1B7BC4)
                      : Colors.grey.shade300,
                  minimumSize: const Size(36, 36),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isCurrent ? () {} : null, // Only page 1 is clickable
                child: Text(
                  "$page",
                  style: TextStyle(
                    color: isCurrent ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            );
          }),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "...",
              style: TextStyle(fontSize: 11),
            ),
          ),

          // Last page
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: null, // Disabled
              child: const Text(
                "10",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),
          const Text(
            "Next",
            style: TextStyle(
              color: Color(0xFF1B7BC4),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          IconButton(
            onPressed: currentPage < totalPages ? () {} : null,
            icon: const Icon(
              Icons.chevron_right,
              color: Color(0xFF1B7BC4),
            ),
          ),
        ],
      ),
    );
  }


  List<DataRow> _buildDataRows() {
    return List.generate(_filteredRows.length, (index) {
      final row = _filteredRows[index];
      return _dataRow(
        row[0] as String,
        row[1] as String,
        row[2] as String,
        row[3] as String,
        row[4] as String,
        row[5] as String,
        row[6] as String,
        row[7] as String,
        row[8] as Color,
        _selectedRows[index],
            (bool? value) {
          setState(() {
            _selectedRows[index] = value ?? false;
          });
        },
      );
    });
  }


  DataRow _dataRow(
      String name,
      String dos,
      String rendering,
      String supervising,
      String npi,
      String attestation,
      String billing,
      String aging,
      Color agingColor,
      bool isSelected,
      void Function(bool?) onChanged,
      ) {
    bool isBillable = billing == "Billable";
    bool isNotBilled = billing == "Not Billed";

    Color agingBgColor = aging.contains("0–3")
        ? Colors.orange[100]!
        : aging.contains("4–7")
        ? Colors.orange[200]!
        : Colors.red[100]!;

    TextStyle cellTextStyle = const TextStyle(fontSize: 12);

    return DataRow(cells: [
      DataCell(
        Transform.scale(
          scale: 0.65, // Shrink the checkbox
          child: Checkbox(
            value: isSelected,
            onChanged: onChanged,
            activeColor: Color(0xFF1B7BC4), // ✅ This changes the fill color when selected
            checkColor: Colors.white, // Optional: color of the checkmark
            side: const BorderSide(width: 1, color: Colors.black), // Optional: outline when unchecked
          ),
        ),
      ),



      DataCell(Text(name, style: cellTextStyle)),
      DataCell(Text(dos, style: cellTextStyle)),
      DataCell(Text(rendering, style: cellTextStyle)),
      DataCell(Text(supervising, style: cellTextStyle)),
      DataCell(Text(npi, style: cellTextStyle)),
      DataCell(Text(attestation, style: cellTextStyle)),
      DataCell(

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isBillable
                ? Colors.green[100]
                : isNotBilled
                ? Colors.red[100]
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            billing,
            style: TextStyle(
              fontSize: 11,
              color: isBillable
                  ? Colors.green[800]
                  : isNotBilled
                  ? Colors.red[800]
                  : Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      DataCell(

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: agingBgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            aging,
            style: TextStyle(
              fontSize: 12,
              color: agingColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      DataCell(
      Theme(
      data: Theme.of(context).copyWith(
    highlightColor: const Color(0xFFE5F1FF), // Light blue on hover/press
    ),
        child:PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, size: 20),
          color: Colors.white,
          padding: EdgeInsets.zero,
          offset: const Offset(0, 25),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          onSelected: (value) {
            if (value == "Not Billable") {
              showMarkAsNotBillableDialog(context);
            } else if (value == "Resolve Attestation") {
              showResolveAttestationRequirementDialog(context);
            }
          },
          itemBuilder: (context) => [
            _interactiveMenuItem("Not Billable"),
            _interactiveMenuItem("Resolve Attestation"),
          ],
        ),

      ),
      ) ]);
  }


  PopupMenuItem<String> _interactiveMenuItem(String text) {
    return PopupMenuItem<String>(
      value: text,
      height: 36,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }


  Widget _buildNotificationCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String buttonLabel,
        required Color cardColor,
        required Color borderColor,
        required Color buttonColor,
        required VoidCallback onPressed,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // ✅ white background
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.black, fontSize: 10)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(buttonLabel, style: const TextStyle(color: Colors.white, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

void showBillingPopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Billing Confirmation',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (context, anim1, anim2, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: FadeTransition(
          opacity: anim1,
          child: Material(
            color: Colors.white.withOpacity(0.2),
            child: ConfirmBillingDialogContent(),
          ),
        ),
      );
    },
  );
}
void Markasbilling(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Mark Encounter as Not Billable',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (context, anim1, anim2, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: FadeTransition(
          opacity: anim1,
          child: Material(
            color: Colors.white.withOpacity(0.2),
            child: MarkasbillingstatusDialogContent(),
          ),
        ),
      );
    },
  );
}
void showMarkAsNotBillableDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Mark Encounter as Not Billable',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (context, anim1, anim2, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: FadeTransition(
          opacity: anim1,
          child: Material(
            color: Colors.black.withOpacity(0.3),
            child: MarkAsNotBillableDialog(), // ✅ This now refers to the widget
          ),
        ),
      );
    },
  );
}
void showResolveAttestationRequirementDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Resolve Attestation Requirement',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (context, anim1, anim2, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: FadeTransition(
          opacity: anim1,
          child: Material(
            color: Colors.black.withOpacity(0.3),
            child:  ResolveAttestationRequirementDialog(), // ✅ Widget, not function
          ),
        ),
      );
    },
  );
}








class HeaderCell extends StatelessWidget {
  final String text;
  const HeaderCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:2, vertical: 4), // from 12/8

      decoration: BoxDecoration(
        color: const Color(0xFFE7F5FF),
        borderRadius: BorderRadius.circular(100), // Makes it pill-shaped
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

}

