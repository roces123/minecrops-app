import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'croplistscreen.dart';
import 'cropdetailscreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _bannerAssets = const [
    'assets/farmer.png',
    'assets/student.png',
    'assets/planter.png',
  ];

  bool _isSearching = false;
  String _searchQuery = '';

  void _updateSearch(String q) {
    setState(() {
      _searchQuery = q.trim();
    });
  }

  void _navigateToCropList(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropListScreen(categoryName: category),
      ),
    );
  }

  String _getField(Map<String, dynamic> data, List<String> possibleKeys) {
    for (final key in possibleKeys) {
      if (data.containsKey(key) && data[key] != null) {
        // Ensure that the value is treated as a string and not empty
        final value = data[key];
        final stringValue = value.toString().trim();
        if (stringValue.isNotEmpty) {
          return stringValue;
        }
      }
    }
    return '';
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF6B8E23),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 66,
      // The leading icon is no longer clickable and serves as a static logo.
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
          icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white, size: 28),
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
        autoPlay: false,
        aspectRatio: 16 / 9,
        viewportFraction: 0.98,
      ),
    );
  }

  Widget _buildImageBanner(String imageAssetPath) {
    return Container(
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
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imageAssetPath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 220,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.25), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            width: double.infinity,
            height: 220,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categories = [
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
          const Text(
            "Categories",
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, idx) => const SizedBox(width: 15),
              itemBuilder: (context, idx) {
                final categoryName = categories[idx]['name']!;
                return _buildCategoryItem(
                  categoryName,
                  categories[idx]['img']!,
                      () {
                    _navigateToCropList(context, categoryName);
                  },
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
            radius: 28,
            backgroundImage: AssetImage(imageAsset),
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: 95,
            height: 40,
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, height: 1.2),
              maxLines: 2,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonAndSearchableCropsSection(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('crops');
    String title = "Common Crops";

    if (_isSearching && _searchQuery.isNotEmpty) {
      title = "Search Results";
    } else {
      query = query.where('IsCommon', isEqualTo: true);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 11.0),
          StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('❌ Error loading crops: ${snapshot.error}', style: TextStyle(color: Colors.red)));
              }

              final docs = snapshot.data?.docs ?? [];

              final List<Map<String, dynamic>> crops = docs.map((d) {
                final map = d.data() as Map<String, dynamic>;
                return {...map, '_docId': d.id};
              }).where((map) {
                if (_searchQuery.isEmpty) {
                  return true;
                }
                final name = _getField(map, ['name', 'Name', 'cropName']).toLowerCase();
                return name.contains(_searchQuery.toLowerCase());
              }).toList();

              if (crops.isEmpty) {
                return SizedBox(
                  height: 80,
                  child: Center(child: Text(_isSearching && _searchQuery.isNotEmpty
                      ? "No crops match your search."
                      : "No common crops available. Check Firestore 'IsCommon' field.")),
                );
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: GridView.builder(
                  key: ValueKey<String>('grid-${crops.length}-${_searchQuery.length}-${_isSearching}'),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: crops.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, i) {
                    final crop = crops[i];
                    final name = _getField(crop, ['name', 'Name']) == '' ? 'Unnamed' : _getField(crop, ['name', 'Name']);
                    final imageUrl = _getField(crop, ['Image Url', 'imageUrl', 'image', 'ImageUrl']);

                    return GestureDetector(
                      onTap: () => _openCropDetails(context, crop),
                      child: _buildNetworkCropItem(name, imageUrl, tag: crop['_docId'] ?? 'crop-$i'),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkCropItem(String cropName, String imageUrl, {required String tag}) {
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
              child: Hero(
                tag: tag,
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, size: 30)),
                )
                    : const Center(child: Icon(Icons.image_not_supported, size: 30, color: Colors.grey)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              cropName,
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

  Widget _buildAllCropsSection(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('crops')
        .where('IsCommon', isEqualTo: false)
        .limit(2);

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
              TextButton(
                onPressed: () {
                  _navigateToCropList(context, "All Crops");
                },
                child: const Text(
                  "view all",
                  style: TextStyle(color: Color(0xFF6B8E23), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 140,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Text('Error loading other crops: ${snapshot.error}');
              }

              final docs = snapshot.data?.docs ?? [];
              final List<Map<String, dynamic>> crops = docs.map((d) {
                final map = d.data() as Map<String, dynamic>;
                return {...map, '_docId': d.id};
              }).toList();

              if (crops.isEmpty) {
                return const SizedBox(
                  height: 60,
                  child: Center(child: Text("No other crops available.")),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: crops.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, i) {
                  final crop = crops[i];
                  final name = _getField(crop, ['name', 'Name']) == '' ? 'Unnamed' : _getField(crop, ['name', 'Name']);
                  final imageUrl = _getField(crop, ['Image Url', 'imageUrl', 'image', 'ImageUrl']);

                  return GestureDetector(
                    onTap: () => _openCropDetails(context, crop),
                    child: _buildNetworkCropItem(name, imageUrl, tag: crop['_docId'] ?? 'other-crop-$i'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _openCropDetails(BuildContext context, Map<String, dynamic> cropData) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 360),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: CropDetailScreen(cropData: cropData),
        );
      },
    ));
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
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: _buildMainBannerCarousel(),
            ),
            const SizedBox(height: 20.0),
            _buildCategoriesSection(context),
            const SizedBox(height: 20.0),
            _buildCommonAndSearchableCropsSection(context),
            const SizedBox(height: 20.0),
            _buildAllCropsSection(context),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}