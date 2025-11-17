import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Updated banner asset
  final List<String> _bannerAssets = const [
    'assets/farmer_banner.png', // Assuming this is the "Are you a Farmer?" image
  ];

  bool _isSearching = false;
  String _searchQuery = '';

  void _updateSearch(String q) {
    setState(() {
      _searchQuery = q.trim();
    });
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF6B8E23),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 66,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
        child: ClipOval(
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          ),
        ),
      ),
      title: !_isSearching ? _buildTitleColumn() : _buildSearchField(),
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _isSearching = false;
                _searchQuery = '';
              } else {
                _isSearching = true;
              }
            });
          },
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }

  Widget _buildTitleColumn() {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Magandang Araw",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.normal,
              height: 1.1,
            ),
          ),
          Text(
            "MineCrops User",
            style: TextStyle(
              color: Colors.limeAccent.shade100,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      onChanged: _updateSearch,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: 'Search crops...',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildMainBannerCarousel() {
    return CarouselSlider.builder(
      itemCount: _bannerAssets.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return _buildImageBanner(_bannerAssets[index]);
      },
      options: CarouselOptions(
        height: 220.0,
        enlargeCenterPage: true,
        autoPlay: true, // Set to true for auto-play as in the image
        aspectRatio: 16 / 9,
        viewportFraction: 1.0, // Changed to 1.0 to show a single banner fully
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildImageBanner(String imageAssetPath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset(
          imageAssetPath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 220,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categories = [
      {'name': "All Crops", 'img': 'assets/all_crops.jpg'}, // Placeholder for all crops
      {'name': "Fruit Crops", 'img': 'assets/fruits.jpg'},
      {'name': "Grain Crops", 'img': 'assets/grains.jpg'},
      {'name': "Roots Crops", 'img': 'assets/roots.jpg'},
      {'name': "Legumes Crops", 'img': 'assets/legumes.jpg'},
      {'name': "Industrial/Commercial Crops", 'img': 'assets/induscom.jpg'},
      {'name': "Vegetable Crops", 'img': 'assets/vegetables.jpg'},
      {'name': "Spices/Herbs", 'img': 'assets/spices.jpg'},
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              if (categories.isNotEmpty) // Only show "view all" if there are categories
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () => print('View All Categories tapped'),
                    child: const Text(
                      "view all",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue, // Or your app's accent color
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 100, // Adjusted height for circular categories
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, idx) => const SizedBox(width: 15),
              itemBuilder: (context, idx) {
                final categoryName = categories[idx]['name']!;
                return _buildCategoryItem(
                  categoryName,
                  categories[idx]['img']!,
                      () => print('Navigation for category: $categoryName is removed.'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imageAsset, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30, // Slightly larger radius
            backgroundImage: AssetImage(imageAsset),
          ),
          const SizedBox(height: 5), // Smaller spacing
          SizedBox(
            width: 70, // Adjusted width for category text
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, height: 1.2),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticCommonCropsSection() {
    final crops = [
      {'name': 'Palay / Rice', 'img': 'assets/rice.jpg'},
      {'name': 'Sugar Cane', 'img': 'assets/sugarcane.jpg'},
      {'name': 'Corn / Mais', 'img': 'assets/corn.jpg'},
      {'name': 'Mango', 'img': 'assets/mango.jpg'},
      {'name': 'Pineapple', 'img': 'assets/pineapple.jpg'},
      {'name': 'Eggplant / Talong', 'img': 'assets/eggplant.jpg'},
      {'name': 'Banana / Saging', 'img': 'assets/banana.jpg'},
      {'name': 'Tomato / Kamatis', 'img': 'assets/tomato.jpg'},
      {'name': 'Cassava', 'img': 'assets/cassava.jpg'},
    ];

    final filtered = _searchQuery.isEmpty
        ? crops
        : crops.where((c) => c['name']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _searchQuery.isEmpty ? "Common Crops" : "Search Results",
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 11.0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Changed to 3 columns as per image
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              childAspectRatio: 0.8, // Adjusted for better card proportion
            ),
            itemBuilder: (context, i) {
              return _buildLocalCropItem(
                filtered[i]['name']!,
                filtered[i]['img']!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocalCropItem(String name, String imageAsset) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(9.0)),
              child: Image.asset(
                imageAsset,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCropsSection() {
    final allCrops = [
      {'name': 'Watermelon', 'img': 'assets/watermelon.jpg'},
      {'name': 'Coconut', 'img': 'assets/coconut.jpg'},
      {'name': 'Cabbage', 'img': 'assets/cabbage.jpg'},
      {'name': 'Carrot', 'img': 'assets/carrot.jpg'},
      // Add more crops as needed to match the design
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "All Crops",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => print('View All Crops tapped'),
                child: const Text(
                  "view all",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue, // Or your app's accent color
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11.0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allCrops.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns for "All Crops" section
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, i) {
              return _buildLocalCropItem(
                allCrops[i]['name']!,
                allCrops[i]['img']!,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F3),
      appBar: _buildCustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            _buildMainBannerCarousel(),
            const SizedBox(height: 20),
            _buildCategoriesSection(context),
            const SizedBox(height: 20),
            _buildStaticCommonCropsSection(),
            const SizedBox(height: 20), // Added spacing
            _buildAllCropsSection(), // New "All Crops" section
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}