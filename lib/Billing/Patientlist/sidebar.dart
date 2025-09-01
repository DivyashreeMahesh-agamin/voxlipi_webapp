import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webappnursingapp/Billing/Patientlist/addpatient.dart';
import 'package:webappnursingapp/Billing/Patientlist/patientlist.dart';
import 'package:webappnursingapp/Billing/Ready%20to%20Bill%20Encounter%20List.dart';
import 'package:webappnursingapp/Billing/encounterfinalization(MD).dart';
import 'package:webappnursingapp/Encounterslist/add%20encounter.dart';
import 'package:webappnursingapp/Encounterslist/encounterlist.dart';
import 'package:webappnursingapp/revert/revert.dart';
import 'package:webappnursingapp/usersettings.dart';

class CollapsibleSidebar extends StatefulWidget {
  @override
  _CollapsibleSidebarState createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<CollapsibleSidebar> {
  bool isSidebarExpanded = true;
  String? selectedSubItem;
  String? selectedSection;

  final Map<String, List<String>> menuItems = {
    'Patients': ['Patients List', 'Add Patient'],
    'Encounter Management': ['Encounter List', 'Add Encounter'],
    'Billing Management': ['Ready-to-Bill Queue'],
    'Reports & Analytics': ['Encounter Metrics (Signed/Unsigned)'],
    'Profile & Settings': [
      'View Profile',
      'Notification Settings',
      'User Settings'
    ],
  };

  final Map<String, bool> sectionExpanded = {
    'Patients': false,
    'Encounter Management': false,
    'Billing Management': false,
    'Reports & Analytics': false,
    'Profile & Settings': false,
  };

  final Map<String, String> _routeMap = {
    'Patients List': '/Voxlipi/Patient-List',
    'Add Patient': '/Voxlipi/Add-Patient',
    'Encounter List': '/Voxlipi/Encounter-List',
    'Add Encounter': '/Voxlipi/AddEncounter',
    'Ready-to-Bill Queue': '/Voxlipi/Ready-To-Bill',
    'Encounter Metrics (Signed/Unsigned)': '/Voxlipi/Patient-List',
    'View Profile': '/Voxlipi/Patient-List',
    'Notification Settings': '/Voxlipi/Patient-List',
    'User Settings': '/Voxlipi/Settings',
  };

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute = GoRouterState
          .of(context)
          .uri
          .toString();

      _routeMap.forEach((subItem, route) {
        if (route == currentRoute) {
          final section = menuItems.entries
              .firstWhere((e) => e.value.contains(subItem))
              .key;
          setState(() {
            selectedSubItem = subItem;
            selectedSection = section;
            sectionExpanded.updateAll((key, value) => key == section);
          });
        }
      });
    });
  }

    void toggleSidebar() {
      setState(() {
        isSidebarExpanded = !isSidebarExpanded;
      });
    }

    void toggleSection(String section) {
      setState(() {
        sectionExpanded.updateAll((key, value) =>
        key == section
            ? !sectionExpanded[section]!
            : false);
      });
    }

    Widget buildMenuItem(String title, List<String> subItems) {
      final isExpanded = sectionExpanded[title] ?? false;
      final isSelected = selectedSection == title;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B7BC4), Color(0xFF49B1FF)],
                stops: [0.1, 0.9],
              )
                  : null,
              color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
              ],
            ),
            child: ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              title: isSidebarExpanded
                  ? Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              )
                  : null,
              trailing: isSidebarExpanded && subItems.isNotEmpty
                  ? Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons
                    .keyboard_arrow_down,
                size: 18,
                color: isSelected ? Colors.white : Colors.black54,
              )
                  : null,
              onTap: () {
                toggleSection(title);
              },
            ),
          ),
          if (isSidebarExpanded && isExpanded &&
              subItems.isNotEmpty) const SizedBox(height: 8),
          if (isExpanded && isSidebarExpanded && subItems.isNotEmpty)
            ...subItems.map(
                  (sub) =>
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.only(
                        left: 32, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                      color: selectedSubItem == sub
                          ? const Color(0x1A1B7BC4)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(
                          horizontal: 0, vertical: -3),
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        sub,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: selectedSubItem == sub
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedSubItem = sub;
                          selectedSection = title;
                          sectionExpanded.updateAll((key, value) =>
                          key == title);
                        });

                        if (_routeMap.containsKey(sub)) {
                          context.go(_routeMap[sub]!);
                        } else {
                          debugPrint("Route not defined for $sub");
                        }
                      },
                    ),
                  ),
            ),
          const SizedBox(height: 8),
        ],
      );
    }

    @override
    Widget build(BuildContext context) {
      return Container(
        width: isSidebarExpanded ? 250 : 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(1, 0))
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
              alignment: Alignment.centerLeft,
              child: isSidebarExpanded
                  ? Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/logo.png',
                          width: 88,
                          height: 88,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: toggleSidebar,
                    ),
                  ],
                ),
              )
                  : Center(
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: toggleSidebar,
                ),
              ),
            ),
            if (isSidebarExpanded)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: menuItems.entries
                        .map((entry) => buildMenuItem(entry.key, entry.value))
                        .toList(),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: isSidebarExpanded
                  ? Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B7BC4), Color(0xFF49B1FF)],
                    stops: [0.1, 0.9],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                      "Logout", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: () {
                    // Add logout logic
                  },
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    }
  }
