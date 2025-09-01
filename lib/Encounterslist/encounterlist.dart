import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';
import 'package:webappnursingapp/Billing/markasbilled.dart';
import 'package:webappnursingapp/Encounterslist/add%20encounter.dart';
import 'package:webappnursingapp/Encounterslist/addannotations.dart';
import 'package:webappnursingapp/Encounterslist/copyencounter.dart';
import 'package:webappnursingapp/Encounterslist/editencounter.dart';
import 'package:webappnursingapp/Encounterslist/encounterdetails.dart';

class EncounterListScreen extends StatefulWidget {
  @override
  _EncounterListScreenState createState() => _EncounterListScreenState();
}

class _EncounterListScreenState extends State<EncounterListScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _showClearIcon = false;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool isChecked1 = false;
  bool isChecked2 = false;

  late List<Map<String, dynamic>> filteredList;
  List<bool> isCheckedList = [];
  final GlobalKey _funnelKey = GlobalKey();
  OverlayEntry? _filterPopup;
  OverlayEntry? _filterSubMenu;
  bool isChecked = false;

  void _refreshData() {
    // Your refresh logic here, like calling an API or reloading from DB
    print("Refreshing data...");
  }

  final List<String> _filters = ["Date", "Facility", "Sign Status"];

  final Map<String, List<String>> _filterData = {
    "Facility": ["Clinic A", "Clinic B", "Clinic C"],
    "Sign Status": ["Signed", "Unsigned", "In Review"],
  };

  String? _selectedFacility;
  String? _selectedSignStatus;Widget _buildOptionList(String filterKey) {
    final options = _filterData[filterKey] ?? [];

    String? selectedOption = filterKey == "Facility" ? _selectedFacility : _selectedSignStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        final isSelected = option == selectedOption;
        return ListTile(
          title: Text(option),
          trailing: isSelected ? Icon(Icons.check, color: Colors.blue) : null,
          onTap: () {
            setState(() {
              if (filterKey == "Facility") {
                _selectedFacility = option;
              } else if (filterKey == "Sign Status") {
                _selectedSignStatus = option;
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFilterContent(String filterKey) {
    if (filterKey == "Date") {
      return _buildDateFilter();
    } else {
      return _buildOptionList(filterKey);
    }
  }

  String? _expandedFilter;


  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? (_fromDate ?? DateTime.now()) : (_toDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          // Optional: Ensure fromDate is not after toDate
          if (_toDate != null && _fromDate!.isAfter(_toDate!)) {
            _toDate = _fromDate;
          }
        } else {
          _toDate = picked;
          // Optional: Ensure toDate is not before fromDate
          if (_fromDate != null && _toDate!.isBefore(_fromDate!)) {
            _fromDate = _toDate;
          }
        }
      });
    }
  }

  Widget _buildDateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Date Range", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(context, true),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _fromDate != null ? _dateFormat.format(_fromDate!) : "From Date",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(context, false),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _toDate != null ? _dateFormat.format(_toDate!) : "To Date",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    filteredList = List.from(encounterList); // Start with full list

    _controller.addListener(() {
      setState(() {
        _showClearIcon = _controller.text.isNotEmpty;
        _filterEncounters(_controller.text);
      });
    });
  }

  void _filterEncounters(String query) {
    if (query.isEmpty) {
      filteredList = List.from(encounterList); // Reset to full list
    } else {
      filteredList = encounterList.where((item) {
        final name = item['name']?.toString().toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
    }
  }

  void _removeAllPopups() {
    _filterPopup?.remove();
    _filterSubMenu?.remove();
    _filterPopup = null;
    _filterSubMenu = null;
  }

  void _showFilterPopup(BuildContext outerContext) {
    _removeAllPopups();

    final renderBox = _funnelKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(outerContext);
    if (renderBox == null || overlay == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _filterPopup = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeAllPopups,
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
                  border: Border.all(color: const Color(0xFF1B7BC4), width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _filters.map((filter) {
                    final index = _filters.indexOf(filter);
                    return GestureDetector(
                      onTap: () {
                        final topOffset = position.dy + size.height + 5 + (index * 40);
                        // Pass outerContext here!
                        _showFilterSubMenu(outerContext, filter, Offset(position.dx, topOffset));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(filter, style: const TextStyle(fontSize: 12))),
                            const Icon(Icons.chevron_right, size: 16),
                          ],
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

  void _showFilterSubMenu(BuildContext outerContext, String filter, Offset basePosition) {
    _filterSubMenu?.remove();
    final overlay = Overlay.of(outerContext);
    if (overlay == null) return;

    final allOptions = _filterData[filter] ?? [];
    List<String> filteredOptions = List.from(allOptions);
    final searchController = TextEditingController();

    // Track checkbox states
    Map<String, bool> selectedOptions = {
      for (var option in allOptions) option: false
    };

    // Track hover state
    String? hoveredOption;

    // Track selected dates for "Date" filter
    DateTime? fromDate;
    DateTime? toDate;

    _filterSubMenu = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickFromDate() async {
              final picked = await showDatePicker(
                context: outerContext,
                initialDate: fromDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  fromDate = picked;
                  // Optional: Clear toDate if before fromDate
                  if (toDate != null && toDate!.isBefore(fromDate!)) {
                    toDate = null;
                  }
                });
              }
            }

            Future<void> pickToDate() async {
              final picked = await showDatePicker(
                context: outerContext,
                initialDate: toDate ?? DateTime.now(),
                firstDate: fromDate ?? DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  toDate = picked;
                });
              }
            }

            return Positioned(
              left: basePosition.dx + 180,
              top: basePosition.dy,
              child: Material(
                elevation: 6,
                color: Colors.transparent,
                child: Container(
                  width: 240,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF1B7BC4), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (filter == "Date") ...[
                        // Remove search bar for Date filter
                        Text('From Date:', style: TextStyle(fontSize: 12)),
                        GestureDetector(
                          onTap: pickFromDate,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              fromDate != null
                                  ? "${fromDate!.toLocal()}".split(' ')[0]
                                  : 'Select From Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: fromDate != null ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Text('To Date:', style: TextStyle(fontSize: 12)),
                        GestureDetector(
                          onTap: pickToDate,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              toDate != null
                                  ? "${toDate!.toLocal()}".split(' ')[0]
                                  : 'Select To Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: toDate != null ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        // Show search bar and filtered checkbox list for other filters
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Search",
                              hintStyle: const TextStyle(fontSize: 12),
                              prefixIcon: const Icon(Icons.search, size: 16),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    filteredOptions = List.from(allOptions);
                                  });
                                },
                              )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                filteredOptions = allOptions
                                    .where((option) => option.toLowerCase().contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (filteredOptions.isEmpty)
                          const Text("No results", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ...filteredOptions.map((option) {
                          final isSelected = selectedOptions[option] ?? false;
                          return Transform.scale(
                            scale: 0.8,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.basic,
                              onEnter: (_) => setState(() => hoveredOption = option),
                              onExit: (_) => setState(() => hoveredOption = null),
                              child: Container(
                                color: hoveredOption == option ? const Color(0xFFE3F2FD) : Colors.transparent,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isSelected,
                                      activeColor: const Color(0xFF1B7BC4),
                                      onChanged: (val) {
                                        setState(() {
                                          selectedOptions[option] = val ?? false;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 4),
                                    Text(option, style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
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


  @override
  void dispose() {
    _removeAllPopups();
    _controller.dispose();
    super.dispose();
  }
  final List<Map<String, dynamic>> encounterList = [
    {
      "name": "Johnathan Miller",
      "gender": "M",
      "dob": "03/14/1955",
      "facility": "Brookline Rehab Center",
      "encounters": [
        {
          "date": "06/10/2025",
          "visitType": "Follow-Up",
          "draftStatus": "Draft",
          "billingStatus": "Queue",
          "provider": "Dr. Lisa Raymond"
        },
        {
          "date": "06/01/2025",
          "visitType": "Initial Eval",
          "draftStatus": "Submitted",
          "billingStatus": "Ready",
          "provider": "Dr. Lisa Raymond"
        },
        {
          "date": "05/20/2025",
          "visitType": "Follow-Up",
          "draftStatus": "Signed",
          "billingStatus": "Billed",
          "provider": "Dr. Lisa Raymond"
        },
      ]
    },
  ];
  void EncounterPopup(BuildContext context, Map<String, dynamic> rowData) {
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
              child: ConfirmBillingDialogContent1(data: rowData), // ✅ FIXED

            ),
          ),
        );
      },
    );
  }

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

          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Encounter List",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Search & Actions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 280,
                        height: 40,
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _showClearIcon
                                ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                setState(() {
                                  _showClearIcon = false;
                                  filteredList = List.from(encounterList); // Reset list
                                });
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
                        icon: const Icon(Icons.filter_alt, size: 20),
                        onPressed: () {
                          _showFilterPopup(context); // ✅ This is correct
                        },
                      ),
                      IconButton(
                        iconSize: 20,
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          showCustomToast(context, "Refreshed");

                        },
                      ),


                    ],
                  ),



                  const SizedBox(height: 24),

                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,

                      itemBuilder: (context, index) {
                        final item = filteredList[index];

                        final encounters = item['encounters'] as List<dynamic>;

                        return Container(
                          width: 300,
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 900, // 👈 Set container/card width here
                              child: Card(
                                color: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center, // align checkbox & text vertically
                                              children: [
                                                Transform.scale(
                                                  scale: 0.8,
                                                  child: Checkbox(
                                                    value: isChecked1,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isChecked1 = value ?? false;
                                                      });
                                                    },
                                                    activeColor: Color(0xFF1B7BC4),
                                                    checkColor: Colors.white,
                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                                  ),
                                                ),
                                                const SizedBox(width: 6), // gap between checkbox and text

                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(color: Colors.black, fontSize: 12),
                                                      children: [
                                                        // Name
                                                        const TextSpan(
                                                          text: 'Name: ',
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                                        ),
                                                        TextSpan(text: item['name']),
                                                        TextSpan(text: ' (${item['gender']})'),

                                                        // Space between Name and DOB section
                                                        const WidgetSpan(child: SizedBox(width: 20)),

                                                        // DOB
                                                        const TextSpan(
                                                          text: 'DOB: ',
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                                        ),
                                                        TextSpan(text: item['dob']),

                                                        // Space between DOB and Facility section
                                                        const WidgetSpan(child: SizedBox(width: 20)),

                                                        // Facility
                                                        const TextSpan(
                                                          text: 'Facility: ',
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                                        ),
                                                        TextSpan(text: item['facility']),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),


                                          const SizedBox(width: 6),

                                          // Add Encounter Button
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              context.go('/Voxlipi/AddEncounter');
                                            },
                                            icon: const Icon(Icons.list_alt, size: 18, color: Colors.white),
                                            label: const Icon(Icons.add, size: 18, color: Colors.white),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF1B7BC4),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                              minimumSize: const Size(0, 36),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                          ),
                                        ],
                                      ),


                                      const SizedBox(height: 16),

                                      // First Table


                                      DataTable(
                                        headingRowColor: MaterialStateProperty.all(Color(0xFFe6f2fb)),
                                        headingTextStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        dataTextStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                        columns: const [
                                          DataColumn(label: Text('Date')),
                                          DataColumn(label: Text('Visit Type')),
                                          DataColumn(label: Text('Draft Status')),
                                          DataColumn(label: Text('Billing Status')),
                                          DataColumn(label: Text('Rendering Provider')),
                                          DataColumn(label: Text('Action')),
                                        ],
                                        rows: encounters.map<DataRow>((row) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(row['date']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(Text(row['visitType']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(Text(row['draftStatus']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(Text(row['billingStatus']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(Text(row['provider']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(
                                                PopupMenuButton<String>(
                                                  icon: const Icon(Icons.more_horiz, size: 16, color: Colors.black),
                                                  color: Colors.white,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    side: const BorderSide(color: Colors.white),
                                                  ),
                                                  onSelected: (value) {
                                                    if (value == 'edit') {
                                                      context.go('/Voxlipi/EditEncounter');
                                                    } else if (value == 'Copy') {
                                                      context.go('/Voxlipi/CopyEncounter');
                                                    }
                                                  },
                                                  itemBuilder: (context) => const [
                                                    PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(fontSize: 12))),
                                                    PopupMenuItem(value: 'Copy', child: Text('Copy', style: TextStyle(fontSize: 12))),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      const Divider(
                                        thickness: 2,
                                        color: Colors.grey,
                                        height: 32, // space between tables
                                      ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center, // ✅ align vertically
                                      children: [
                                        // Checkbox
                                        Transform.scale(
                                          scale: 0.8,
                                          child: Checkbox(
                                            value: isChecked2,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked2 = value ?? false;
                                              });
                                            },
                                            activeColor: Color(0xFF1B7BC4),
                                            checkColor: Colors.white,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        // Patient Info
                                        Expanded(
                                          child: RichText(
                                            text: const TextSpan(
                                              style: TextStyle(color: Colors.black, fontSize: 12),
                                              children: [
                                                // Name
                                                TextSpan(
                                                  text: 'Name: ',
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                                ),
                                                TextSpan(text: 'Marie Johnson'),
                                                TextSpan(text: ' (Female)'),

                                                // Space before DOB
                                                WidgetSpan(child: SizedBox(width: 30)),

                                                // DOB
                                                TextSpan(
                                                  text: 'DOB: ',
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                                ),
                                                TextSpan(text: '10/02/1940'),

                                                // Space before Facility
                                                WidgetSpan(child: SizedBox(width: 30)),

                                                // Facility
                                                TextSpan(
                                                  text: 'Facility: ',
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                                ),
                                                TextSpan(text: 'Aspen Grove SNF'),
                                              ],
                                            ),
                                          ),
                                        ),


                                        const SizedBox(width: 6),

                                        // Add Encounter Button
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            context.go('/Voxlipi/AddEncounter');
                                          },
                                          icon: const Icon(Icons.list_alt, size: 18, color: Colors.white),
                                          label: const Icon(Icons.add, size: 18, color: Colors.white),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF1B7BC4),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                            minimumSize: const Size(0, 36),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                      ],
                                    ),


                                    const SizedBox(height: 20),

                                      DataTable(
                                        headingRowColor: MaterialStateProperty.all(Color(0xFFe6f2fb)),
                                        headingTextStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        dataTextStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                        columns: const [
                                          DataColumn(label: Text('Date')),
                                          DataColumn(label: Text('Visit Type')),
                                          DataColumn(label: Text('Draft Status')),
                                          DataColumn(label: Text('Billing Status')),
                                          DataColumn(label: Text('Rendering Provider')),
                                          DataColumn(label: Text('Action')),
                                        ],
                                        rows: encounters.map<DataRow>((row) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(row['date']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(Text(row['visitType']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(Text(row['draftStatus']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(Text(row['billingStatus']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(Text(row['provider']), onTap: () => EncounterPopup(context, row)),
                                              DataCell(
                                                PopupMenuButton<String>(
                                                  icon: const Icon(Icons.more_horiz, size: 16, color: Colors.black),
                                                  color: Colors.white,
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    side: const BorderSide(color: Colors.white),
                                                  ),
                                                  onSelected: (value) {
                                                    if (value == 'edit') {
                                                      context.go('/Voxlipi/EditEncounter');
                                                    } else if (value == 'Copy') {
                                                      context.go('/Voxlipi/CopyEncounter');
                                                    }
                                                  },
                                                  itemBuilder: (context) => const [
                                                    PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(fontSize: 12))),
                                                    PopupMenuItem(value: 'Copy', child: Text('Copy', style: TextStyle(fontSize: 12))),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildPagination(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
  }}
void showCustomToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 40,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFCFF5CC),
            borderRadius: BorderRadius.circular(12),
          ),
          width: 320,
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Remove after 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

