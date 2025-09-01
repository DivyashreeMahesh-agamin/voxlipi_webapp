import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';

class OnboardingForm extends StatefulWidget {
  @override
  _OnboardingFormState createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<OnboardingForm> {
  final _formKey = GlobalKey<FormState>();
  List<int> facilityBlocks = [0];
  int licenseCardCount = 1;
  int npiCardCount = 1;

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String gender = 'Male';
  List<Widget> licenseCards = [];
  List<Widget> npiCards = [];

  @override
  void initState() {
    super.initState();
    licenseCards.add(buildLicenseCard(0));
    npiCards.add(buildNPICard(0));
  }


  @override
  void dispose() {
    _dobController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _pickDateOfBirth() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        _ageController.text = _calculateAge(pickedDate).toString();
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white,

      body:Scaffold(
        backgroundColor: Colors.white,
        body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Sidebar
        CollapsibleSidebar(),

    // Vertical Divider (optional)
    VerticalDivider(width: 1, thickness: 1, color: Colors.grey[300]),

    // Main Content
    Expanded(
    child: SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    "Onboarding",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 20),

                buildSection('Personal Information', [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildCustomField('First Name *', initialValue: 'John', isRequired: true),
                            SizedBox(height: 12),
                            buildCustomField('Last Name *', initialValue: 'Doe', isRequired: true),
                            SizedBox(height: 12),
                            buildGenderSelection(),

                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: buildDOBField(
                                    'Date of Birth *',
                                    controller: _dobController,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  ),
                                ),
                                SizedBox(width: 4), // Minimal spacing
                                Expanded(
                                  flex: 1,
                                  child: buildCustomField(
                                    'Age',
                                    controller: _ageController,
                                    readOnly: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  ),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ),
                      SizedBox(width: 50),
                      // Right Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildDropdownField('Preferred Contact Mode *', ['Phone', 'Email'], isRequired: true),
                            SizedBox(height: 12),
                            buildCustomField('Phone Number *', initialValue: '+1 212 555 4567', isRequired: true),


                            SizedBox(height: 12),
                            buildCustomField(
                              'Email',
                              initialValue: 'john.deo@facilitynamw.org',
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ]),

            SizedBox(height: 16),
      buildSection('Medical Group and Facility', [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medical Group Label and Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Medical Group',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                buildDropdownField('', ['Select Medical Group']),
              ],
            ),
            SizedBox(height: 20),

            // Repeated Facility Blocks
            Column(
              children: List.generate(facilityBlocks.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
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
                                      Text('Facility Type',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                      SizedBox(height: 6),
                                      buildDropdownField('', ['Group Practice']),
                                      SizedBox(height: 16),
                                      Text('Facility Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                      SizedBox(height: 6),
                                      buildDropdownField('', ['Green Valley SNF']),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                // Right Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Department',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                      SizedBox(height: 6),
                                      buildDropdownField('', ['Cardiology']),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ➖ Remove Button (Only if more than 1 block and not the first one)
                      if (facilityBlocks.length > 1)
                        Positioned(
                          top: -10,
                          right: -10,
                          child: IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                facilityBlocks.removeAt(index);
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),

            // ➕ Add Button
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 36,
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      facilityBlocks.add(facilityBlocks.length);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: CircleBorder(),
                    backgroundColor: Color(0xFF1B7BC4),
                  ),
                  child: Icon(Icons.add, size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),

      ]),
      SizedBox(height: 16),
      buildSection('Professional Credentials', [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LICENSE DETAILS
            Expanded(
              child: // Inside your widget tree (e.g., build method)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'License Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 12),

                  ...List.generate(licenseCardCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24), // spacing between cards
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Only this has the border now
                          buildLicenseCard(index),

                          // Remove button
                          if (licenseCardCount > 1)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  if (licenseCardCount > 1) {
                                    setState(() {
                                      licenseCardCount--;
                                    });
                                  }
                                },
                              ),
                            ),

                          // Add button (only on last card)
                          if (index == licenseCardCount - 1)
                            Positioned(
                              bottom: -20,
                              right: 0,
                              child: SizedBox(
                                width: 36,
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      licenseCardCount++;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: CircleBorder(),
                                    backgroundColor: Color(0xFF1B7BC4),
                                  ),
                                  child: Icon(Icons.add, size: 20, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),

            ),

            SizedBox(width: 24),

            // NPI DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NPI Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 12),

                  ...List.generate(npiCardCount, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // NPI card with a single border
                          buildNPICard(index),

                          // Remove Button
                          if (npiCardCount > 1)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  if (npiCardCount > 1) {
                                    setState(() {
                                      npiCardCount--;
                                    });
                                  }
                                },
                              ),
                            ),

                          // Add Button (only on last card)
                          if (index == npiCardCount - 1)
                            Positioned(
                              bottom: -20,
                              right: 0,
                              child: SizedBox(
                                width: 36,
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      npiCardCount++;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: CircleBorder(),
                                    backgroundColor: Color(0xFF1B7BC4),
                                  ),
                                  child: Icon(Icons.add, size: 20, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),

            ),
          ],
        ),
      ]),
      SizedBox(height: 16),

                buildSection('Billing Information', [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align content at the top
                    mainAxisAlignment: MainAxisAlignment.start,   // Align row to the left
                    children: [
                      // Column 1
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextField('Billing Contact Person'),
                          SizedBox(height: 12),
                          buildTextField('Billing Phone Number'),
                          SizedBox(height: 12),
                          buildTextField('Billing Email'),
                          SizedBox(height: 12),

                        ],
                      ),
                      SizedBox(width: 200),
                      // Column 2
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          buildTextField('Billing Name'),
                          SizedBox(height: 12),
                          buildTextField('Billing Address', maxLines: 4),
                        ],
                      ),
                    ],
                  ),
                ]),

                SizedBox(height: 16),

            buildSection('Emergency Contact', [
              buildRow([buildTextField('Name'), buildTextField('Phone Number')]),
              buildDropdownField('Relationship', ['Spouse', 'Parent', 'Sibling', 'Friend']),
            ]),

            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                    "Save as Draft",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    context.go('/Voxlipi/Ready-To-Bill');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1B7BC4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Submit ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ]),
        ),
    ))])) );
  }


  Widget buildProfessionalCredentialsSection() {
    return buildSection('Professional Credentials', [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LICENSE DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('License Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 12),
                ...licenseCards,
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: () {
                      setState(() {
                        licenseCards.add(buildLicenseCard(licenseCards.length));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 24),
          // NPI DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NPI Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 12),
                ...npiCards,
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: () {
                      setState(() {
                        npiCards.add(buildNPICard(npiCards.length));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  Widget buildLicenseCard(int index) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDropdownField('State', ['New York']),
              SizedBox(height: 12),
              buildDropdownField('License Type', ['License type']),
              SizedBox(height: 12),
              buildTextField('License Number'),
            ],
          ),
        ),
        Positioned(
          right: 4,
          top: 0,
          child: IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () {
              setState(() {
                licenseCards.removeAt(index);
              });
            },
          ),
        )
      ],
    );
  }

  Widget buildNPICard(int index) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDropdownField('NPI Type', ['Individual', 'Organization']),
              SizedBox(height: 12),
              buildTextField('NPI Number'),
            ],
          ),
        ),
        Positioned(
          right: 4,
          top: 0,
          child: IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () {
              setState(() {
                npiCards.removeAt(index);
              });
            },
          ),
        )
      ],
    );
  }


  Widget buildDropdownField(String label, List<String> options, {bool isRequired = false}) {
    String? selectedValue = options.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll(' *', ''),
            style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold,),
            children: isRequired
                ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 12))]
                : [],
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          height: 46,
          width: 300,
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            style: TextStyle(fontSize: 12, color: Colors.black ),
            items: options
                .map((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 12)),
            ))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedValue = val;
              });
            },
          ),
        ),
      ],
    );
  }
  Widget buildDOBField(
      String label, {
        required TextEditingController controller,
        EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll(' *', ''),
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold, // ← bold label
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold, // ← bold red asterisk
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          height: 46,
          width: 300,
          child: TextFormField(
            controller: controller,
            readOnly: true,
            onTap: _pickDateOfBirth,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: contentPadding,
              suffixIcon: Icon(Icons.calendar_today, size: 18),
            ),
          ),
        ),
      ],
    );
  }


  Widget buildCustomField(
      String label, {
        String? initialValue,
        TextEditingController? controller,
        bool readOnly = false,
        bool isRequired = false,
        EdgeInsets contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll(' *', ''),
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold, // <- make label bold
            ),
            children: isRequired
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold, // <- make asterisk bold too
                ),
              )
            ]
                : [],
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          height: 46,
          width: 300,
          child: TextFormField(
            readOnly: readOnly,
            initialValue: controller == null ? initialValue : null,
            controller: controller,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: contentPadding,
              filled: readOnly,
              fillColor: readOnly ? Colors.grey[300] : null,
            ),
          ),
        ),
      ],
    );
  }


  Widget buildSection(String title, List<Widget> children) {
    return Container(
      width: 1000,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget buildRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: children
            .map((child) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: child,
          ),
        ))
            .toList(),
      ),
    );
  }
  Widget buildTextField(
      String label, {
        String? initialValue,
        bool readOnly = false,
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        SizedBox(height: 4),
        SizedBox(
          width: 300, // Fixed width
          child: TextFormField(
            initialValue: initialValue,
            readOnly: readOnly,
            maxLines: maxLines,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              fillColor: readOnly ? Colors.grey[300] : null,
              filled: readOnly,
            ),
          ),
        ),
      ],
    );
  }



  Widget buildFixedWidthTextField(String label, {String? initialValue, bool readOnly = false}) {
    return SizedBox(
      width: 80,
      height: 46,
      child: TextFormField(
        readOnly: readOnly,
        initialValue: initialValue,
        style: TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 12),
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          fillColor: readOnly ? Colors.grey[300] : null,
          filled: readOnly,
        ),
      ),
    );
  }


  Widget buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Gender ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Set default text color
            ),
            children: <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(
                  color: Colors.red, // Make the asterisk red
                ),
              ),
            ],
          ),
        ),

        Row(
          children: ['Male', 'Female', 'Other'].map((g) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: g,
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() => gender = val!);
                  },
                  activeColor: Color(0xFF1B7BC4), // 🔵 Makes the radio button blue when selected
                ),

                Text(g, style: TextStyle(fontSize: 12, ),),
                SizedBox(width: 8),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }


}
