import 'dart:io';
import 'package:event_booking_app/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  final List<String> eventcategory = [
    'Music',
    'Festival',
    'Art',
    'Fashion',
    'Food',
  ];
  String? value;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 0);

  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat('hh:mm a').format(dateTime);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 5.5),
                  Text(
                    'Upload Event',
                    style: TextStyle(
                      color: Color.fromRGBO(155, 64, 43, 1),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              selectedImage != null
                  ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        selectedImage!,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  : Center(
                    child: GestureDetector(
                      onTap: getImage,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                    ),
                  ),
              SizedBox(height: 30.0),

              Text(
                'Event Name',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Event Name',
                  ),
                ),
              ),
              SizedBox(height: 30.0),

              Text(
                'Ticket Price',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: pricecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Price',
                  ),
                ),
              ),

              SizedBox(height: 30.0),

              Text(
                'Event Location',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: locationcontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Location',
                  ),
                ),
              ),
              SizedBox(height: 30.0),

              Text(
                'Select Category',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value, // Set the selected value here
                    items:
                        eventcategory.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        value = newValue; // Update the selected value
                      });
                    },
                    dropdownColor: Colors.white,
                    hint: Text('Select Category'),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                  ),
                ),
              ),
              SizedBox(height: 30.0),

              Row(
                children: [
                  GestureDetector(
                    onTap: _pickDate,
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  GestureDetector(
                    onTap: _pickTime,
                    child: Icon(
                      Icons.access_time,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    formatTimeOfDay(selectedTime),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),

              Text(
                'Event Detail',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: detailcontroller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Event Details...',
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () async {
                  if (selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Please select an image',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    );
                    return;
                  }

                  try {
                    // Show upload starting
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Starting upload process...'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    String addId = randomAlphaNumeric(10);
                    print("Generated ID for upload: $addId");
                    
                    Reference firebaseStorageRef = FirebaseStorage.instance
                        .ref()
                        .child('eventImages')
                        .child("$addId.jpg"); // Add file extension

                    print("Attempting to upload file: ${selectedImage!.path}");
                    print("To Firebase path: eventImages/$addId.jpg");

                    final UploadTask task = firebaseStorageRef.putFile(
                      selectedImage!,
                      SettableMetadata(
                        contentType: 'image/jpeg',
                      ),
                    );

                    // Monitor upload progress
                    task.snapshotEvents.listen((TaskSnapshot snapshot) {
                      print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
                    }, onError: (e) {
                      print("Upload stream error: $e");
                    });

                    // Show upload progress
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Uploading image...'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Wait for the upload to complete
                    final TaskSnapshot taskSnapshot = await task;
                    print("Upload completed. Status: ${taskSnapshot.state}");

                    // Get the download URL
                    final downloadUrl = await taskSnapshot.ref.getDownloadURL();
                    print("Download URL obtained: $downloadUrl");

                    String id = randomAlphaNumeric(10);
                    String firstletter = namecontroller.text.substring(0, 1).toUpperCase();
                    
                    Map<String, dynamic> uploadevent = {
                      "Image": downloadUrl,
                      "Name": namecontroller.text,
                      "Price": pricecontroller.text,
                      "Category": value,
                      "SearchKey": firstletter,
                      "Location": locationcontroller.text,
                      "Detail": detailcontroller.text,
                      "UpdatedName": namecontroller.text.toUpperCase(),
                      "Date": DateFormat('yyyy-MM-dd').format(selectedDate),
                      "EventTime": formatTimeOfDay(selectedTime),
                      "CreatedAt": FieldValue.serverTimestamp(),
                    };

                    print("Saving event data to Firestore...");
                    await DatabaseMethods().addEvent(uploadevent, id);
                    print("Event data saved successfully");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                          'Event Uploaded successfully!!!',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );

                    setState(() {
                      namecontroller.text = '';
                      pricecontroller.text = '';
                      detailcontroller.text = '';
                      selectedImage = null;
                      value = null;
                      selectedDate = DateTime.now();
                      selectedTime = TimeOfDay(hour: 10, minute: 0);
                    });
                  } catch (e, stackTrace) {
                    print("Error uploading event: $e");
                    print("Stack trace: $stackTrace");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Error uploading event: ${e.toString()}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    );
                  }
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(155, 64, 43, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 200,
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
