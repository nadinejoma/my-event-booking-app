import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/pages/categories_event.dart';
import 'package:event_booking_app/pages/detail_page.dart';
import 'package:event_booking_app/services/database.dart';
import 'package:event_booking_app/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot>? eventStream;
  String? _currentCity, name;
  TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {
      'icon': Icons.music_note,
      'name': 'Music',
      'color': Colors.blue.shade100
    },
    {
      'icon': Icons.festival,
      'name': 'Festival',
      'color': Colors.orange.shade100
    },
    {
      'icon': Icons.palette,
      'name': 'Art',
      'color': Colors.purple.shade100
    },
    {
      'icon': Icons.restaurant,
      'name': 'Food',
      'color': Colors.red.shade100
    },
    {
      'icon': Icons.shopping_bag,
      'name': 'Fashion',
      'color': Colors.pink.shade100
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      DatabaseMethods databaseMethods = DatabaseMethods();
      
      // Add test event if needed
      await databaseMethods.addTestEvent();
      
      name = await SharedpreferenceHelper().getUserName();
      var eventsStream = await databaseMethods.getallEvents();
      setState(() {
        eventStream = eventsStream;
      });
      await _getCurrentCity();
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  Future<void> _getCurrentCity() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          setState(() {
          _currentCity = "${placemarks[0].locality}, ${placemarks[0].country}";
        });
      }
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _currentCity = "Istanbul, Turkey"; // Fallback location
      });
    }
  }

  Widget _buildEventCard(DocumentSnapshot ds) {
    DateTime eventDate = DateTime.parse(ds['Date']);
    String month = DateFormat('MMM').format(eventDate);
    String day = DateFormat('d').format(eventDate);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              date: ds['Date'],
              detail: ds['Detail'],
              image: ds['Image'],
              location: ds['Location'],
              price: ds['Price'],
              name: ds['Name'],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    ds['Image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 217, 112, 8),
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                ),
                // Date badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          month,
                          style: TextStyle(
                            color: Color.fromARGB(255, 217, 112, 8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          day,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Price badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 217, 112, 8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\$${ds['Price']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ds['Name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          ds['Location'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffe3e6ff),
                Color.fromRGBO(157, 80, 109, 1),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  // Location
              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                      SizedBox(width: 8),
                  Text(
                    _currentCity ?? 'Loading...',
                    style: TextStyle(
                          fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
                  SizedBox(height: 24),

                  // Greeting and Event Count
              Text(
                    'Hello, ${name ?? 'User'}',
                style: TextStyle(
                      fontSize: 28,
                  fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 75, 73, 73),
                ),
              ),
                  SizedBox(height: 8),
              Text(
                    'There are 20 events\naround your location.',
                style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(155, 64, 43, 1),
                ),
              ),
                  SizedBox(height: 24),

                  // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                        hintText: 'Search an Event',
                        prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Categories
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoriesEvent(
                                    eventcategory: category['name'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 110,
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    category['icon'],
                                    size: 32,
                                    color: Color.fromARGB(255, 217, 112, 8),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    category['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Upcoming Events Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 217, 112, 8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Events List
                  StreamBuilder<QuerySnapshot>(
                    stream: eventStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 217, 112, 8),
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading events',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      var upcomingEvents = snapshot.data!.docs.where((doc) {
                        try {
                          String inputDate = doc['Date'] ?? '';
                          DateTime eventDate = DateTime.parse(inputDate);
                          return eventDate.isAfter(DateTime.now());
                        } catch (e) {
                          print('Error parsing date: $e');
                          return false;
                        }
                      }).toList();

                      if (upcomingEvents.isEmpty) {
                        return Center(
                          child: Text(
                            'No upcoming events',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: upcomingEvents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = upcomingEvents[index];
                          return _buildEventCard(doc);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Home()));
}
