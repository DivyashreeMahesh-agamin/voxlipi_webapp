import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webappnursingapp/Billing/Patientlist/addpatient.dart';
import 'package:webappnursingapp/Billing/Patientlist/editpatient.dart';

import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final LayerLink _layerLink = LayerLink();
  final LayerLink _filterIconLink = LayerLink();
  final LayerLink _firstPopupLink = LayerLink();
  final List<String> patients = [
    "Johnathan Miller",
    "Jane Smith",
    "Robert Johnson",
  ];

  OverlayEntry? _firstPopup;
  OverlayEntry? _secondPopup;
 // for positioning second popup



  final List<String> filterCategories = ['Name', 'Visit Date', 'Status'];
  final Map<String, List<String>> filterOptions = {
    'Name': ['A-Z', 'Z-A'],
    'Visit Date': ['Newest First', 'Oldest First'],
    'Status': ['Active', 'Inactive'],
  };
  List<String> _getOptionsForCategory(String category) {
    switch (category) {
      case 'Name':
        return ['A-Z', 'Z-A'];
      case 'Visit Date':
        return ['Latest First', 'Oldest First'];
      case 'Status':
        return ['Active', 'Inactive'];
      default:
        return [];
    }
  }


  String? selectedCategory;

  void _showFilterPopup(BuildContext context) {
    _removePopups();

    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _firstPopup = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent, // Captures outside taps
        onTap: () => _removePopups(),
        child: Stack(
          children: [
            Positioned(
              top: offset.dy + 40,
              left: offset.dx,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: Offset(0, 0),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 8),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filterCategories.map((cat) {
                        return ListTile(
                          title: Text(cat),
                          trailing: Icon(Icons.arrow_right),
                          onTap: () {
                            _showSecondPopup(context, cat, offset);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_firstPopup!);
  }

  void _showSecondPopup(BuildContext context, String category, Offset offset) {
    _secondPopup?.remove(); // Remove previous second popup if any

    final List<String> options = _getOptionsForCategory(category); // Your logic to fetch options

    _secondPopup = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + 40,
        left: offset.dx - 200 - 4, // 👈 Subtract width of second popup + spacing (e.g., 180 + 4)
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((opt) {
                return ListTile(
                  title: Text(opt),
                  onTap: () {
                    print("Selected $opt");
                    _removePopups();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_secondPopup!);
  }

  void _removePopups() {
    _firstPopup?.remove();
    _secondPopup?.remove();
    _firstPopup = null;
    _secondPopup = null;
  }

  @override
  void dispose() {
    _removePopups();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SafeArea(
        child: Row(
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
                      "Patient List",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 280,
                          height: 40, // Reduced height
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: const Icon(Icons.search, size: 20), // Optional: smaller icon
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              isDense: true, // Reduces vertical space
                              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Adjust padding
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        CompositedTransformTarget(
                          link: _layerLink,
                          child: IconButton(
                            icon: Icon(Icons.filter_alt, size: 24),
                            onPressed: () => _showFilterPopup(context),
                          ),
                        ),
                        IconButton(
                          iconSize: 20,
                          icon: const Icon(Icons.refresh),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 34),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B7BC4),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            context.go('/Voxlipi/Add-Patient');
                          },
                          child: const Text("Add Patient"),
                        ),
                        const SizedBox(width: 12), // spacing between button and icon
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF1B7BC4),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.sync,
                                color: Color(0xFF1B7BC4),
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Data Table Container
                    // Data Table Container
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9), // Light grey background with opacity
                        border: Border.all(color: Colors.grey.shade400, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F4FB),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.9),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: _buildTableHeader(),
                            ),
                            const Divider(height: 1),

                            // Table Rows
                            _buildTableRow(
                                context,
                                "Johnathan Miller",
                                "PAT123456",
                                "Male",
                                "03/14/1955",
                                "06/06/2025",
                                "Follow-Up",
                                "Active",
                                "Brookline Rehab Center"),
                            const Divider(height: 1),
                            _buildTableRow(
                                context,
                                "Marie Johnson",
                                "PAT987654",
                                "Female",
                                "10/02/1940",
                                "05/25/2025",
                                "Initial Eval",
                                "Discharged",
                                "Aspen Grove SNF"),
                            const Divider(height: 1),
                            _buildTableRow(
                                context,
                                "Elijah Thompson",
                                "PAT456789",
                                "Male",
                                "07/08/1972",
                                "06/01/2025",
                                "Follow-Up",
                                "Active",
                                "Greenwood Nursing Home"),
                          ],
                        ),
                      ),
                    ),



                    const SizedBox(height: 24),

                    // Pagination Controls
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
      ),
    );
  }
  Widget _buildTableHeader() {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    return Row(
      children: const [
        Expanded(flex: 2, child: Text("Name", style: style)),
        Expanded(child: Text("Patient ID", style: style)),
        Expanded(child: Text("Gender", style: style)),
        Expanded(child: Text("Date of Birth", style: style)),
        Expanded(child: Text("Last Visit", style: style)),
        Expanded(child: Text("Visit Type", style: style)),
        Expanded(child: Text("Status", style: style)),
        Expanded(flex: 2, child: Text("Facility", style: style)),
        SizedBox( // Match the row icon container
          width: 32,
          child: Icon(Icons.more_horiz, color: Colors.transparent), // invisible icon to maintain space
        ),
      ],
    );
  }
  Widget _buildTableRow(
      BuildContext context,
      String name,
      String id,
      String gender,
      String dob,
      String lastVisit,
      String visitType,
      String status,
      String facility,
      ) {
    const style = TextStyle(fontSize: 12);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => PatientDetailsDialog(name: name), // Use passed name here
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(name, style: style)),
            Expanded(child: Text(id, style: style)),
            Expanded(child: Text(gender, style: style)),
            Expanded(child: Text(dob, style: style)),
            Expanded(child: Text(lastVisit, style: style)),
            Expanded(child: Text(visitType, style: style)),
            Expanded(child: Text(status, style: style)),
            Expanded(flex: 2, child: Text(facility, style: style)),
            SizedBox(
              width: 32,
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;

                  showMenu(
                    context: context,
                    position: RelativeRect.fromRect(
                      details.globalPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    items: const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit', style: TextStyle(color: Colors.black)),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    color: Colors.white,
                    elevation: 4,
                  ).then((value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Editpatient()),
                      );
                    } else if (value == 'delete') {
                      _showDeleteConfirmationDialog(context, 'Patient', name);
                    }
                  });
                },
                child: const Icon(Icons.more_horiz),
              ),
            ),
          ],
        ),
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
              fontSize: 12, // 🔽 Reduced font size
            ),
          ),

          const SizedBox(width: 8),

          // Page numbers
          ...List.generate(5, (index) {
            int page = index + 1;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: currentPage == page
                      ? const Color(0xFF1B7BC4)
                      : Colors.blue.shade50,
                  minimumSize: const Size(36, 36),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Handle page change
                },
                child: Text(
                  "$page",
                  style: TextStyle(
                    color: currentPage == page
                        ? Colors.white
                        : const Color(0xFF1B7BC4),
                    fontWeight: FontWeight.w600,
                    fontSize: 11, // 🔽 Reduced font size
                  ),
                ),
              ),
            );
          }),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "...",
              style: TextStyle(fontSize: 11), // 🔽 Reduced font size
            ),
          ),

          // Last page
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Navigate to last page
              },
              child: const Text(
                "10",
                style: TextStyle(
                  color: Color(0xFF1B7BC4),
                  fontSize: 11, // 🔽 Reduced font size
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
              fontSize: 12, // 🔽 Reduced font size
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



}
void _showDeleteConfirmationDialog(BuildContext context, String objectType, String objectName) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismiss by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),


            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, size: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '“Are you sure you want to delete the  ‘$objectName’ ”',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                SizedBox(width: 6),
                Text(
                  'Note: This action cannot be undone.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12), // Spacing between buttons
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Perform delete action here
                    print("Deleted $objectType: $objectName");
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],

      );
    },
  );
}


class PatientDetailsDialog extends StatelessWidget {
  final String name;

  const PatientDetailsDialog({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 700,
          maxHeight: MediaQuery.of(context).size.height * 0.95,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dialogHeader(context),
              const SizedBox(height: 20),
              _borderedSection(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard("Patient Name", name),
                  _buildInfoCard("Last Visit", "06/06/2025"),
                  _buildInfoCard("Visit Type", "Brookline Rehab Center"),
                  _buildInfoCard("Facility", "Follow-Up"),
                ],
              )),
              const SizedBox(height: 10),
              _borderedSection(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Demographic"),
                  const SizedBox(height: 10),
                  _buildKeyValue("DOB", "03/14/1955"),
                  _buildKeyValue("Age", "70"),
                  _buildKeyValue("Gender", "Male"),
                  _buildKeyValue("Contact", "+1 – 565 – 456 – 7890"),
                  _buildKeyValue("Address", "124 Maple Dr, Brookline, MA"),
                ],
              )),
              const SizedBox(height: 10),
              _borderedSection(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Medication List"),
                  const SizedBox(height: 10),
                  _buildValue("Lisinopril 10mg PO once daily"),
                  _buildValue("Metformin 500mg PO twice daily"),
                  _buildValue("Simvastatin 20mg at bedtime"),
                ],
              )),
              const SizedBox(height: 10),
              _borderedSection(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Diagnoses"),
                  const SizedBox(height: 10),
                  _buildKeyValue("I10", "Essential Hypertension"),
                  _buildKeyValue("E11", "Type 2 Diabetes without complications"),
                ],
              )),
              const SizedBox(height: 10),
              _borderedSection(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Allergies"),
                  const SizedBox(height: 10),
                  _buildKeyValue("Penicillin", "Rash"),
                  _buildKeyValue("Latex", "Anaphylaxis"),
                ],
              )),
              const SizedBox(height: 10),
              _borderedSection(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Plan"),
                  const SizedBox(height: 10),
                  _buildKeyValue("Plan", "Medicare Advantage – BlueShield"),
                  _buildKeyValue("Member ID", "9823346578"),
                  _buildKeyValue("Eligibility", "Verified"),
                ],
              )),
              const SizedBox(height: 20),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black), // black border
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Patient Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Fixed width for label
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16), // Space between label and value
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


  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildKeyValue(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // same width as _buildInfoCard
            child: Text(
              key,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
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

  Widget _buildValue(String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 2),
      child: Text("• $value", style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _borderedSection(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

