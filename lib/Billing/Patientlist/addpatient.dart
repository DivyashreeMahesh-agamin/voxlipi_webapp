import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:webappnursingapp/Billing/Patientlist/duplicatepatientcheck.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';

class AddPatientPage extends StatefulWidget {
  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {

  List<Map<String, dynamic>> insuranceList = [
    {
      "plan": "Medicare Advantage–Aetna",
      "memberId": "MA123456789",
      "status": "Currently Admitted",
      "isPrimary": true,
    }
  ];
  String? calculatedAge;

  bool isAllergyChecked = false;
  int selectedGender = 0;
  List<String> facesheetFiles = ["facesheet_jh.pdf"];
  List<String> otherDocuments = ["id_card.jpg", "photo_name.jpg"];
  DateTime? selectedDate;

  String? selectedAllergen;
  String? selectedReaction;
  String? selectedSeverity;
  String? selectedAllergyType;
  List<String> diagnoses = ["E11.9 - Types 2 Diabetes"];
  List<Allergy> allergyList = [Allergy()];
  final List<String> diagnosisOptions = [
    "E11.9 - Types 2 Diabetes",
    "E10.9 - Types 1 Diabetes",
    "I10 - Hypertension",
    "J45 - Asthma",
    "J44.9 - COPD",
    "Other"
  ];


  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        final now = DateTime.now();
        final difference = now.difference(picked);
        final totalMonths = (now.year - picked.year) * 12 + now.month - picked.month;

        if (difference.inDays < 365) {
          // Show in months if less than 1 year
          final months = totalMonths - (now.day < picked.day ? 1 : 0);
          calculatedAge = '$months month${months == 1 ? '' : 's'}';
        } else {
          // Show in years if 1 year or more
          int ageYears = now.year - picked.year;
          if (now.month < picked.month ||
              (now.month == picked.month && now.day < picked.day)) {
            ageYears--;
          }
          calculatedAge = '$ageYears year${ageYears == 1 ? '' : 's'}';
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          CollapsibleSidebar(),

          // Vertical Divider
          VerticalDivider(width: 1, thickness: 1, color: Colors.grey[300]),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    "Add Patient",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Content
                  Center(
                    child: ConstrainedBox(

                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection("Patient Details", _buildPatientDetailsSection()),
                          _buildSection("Address", _Address()),
                          _buildSection("Facility Details", _buildFacilityDetails()),
                          _buildSection("Insurance Details", _buildInsuranceDetails()),
                          _buildSection("Diagnoses Details", _buildDiagnosisSection()),
                          _buildSection("Allergies", _buildAllergyDetails()),
                          _buildSection("Documentations", _buildDocumentationSection()),

                          const SizedBox(height: 24),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _Address() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Street Address", isRequired: true),
              const SizedBox(height: 4),
              _buildTextField(hint: "Enter Address1"),
              const SizedBox(height: 12),
              _buildTextField(hint: "Enter Address (Optional)"),
              const SizedBox(height: 16),
              _buildLabel("State", isRequired: true),
              const SizedBox(height: 4),
              _buildDropdown(["California", "Texas", "New York"], hint: "Select State"),
              const SizedBox(height: 16),
              _buildLabel("City", isRequired: true),
              const SizedBox(height: 4),
              _buildDropdown(["Los Angeles", "Dallas", "New York City"], hint: "Select City"),
            ],
          ),
        ),

        const SizedBox(width: 12), // ✅ Gap same as _buildFacilityDetails

        // Right Column (ZIP Code)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("ZIP Code", isRequired: true),
              const SizedBox(height: 4),
              SizedBox(
                width: 300,
                height: 46, // ✅ Match field height
                child: TextFormField(
                  style: TextStyle(fontSize: 12), // 👈 Reduced font size
                  decoration: const InputDecoration(
                    hintText: "Enter ZIP Code",
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(),
                  ),
                ),

              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildLabel(String text, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black),
        children: isRequired
            ? [const TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 10))]
            : [],
      ),
    );
  }

  Widget _buildTextField({required String hint}) {
    return SizedBox(
      width: 300,
      height: 46,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
  Widget _buildTextField1({
    required String label,
    required String hint,
    bool isRequired = false,
  }) {
    return SizedBox(
      width: 300,
      height: 106,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Colors.black,
              ),
              children: isRequired
                  ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 10),
                ),
              ]
                  : [],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 46,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              ),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDropdown(List<String> items, {required String hint}) {
    return SizedBox(
      width: 300,
      height: 46,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        hint: Text(hint, style: const TextStyle(fontSize: 12)),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
        onChanged: (value) {},
        iconSize: 18,
      ),
    );
  }


  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {
            context.pop();
            },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1B7BC4),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Save & New",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const DuplicatePatientDialog(),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B7BC4),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )

      ],
    );
  }


  Widget _buildSection(String title, Widget content) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 16),
          content,
        ]),
      ),
    );
  }

  Widget _buildPatientDetailsSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column 1: First Name + Last Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabeledField("First Name *", hint: "John", width: 300, fontSize: 12),
              SizedBox(height: 12),
              _buildLabeledField("Last Name *", hint: "Doe", width: 300, fontSize: 12),
            ],
          ),
        ),
        SizedBox(width: 5),
        // Column 2: DOB + Age + Gender
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DOB + Age
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // DOB
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Date of Birth',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black),
                            children: [
                              TextSpan(
                                  text: ' *',
                                  style: TextStyle(color: Colors.red, fontSize: 12)),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => _pickDate(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black87),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedDate != null
                                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                                      : 'DD/MM/YYYY',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Icon(Icons.calendar_today_outlined, size: 14, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  // Age
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Age", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 100,
                        height: 32,
                        child: TextFormField(
                          enabled: false,
                          controller: TextEditingController(
                              text: calculatedAge?.toString() ?? ''),
                          style: TextStyle(color: Colors.black, fontSize: 12),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Gender
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Gender',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 12),
                      children: [
                        TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 12)),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      _buildRadio("Male", 0),
                      _buildRadio("Female", 1),
                      _buildRadio("Others", 2),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildLabeledField(String label,
      {String? hint, double width = 1000, double fontSize = 12}) {
    final isRequired = label.contains('*');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: isRequired ? label.replaceAll('*', '').trim() : label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
                color: Colors.black),
            children: isRequired
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: fontSize),
              ),
            ]
                : [],
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          width: width,
          height: 32,
          child: TextFormField(
            style: TextStyle(fontSize: fontSize),
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildRadio(String label, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: value,
          groupValue: selectedGender,
          onChanged: (val) => setState(() => selectedGender = val!),
          activeColor: Color(0xFF1B7BC4), // Blue radio when selected
          visualDensity: VisualDensity.compact, // Optional: tighter spacing
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12), // Smaller font size
        ),
      ],
    );
  }


  Widget _buildFacilityDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Facility Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Facility Name',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: 10)),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 36,
                    width: 300,// Reduced height
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      value: "Greenwood Nursing Home",
                      items: [
                        DropdownMenuItem(
                          value: "Greenwood Nursing Home",
                          child: Text("Greenwood Nursing Home",
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                      onChanged: (value) {},
                      style: TextStyle(fontSize: 12),
                      iconSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Facility ID
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Facility ID",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black)),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 36,
                    width: 300,// Reduced height
                    child: TextFormField(
                      enabled: false,
                      initialValue: "GN–5647",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsuranceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8), // Slight top spacing
        ...insuranceList.asMap().entries.map((entry) {
          int index = entry.key;
          var insurance = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0), // 👈 Reduced vertical gap
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField1(
                              label: "Insurance Plan",
                              hint: "",
                              isRequired: false,
                            ),
                            const SizedBox(height: 2),
                            _buildDropdownField1(
                              label: "Admission Status",
                              hint: "Select Status",
                              items: ["Currently Admitted", "Discharged", "Pending"],
                              isRequired: false,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Right Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: _buildTextField1(
                                    label: "Member ID",
                                    hint: "Enter Member ID",
                                    isRequired: false,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (insuranceList.length > 1)
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      insuranceList.removeAt(index);
                                      setState(() {});
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Text("Primary Payer",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                Transform.scale(
                                  scale: 0.75,
                                  child: Switch(
                                    value: insurance["isPrimary"],
                                    onChanged: (value) {
                                      insurance["isPrimary"] = value;
                                      setState(() {});
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: Color(0xFF1B7BC4),
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text("Secondary Payer",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                Transform.scale(
                                  scale: 0.75,
                                  child: Switch(
                                    value: !insurance["isPrimary"],
                                    onChanged: (value) {
                                      insurance["isPrimary"] = !value;
                                      setState(() {});
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: Color(0xFF1B7BC4),
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),

        // ➕ Add Button aligned to the right
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () {
              insuranceList.add({"isPrimary": true});
              setState(() {});
            },
            icon: const Icon(
              Icons.add_circle,
              color: Color(0xFF1B7BC4),
              size: 32, // Increased size
            ),
            tooltip: 'Add Insurance',
          ),
        ),
      ],
    );
  }


// 🔹 Helper method for text fields


  Widget _buildDisabledField(String label, String value,
      {double fontSize = 12, double height = 48,double width=300}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
                color: Colors.black)),
        SizedBox(height: 4),
        SizedBox(
          height: height,
          child: TextFormField(
            enabled: false,
            initialValue: value,
            style: TextStyle(color: Colors.black, fontSize: fontSize),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildDiagnosisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Diagnoses",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        const SizedBox(height: 8),

        ...diagnoses.asMap().entries.map((e) {
          final isLast = e.key == diagnoses.length - 1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8), // Reduced vertical spacing
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TextField with search icon + "+" icon
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 38,
                      width: 300,
                      child: TextFormField(
                        controller: TextEditingController(text: e.value),
                        onChanged: (val) {
                          diagnoses[e.key] = val;
                        },
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, size: 16),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),

                    // "+" icon only under last field
                    if (isLast)
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              diagnoses.add("");
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1B7BC4),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.add, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 8),

                // Remove icon
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      diagnoses.removeAt(e.key);
                    });
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
  Widget _buildAllergyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "No Known Allergies" Checkbox
        Row(
          children: [
            Checkbox(
              value: isAllergyChecked,
              onChanged: (val) => setState(() => isAllergyChecked = val!),
            ),
            const Text("No Known Allergies", style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),

        // Allergy cards
        ...allergyList.asMap().entries.map((entry) {
          int index = entry.key;
          Allergy allergy = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Stack(
                children: [
            Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Row 1: Allergen & Reaction
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledDropdown(
                        "Allergy Type",
                        ["Food"],
                        selectedValue: allergy.allergyType,
                        onChanged: (val) {
                          setState(() => allergyList[index].allergyType = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildLabeledDropdown(
                        "Reaction",
                        ["Hives"],
                        selectedValue: allergy.reaction,
                        onChanged: (val) {
                          setState(() => allergyList[index].reaction = val);
                        },
                      ),
                    ),


                  ],
                ),
                const SizedBox(height: 12),
                // Row 2: Severity & Allergy Type
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledDropdown(
                        "Allergen",
                        ["Latex"],
                        selectedValue: allergy.allergen,
                        onChanged: (val) {
                          setState(() => allergyList[index].allergen = val);
                        },
                      ),
                    ),

                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildLabeledDropdown(
                        "Severity",
                        ["Mild"],
                        selectedValue: allergy.severity,
                        onChanged: (val) {
                          setState(() => allergyList[index].severity = val);
                        },
                      ),
                    ),


                  ],
                ),
              ],
            ),
          ),

          // ❌ Remove Icon (top right)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: allergyList.length > 1
                        ? IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          allergyList.removeAt(index);
                        });
                      },
                    )
                        : const SizedBox.shrink(), // empty widget if only one entry
                  ),

                ],
          ),
          );
        }).toList(),

        // ➕ Add Allergy Button
        Align(
          alignment: Alignment.centerLeft, // Change to .centerRight if needed
          child: RawMaterialButton(
            onPressed: () {
              setState(() {
                allergyList.add(Allergy());
              });
            },
            fillColor: const Color(0xFF1B7BC4),
            shape: const CircleBorder(),
            constraints: const BoxConstraints.tightFor(
              width: 30,  // Diameter
              height: 30,
            ),
            elevation: 2.0,
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),

      ],
    );
  }


  Widget _buildDropdownField1({
    required String label,
    required String hint,
    required List<String> items,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? "$label *" : label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 36,
          width: 300,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            hint: Text(hint, style: const TextStyle(fontSize: 12)),
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 12))))
                .toList(),
            onChanged: (_) {},
          ),
        ),
      ],
    );
  }


  Widget _buildDropdownField(String label, List<String> items,
      {double fontSize = 12, double height = 48, double width = double.infinity}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll(' *', ''),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
                color: Colors.black),
            children: label.contains('*')
                ? [
              TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: fontSize))
            ]
                : [],
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          height: height,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            style: TextStyle(fontSize: fontSize),
            iconSize: 18,
            value: items.first,
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: TextStyle(fontSize: fontSize)),
            ))
                .toList(),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledDropdown(
      String label,
      List<String> items, {
        String? selectedValue,
        void Function(String?)? onChanged,
      }) {
    // Ensure the selected value is in the items list or null
    final validSelectedValue =
    (selectedValue != null && items.contains(selectedValue))
        ? selectedValue
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const SizedBox(height: 4),
        SizedBox(
          height: 36,
          width: 300,
          child: DropdownButtonFormField<String>(
            value: validSelectedValue,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            style: const TextStyle(fontSize: 12, color: Colors.black),
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildDocumentationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocumentUploadSection("Upload Facesheet", facesheetFiles),
        const SizedBox(height: 12),
        _buildDocumentUploadSection("Upload Other Documents", otherDocuments),
      ],
    );
  }

  Widget _buildDocumentUploadSection(String title, List<String> files) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and attach icon
          Row(
            children: [
              SizedBox(
                width: 200, // Reduced width
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1B7BC4),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(5), // Slightly smaller
                child: const Icon(Icons.attach_file, color: Colors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // File list
          ...files.map((file) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: 300, // Reduced width
              decoration: BoxDecoration(
                color: const Color(0xFFD6E8F5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 30, // Reduced height
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          file,
                          style: const TextStyle(fontSize: 11, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    iconSize: 16,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      // Handle remove logic
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
class Allergy {
  String? allergen;
  String? reaction;
  String? severity;
  String? allergyType;

  Allergy({this.allergen, this.reaction, this.severity, this.allergyType});
}
