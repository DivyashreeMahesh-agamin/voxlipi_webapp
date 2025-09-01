import 'package:flutter/material.dart';
import 'package:webappnursingapp/Billing/Patientlist/sidebar.dart';
class EditEncounterPage extends StatefulWidget {
  const EditEncounterPage({super.key});

  @override
  _EditEncounterPageState createState() => _EditEncounterPageState();
}

class _EditEncounterPageState extends State<EditEncounterPage> {
  String selectedVisitType = 'Initial Eval';
  String selectedGender = '';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [

          // Divider
          CollapsibleSidebar(),

          // Divider
          VerticalDivider(width: 5, thickness: 3, color: Colors.grey[300]),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 19),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Text(
                      "Edit Encounter",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Form Sections
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildPatientFormSection(),
                            const SizedBox(height: 20),
                            _buildDictationSection(),
                            const SizedBox(height: 20),
                            _buildCodesSection(),
                            const SizedBox(height: 20),
                            _buildAnnotationSection(),
                            const SizedBox(height: 20),
                            _buildFinalizationSection(),
                            const SizedBox(height: 20),
                            _buildActionButtons(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
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
            "Submit & Complete",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }
  Widget buildPatientFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT COLUMN — with Encounter Date now at the top
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    const SizedBox(height: 16),

                    const Text("Facility", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: 'Brookline Rehab Center',
                      enabled: false,
                      style: const TextStyle(fontSize: 12),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF0F0F0),
                        isDense: true,
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text("Suggested Type", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: 'Follow-Up',
                      enabled: false,
                      style: const TextStyle(fontSize: 12),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF0F0F0),
                        isDense: true,
                        prefixIcon: Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 18),
                    labelWithAsterisk("Encounter Date"),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: "${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.year}",
                          ),
                          readOnly: true,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today, size: 20),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 84),

              /// RIGHT COLUMN (only Visit Type remains)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelWithAsterisk("Visit Type"),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // aligns to left
                      children: [
                        SizedBox(
                          width: 160,
                          child: buildVisitTypeButton('Initial Eval'),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 160,
                          child: buildVisitTypeButton('Follow-Up'),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 160,
                          child: buildVisitTypeButton('Discharge'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget buildVisitTypeButton(String value) {

    final isSelected = selectedVisitType == value;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedVisitType = value;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF1B7BC4) : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        side: BorderSide(color: Colors.grey.shade400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      child: Text(value),
    );
  }
  Widget labelWithAsterisk(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildDictationSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0, // Set to 0 since shadow is handled by Container
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dictation and Transcription",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 24),

              // Audio & Transcript side-by-side
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Left Section: Audio
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _audioTile(duration: "01:45"),
                        const SizedBox(height: 12),
                        _audioTile(duration: "00:30"),
                        const SizedBox(height: 12),
                        _audioTile(duration: "00:45"),
                        const SizedBox(height: 16),

                        const Text("Total Recorded", style: TextStyle(fontSize: 12)),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey.shade300,
                              ),
                            ),
                            Container(
                              width: 300,
                              height: 6,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.green, Colors.orange, Colors.red],
                                  stops: [0.3, 0.66, 1.0],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text("03:00",
                              style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 170), // Tighter spacing

                  /// Right Section: Transcription
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Dr. Name – 07/08/2024",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        TextField(
                          maxLines: 8,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(12),
                            hintText:
                            "Saw pt in room. No major changes. Pt c/o pain R upper hip. Ordered 3 doses tramadol. Will reassess next week - if no improvement, consider injection. Pt alert, stable. Meds to continue",
                            hintStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _audioTile({required String duration}) {
    return Row(
      children: [
        Icon(Icons.play_circle_fill, color: Colors.blue, size: 32),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue.shade50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                12,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: 2,
                    height: (index % 2 == 0) ? 16 : 12,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(duration, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 8),
        Icon(Icons.more_vert),
      ],
    );
  }
  Widget _buildCodesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Expanded(
                  child: Center(
                    child: Text(
                      "ICD – Codes",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "CPT Codes",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Linked Fragments",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Main Content Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// ICD Codes
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSearchInput(),
                    const SizedBox(height: 12),
                    _buildCodeChip("E11.9", Colors.red.shade100, Colors.red, fontSize: 12),
                    const SizedBox(height: 12),
                    _buildCodeChip("J45.909", Colors.green.shade100, Colors.green, fontSize: 12),
                    const SizedBox(height: 12),
                    _buildCodeChip("J45.909", Colors.grey.shade300, Colors.black87, fontSize: 12),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              /// CPT Codes
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSearchInput(fontSize: 12),
                    const SizedBox(height: 12),
                    _buildCodeChip("921584", Colors.red.shade100, Colors.red, fontSize: 12),
                    const SizedBox(height: 12),
                    _buildCodeChip("897458", Colors.green.shade100, Colors.green, fontSize: 12),
                    const SizedBox(height: 12),
                    _buildCodeChip("963125", Colors.grey.shade300, Colors.black87, fontSize: 12),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              /// Linked Fragments
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildFragmentBox("F1 → ICD: E11.9, CPT: 99213", fontSize: 12),
                    const SizedBox(height: 12),
                    _buildFragmentBox("F2 → ICD: J45.909", fontSize: 12),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFragmentBox(String text, {double fontSize = 12}) {
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(
        minWidth: 200, // Set a minimum width (adjust as needed)
        maxWidth: 200, // Set a max width to keep boxes equal
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }

  Widget _buildSearchInput({double fontSize = 12}) {
    return SizedBox(
      width: 180, // Adjust this to make it narrower
      child: TextField(
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          hintText: "Search...",
          hintStyle: TextStyle(fontSize: fontSize),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50), // Fully circular look
          ),
        ),
      ),
    );
  }


  Widget _buildCodeChip(String label, Color bgColor, Color textColor, {double fontSize = 12}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: textColor), // Box-style border
        borderRadius: BorderRadius.circular(6), // Slightly rounded corners (or use 0 for square)
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }


  Widget _buildAnnotationSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Annotation",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          SizedBox(height: 14),
          TextField(
            maxLines: 4,
            style: TextStyle(fontSize: 11),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              hintText: "Text",
              hintStyle: TextStyle(fontSize: 11),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFinalizationSection() {
    String selectedOption = "review"; // Use state management in real case

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Finalization Section",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Sign Off & Complete
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedOption = 'signoff';
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: selectedOption == 'signoff' ? const Color(0xFF1B7BC4) : Colors.transparent,
                  foregroundColor: selectedOption == 'signoff' ? Colors.white : Colors.black,
                  side: BorderSide(color: Colors.grey.shade400, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                child: const Text('Sign Off & Complete'),
              ),

              const SizedBox(width: 12),

              // I Attest
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedOption = 'attest';
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: selectedOption == 'attest' ? const Color(0xFF1B7BC4) : Colors.transparent,
                  foregroundColor: selectedOption == 'attest' ? Colors.white : Colors.black,
                  side: BorderSide(color: Colors.grey.shade400, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                child: const Text('I Attest'),
              ),

              const SizedBox(width: 12),

              // Reviewed Without Signature
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedOption = 'review';
                  });
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: selectedOption == 'review' ?const Color(0xFF1B7BC4) : Colors.transparent,
                  foregroundColor: selectedOption == 'review' ? Colors.white : Colors.black,
                  side: BorderSide(color: Colors.grey.shade400, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                child: const Text('Reviewed Without Signature'),
              ),
            ],
          ),



          const SizedBox(height: 16),
          const TextField(
            maxLines: 4,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              hintText: "Text",
              hintStyle: TextStyle(fontSize: 12),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Signature Text: “Dr. Test on 06/24/2025 at 15:34”',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }


}
