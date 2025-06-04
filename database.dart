import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addEvent(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("events")
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getallEvents() async {
    return await FirebaseFirestore.instance.collection("events").snapshots();
  }

  Future addUserBooking(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Booking")
        .add(userInfoMap);
  }

  Future addAdminTickets(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Tickets")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getbookings(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Booking")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getEventCategories(String category) async {
    return await FirebaseFirestore.instance
        .collection("events")
        .where("Category", isEqualTo: category)
        .snapshots();
  }

  Future<QuerySnapshot> search(String updatedname) async {
    return await FirebaseFirestore.instance
        .collection("events")
        .where(
          "SearchKey",
          isEqualTo: updatedname.substring(0, 1).toUpperCase(),
        )
        .get();
  }

  Future<Stream<QuerySnapshot>> getTickets() async {
    return await FirebaseFirestore.instance.collection("Tickets").snapshots();
  }

  Future<void> addTestEvent() async {
    try {
      // Check if test event already exists
      var existingEvents = await FirebaseFirestore.instance
          .collection('events')
          .where('Name', isEqualTo: 'Summer Music Festival')
          .get();

      if (existingEvents.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('events').add({
          'Name': 'Summer Music Festival',
          'Date': '2024-08-24',
          'Location': 'Istanbul Arena',
          'Price': '49.99',
          'Detail': 'Experience the ultimate summer music festival with live performances from top artists!',
          'Image': 'https://firebasestorage.googleapis.com/v0/b/event-booking-app-8e5d4.appspot.com/o/noise.jpg?alt=media',
          'Category': 'Music',
          'SearchKey': 'S',
          'YoutubeUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
        });
        print('Test event added successfully');
      } else {
        print('Test event already exists');
      }
    } catch (e) {
      print('Error adding test event: $e');
    }
  }
}
