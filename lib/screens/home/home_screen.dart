import 'package:flutter/material.dart';

import '../post_job_screen/post_job_screen.dart';
import '../profilescreen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[100],
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back,',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Alex Maniel',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_none,
                    color: Colors.black87, size: 28),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.person, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    SizedBox(height: 20),
                    _buildOfferCard(),
                    SizedBox(height: 20),
                    Text('Services',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    _buildServicesGrid(),
                    SizedBox(height: 20),
                    Text('Nearby Opportunities',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    _buildNearbyJobs(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: _buildBottomNavigationBar(
              currentIndex,
                  (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ));
  }

  Widget _buildBottomNavigationBar(int currentIndex, Function(int) onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home,
              label: 'Home',
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _buildNavItem(
              icon: Icons.person_search,
              label: 'Candidates',
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _buildNavItem(
              icon: Icons.work,
              label: 'Jobs',
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _buildNavItem(
              icon: Icons.account_circle,
              label: 'Profile',
              isSelected: currentIndex == 3,
                onTap: () {
                  if (currentIndex != 3) {
                    setState(() {
                      currentIndex = 3;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  }
                }

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.teal : Colors.grey[500],
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Light background
        borderRadius: BorderRadius.circular(12), // Square with soft rounding
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.teal, size: 24),
          hintText: 'Search Resumes or Candidates',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600], size: 20),
            onPressed: () {
              // Optional: Add clear functionality here
            },
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildOfferCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.teal[300]!, Colors.teal[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background Icon
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.insert_drive_file,
                size: 120,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon or Image on the left
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.description,
                      color: Colors.teal,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 16),
                  // Text and Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Free Resume Review',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Let experts review your CV!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            // Handle button tap
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                color: Colors.teal[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid() {
    return GridView.count(
      crossAxisCount: 2,
      // More space per item
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _serviceTile(Icons.create, 'Create Resume'),
        _serviceTile(Icons.search, 'Search Candidates'),
        _serviceTile(Icons.business_center, 'Post Jobs'),
        _serviceTile(Icons.approval, 'Resume Review'),
      ],
    );
  }

  Widget _serviceTile(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "Post Jobs") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostJobScreen()),
          );
        // } else if (label == "Create Resume") {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (_) => const CreateResumeScreen()),
        //   );
        // } else if (label == "Search Candidates") {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (_) => const SearchCandidatesScreen()),
        //   );
        // } else if (label == "Resume Review") {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (_) => const ResumeReviewScreen()),
        //   );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: Colors.teal[700]),
            ),
            SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyJobs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildAppCard(
            icon: Icons.work,
            title: 'Software Engineer',
            distance: '2.5 km away',
            onTap: () {},
          ),
          SizedBox(width: 12),
          buildAppCard(
            icon: Icons.business,
            title: 'Data Scientist',
            distance: '4 km away',
            onTap: () {},
          ),
          SizedBox(width: 12),
          buildAppCard(
            icon: Icons.design_services,
            title: 'UI/UX Designer',
            distance: '3 km away',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget buildAppCard({
    required IconData icon,
    required String title,
    String? subtitle,
    String? distance,
    VoidCallback? onTap,
    List<Color>? gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors ?? [Colors.teal[300]!, Colors.teal[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: Colors.teal[800]),
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
            if (distance != null) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    distance,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
