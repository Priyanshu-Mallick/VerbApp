import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/home_controller.dart';

class AddSchoolBottomSheet extends StatefulWidget {
  const AddSchoolBottomSheet({super.key});

  @override
  _AddSchoolBottomSheetState createState() => _AddSchoolBottomSheetState();
}

class _AddSchoolBottomSheetState extends State<AddSchoolBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tnameController = TextEditingController();

  String? nameError;
  String? emailError;
  String? tnameError;

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF434353),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom,
        ),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add New School',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFFD6D4E2))),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: const Text('Close',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('School Name',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFFD6D4E2))),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF353440),
                          hintText: 'Enter school name',
                          hintStyle: const TextStyle(color: Colors.white),
                          errorText: nameError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'School name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text('School Email/ Admin email',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFFD6D4E2))),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF353440),
                          hintText: 'Enter email',
                          hintStyle: const TextStyle(color: Colors.white),
                          errorText: emailError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      const Text('Teacher Name',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xFFD6D4E2))),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: tnameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF353440),
                          hintText: 'Enter teacher name',
                          hintStyle: const TextStyle(color: Colors.white),
                          errorText: tnameError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Teacher name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: homeController.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await homeController.addSchool(
                                      nameController.text.trim(),
                                      emailController.text.trim(),
                                      tnameController.text.trim());
                                  Navigator.pop(
                                      context); // Close the bottom sheet
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.4),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adding corner radius
                          ),
                        ),
                        child: homeController.isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : const Text('Save'),
                      ),
                      SizedBox(
                        height: 20,
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
  }
}
