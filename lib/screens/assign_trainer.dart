import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_2/utils/show_message.dart';

class AssignTrainer extends StatefulWidget {
  final String gymName;
  const AssignTrainer({super.key, required this.gymName});

  @override
  State<AssignTrainer> createState() => _AssignTrainerState();
}

class _AssignTrainerState extends State<AssignTrainer> {
  String? selectedMember;
  String? selectedTrainer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign member to trainer"),
        surfaceTintColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('members')
            .where('gym_name', isEqualTo: widget.gymName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          var memberDocs = snapshot.data!.docs;
          List<DropdownMenuItem<String>> dropdownItems = [];
          for (var memberDoc in memberDocs) {
            var memberData = memberDoc.data() as Map<String, dynamic>;
            String memberName = memberData[
                'name']; // Assuming 'name' is the field you want to display in the dropdown
            dropdownItems.add(
              DropdownMenuItem(
                value: memberName,
                child: Text(memberName),
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: 10,
                // ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[900],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text("Select a member"),
                      items: dropdownItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMember = newValue!;
                        });
                      },
                      value: selectedMember,
                      dropdownColor: Colors.grey[900],
                      style: const TextStyle(color: Colors.white),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                const Center(
                  child: Text(
                    "-- To --",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // trainer list
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('trainers')
                        .where('gym_name', isEqualTo: widget.gymName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      var trainerDocs = snapshot.data!.docs;
                      List<DropdownMenuItem<String>> dropdownItems = [];
                      for (var trainerDoc in trainerDocs) {
                        var trainerData =
                            trainerDoc.data() as Map<String, dynamic>;
                        String trainerName = trainerData[
                            'name']; // Assuming 'name' is the field you want to display in the dropdown
                        dropdownItems.add(
                          DropdownMenuItem(
                            value: trainerName,
                            child: Text(trainerName),
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[900],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text("Select a trainer"),
                            items: dropdownItems,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTrainer = newValue!;
                              });
                            },
                            value: selectedTrainer,
                            dropdownColor: Colors.grey[900],
                            style: const TextStyle(color: Colors.white),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                          ),
                        ),
                      );
                    }),

                const SizedBox(
                  height: 50,
                ),

                // assign button
                SizedBox(
                  width: 240,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        backgroundColor: Colors.lightGreenAccent),
                    onPressed: () async {
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      CollectionReference collection =
                          firestore.collection("members");

                      QuerySnapshot snapshot = await collection
                          .where('name', isEqualTo: selectedMember)
                          .get();

                      if (snapshot.docs.isNotEmpty) {
                        DocumentSnapshot doc = snapshot.docs.first;
                        await doc.reference
                            .update({'assigned': selectedTrainer});
                        showMessage("Trainer assigned to $selectedMember");
                      }
                    },
                    child: Text(
                      'Assign',
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
