import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

// --- GLOBAL HELPER ---
Widget _safeImage(String path, BoxFit fit) {
  return Image.asset(
    path,
    fit: fit,
    errorBuilder: (context, error, stackTrace) => Container(
      color: Colors.red,
      child: const Icon(Icons.error, color: Colors.white, size: 50),
    ),
  );
}

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PortfolioPage(),
    ));

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  String? _activeTab;

  final List<String> imgList = [
    'assets/6bd21dbd-9588-4416-875f-3333930ef874.jpg',
    'assets/f18c1873-4b7c-40c8-b88c-8a1df0f8d080.jpg',
    'assets/a30131df-f710-4edc-97e5-d85ee4fb035f.jpg',
    'assets/95a77abb-a288-4906-8571-f7e3e1c2cc70.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  }

  void _showTab(String tabName) {
    if (_activeTab != null) {
      _controller.reverse().then((_) {
        setState(() => _activeTab = tabName);
        _controller.forward();
      });
    } else {
      setState(() => _activeTab = tabName);
      _controller.forward();
    }
  }

  void _closeTab() {
    if (_activeTab == "PHOTOGRAPHY_GALLERY" || _activeTab == "PROJECTS_GALLERY" || _activeTab == "ARTS_GALLERY") {
      _controller.reverse().then((_) {
        setState(() => _activeTab = "WORKS");
        _controller.forward();
      });
    } else {
      _controller.reverse().then((_) => setState(() => _activeTab = null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _safeImage('assets/Bougainvillea.jpg', BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.15))),
          Column(
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return _buildTopBar(() => _showTab("ABOUT"), () => _showTab("WORKS"), () => _showTab("CONTACT"), constraints.maxWidth);
              }),
              const Spacer(),
              LayoutBuilder(builder: (context, constraints) {
                return SizedBox(height: constraints.maxWidth > 600 ? 800 : 400, child: CarouselSlider.builder(
                  itemCount: imgList.length,
                  itemBuilder: (context, index, realIndex) => _HoverableImageCard(path: imgList[index]),
                  options: CarouselOptions(
                    height: constraints.maxWidth > 600 ? 650 : 300, 
                    viewportFraction: constraints.maxWidth > 600 ? 0.35 : 0.8, 
                    enlargeCenterPage: true, 
                    autoPlay: true
                  ),
                ));
              }),
              const Spacer(),
            ],
          ),
          if (_activeTab != null)
            SlideTransition(
              position: _slideAnimation, 
              child: _getActiveOverlay(),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(VoidCallback onAbout, VoidCallback onWorks, VoidCallback onContact, double screenWidth) => Container(
      height: screenWidth > 600 ? 70 : 60,
      margin: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 10, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 30 : 10),
      decoration: BoxDecoration(color: const Color(0xFFE086F0), borderRadius: BorderRadius.circular(15)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("KEJ", style: GoogleFonts.instrumentSerif(fontSize: screenWidth > 600 ? 32 : 20, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          
          if (screenWidth > 500)
            Text("E-Portfolio", style: GoogleFonts.instrumentSerif(fontSize: screenWidth > 600 ? 32 : 20, fontWeight: FontWeight.bold, color: Colors.black)),
          
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(onTap: onAbout, child: _navLinkMobile("ABOUT ME", screenWidth)),
                SizedBox(width: screenWidth > 600 ? 30 : 10),
                GestureDetector(onTap: onWorks, child: _navLinkMobile("WORKS", screenWidth)),
                SizedBox(width: screenWidth > 600 ? 30 : 10),
                GestureDetector(onTap: onContact, child: _navLinkMobile("CONTACT", screenWidth)),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _navLinkMobile(String text, double screenWidth) => Text(
      text, 
      style: GoogleFonts.barlowCondensed(
        fontWeight: FontWeight.w900, 
        fontSize: screenWidth > 600 ? 18 : 12,
        color: Colors.black
      )
    );

  Widget _getActiveOverlay() {
    switch (_activeTab) {
      case "ABOUT": return _buildAboutOverlay();
      case "WORKS": return _buildWorksOverlay();
      case "CONTACT": return _buildContactOverlay();
      case "PHOTOGRAPHY_GALLERY": return _buildPhotographyGallery();
      case "PROJECTS_GALLERY": return _buildProjectsGallery();
      case "ARTS_GALLERY": return _buildArtsGallery();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildPhotographyGallery() => _buildGenericGallery(['assets/d308cc49-bc22-48e8-a3f0-dcf2786ce34f.jpg', 'assets/afae1738-ddc6-4fdc-9f57-511c65ff2801.jpg', 'assets/8c7ac522-796d-48d0-b185-56a8cdaaebe2.jpg', 'assets/2bb552dd-7f41-4d1c-be2b-4808573ce2ef.jpg']);
  Widget _buildProjectsGallery() => _buildGenericGallery(['assets/8c994a0f-2a60-48fb-a1fd-7e9718c2b25c.jpg', 'assets/768a36cd-4ace-450d-979e-2b56b43c8d6d.jpg', 'assets/bc2ec74a-bc91-49d0-8463-f959cb2fba83.jpg', 'assets/6bd21dbd-9588-4416-875f-3333930ef874.jpg']);
  Widget _buildArtsGallery() => _buildGenericGallery(['assets/99caee04-9da9-4ea1-9cea-eda6026690b6.jpg', 'assets/0b2e7ce1-fccd-49ba-9ca3-2f48d672fb34.jpg', 'assets/d3694d40-79a4-4484-b9dc-9ba9478408ff.jpg', 'assets/b7c177bb-65e5-4a3d-a89b-dfddc8f47774.jpg']);

  Widget _buildGenericGallery(List<String> imageList) {
    final PageController pageController = PageController(initialPage: 1000);
    return Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFF000000), Color(0xFFFFFFFF)])), child: Stack(children: [
      PageView.builder(controller: pageController, itemBuilder: (context, index) => Padding(padding: const EdgeInsets.all(80.0), child: ClipRRect(borderRadius: BorderRadius.circular(20), child: _safeImage(imageList[index % imageList.length], BoxFit.contain)))),
      Positioned(top: 40, right: 40, child: IconButton(icon: const Icon(Icons.close, size: 40, color: Colors.black), onPressed: _closeTab)),
      Positioned(left: 20, top: MediaQuery.of(context).size.height / 2 - 30, child: _buildStyledArrow(Icons.arrow_back_ios_new, () => pageController.previousPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOut))),
      Positioned(right: 20, top: MediaQuery.of(context).size.height / 2 - 30, child: _buildStyledArrow(Icons.arrow_forward_ios, () => pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOut))),
    ]));
  }

  Widget _buildStyledArrow(IconData icon, VoidCallback onPressed) => IconButton(onPressed: onPressed, icon: Stack(alignment: Alignment.center, children: [Icon(icon, color: Colors.black, size: 64), Icon(icon, color: Colors.white, size: 60)]));

  Widget _buildAboutOverlay() { return Container(color: const Color(0xFF1A1A1A), padding: const EdgeInsets.all(40), child: Stack(children: [Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Icon(Icons.fiber_manual_record, color: Colors.red, size: 20), const SizedBox(width: 10), Text("REC", style: GoogleFonts.barlowCondensed(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]), Text("About Me", style: GoogleFonts.barlowCondensed(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), const SizedBox(height: 20), Text("I am Michael Fred Reyes", style: GoogleFonts.barlowCondensed(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)), const SizedBox(height: 20), Wrap(spacing: 10, runSpacing: 10, children: ["Photographer", "Videographer", "Artist", "Graphic Designer"].map((t) => _pill(t)).toList()), const SizedBox(height: 40), Text("I am a Visual storyteller forte in graphic arts, photography, and photo editing. Combining creative vision with technical skill, I bring ideas to life using Canva, Photoshop, Lightroom, and After Effects. Let's create something memorable.", style: GoogleFonts.barlowCondensed(color: Colors.white, fontSize: 20)), const Spacer(), Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("FORTE", style: GoogleFonts.barlowCondensed(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), Text("GRAPHIC ARTS\nPHOTOGRAPHY\nPHOTO EDITING", style: GoogleFonts.barlowCondensed(color: Colors.white, fontSize: 18))])), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SOFTWARES", style: GoogleFonts.barlowCondensed(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), Text("CANVA\nADOBE PHOTOSHOP\nADOBE AFTER EFFECTS\nADOBE LIGHTROOM", style: GoogleFonts.barlowCondensed(color: Colors.white, fontSize: 18))]))])])), Expanded(child: _safeImage('assets/body.jpg', BoxFit.contain))]), Positioned(top: 0, right: 0, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 40), onPressed: _closeTab))])); }

  Widget _buildWorksOverlay() { return Scaffold(backgroundColor: const Color(0xFFE086F0), body: SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10), child: Row(children: [
        Text("KEJ", style: GoogleFonts.instrumentSerif(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
        const Spacer(),
        IconButton(icon: const Icon(Icons.close, size: 32, color: Colors.black), onPressed: _closeTab)
      ])),
      Expanded(child: Row(children: [
        _CategorySection(title: "PHOTOGRAPHY", imagePath: 'assets/e4257a49-6dc6-4476-82da-56b93b0e4352.jpg', onTap: () => _showTab("PHOTOGRAPHY_GALLERY")),
        _CategorySection(title: "PROJECTS", imagePath: 'assets/768a36cd-4ace-450d-979e-2b56b43c8d6d.jpg', onTap: () => _showTab("PROJECTS_GALLERY")),
        _CategorySection(title: "ARTS", imagePath: 'assets/786baa52-ab19-4a07-9747-e658a2602d17.jpg', onTap: () => _showTab("ARTS_GALLERY")),
      ])),
    ]))); }

  Widget _buildContactOverlay() { return Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFF000000), Color(0xFF737373)])), child: Stack(children: [Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(height: 800, width: 600, child: ClipRRect(borderRadius: BorderRadius.circular(20), child: _safeImage('assets/f70c0b87-30dd-4c9b-9256-394509f5cc46.jpg', BoxFit.cover))), const SizedBox(width: 60), Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Get in Touch", style: GoogleFonts.barlowCondensed(fontSize: 96, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 80), _contactInfo("Name", "Michael Fred Reyes"), _contactInfo("Email", "Michaelfredreyes23@gmail.com"), _contactInfo("Phone", "+63 9615184094")])])), Positioned(top: 40, right: 40, child: IconButton(icon: const Icon(Icons.close, size: 40, color: Colors.white), onPressed: _closeTab))])); }

  Widget _contactInfo(String label, String value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: GoogleFonts.barlowCondensed(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white70)), Text(value, style: GoogleFonts.barlowCondensed(fontSize: 20, color: Colors.white)), const SizedBox(height: 20)]);
  Widget _pill(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: BoxDecoration(color: const Color(0xFFE086F0), borderRadius: BorderRadius.circular(10)), child: Text(text, style: GoogleFonts.barlowCondensed(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)));
  
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
}

class _HoverableImageCard extends StatefulWidget {
  final String path;
  const _HoverableImageCard({required this.path});
  @override
  State<_HoverableImageCard> createState() => _HoverableImageCardState();
}

class _HoverableImageCardState extends State<_HoverableImageCard> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) => MouseRegion(onEnter: (_) => setState(() => _isHovered = true), onExit: (_) => setState(() => _isHovered = false), child: AnimatedScale(scale: _isHovered ? 1.1 : 1.0, duration: const Duration(milliseconds: 200), child: ClipRRect(borderRadius: BorderRadius.circular(40), child: _safeImage(widget.path, BoxFit.cover))));
}

class _CategorySection extends StatefulWidget {
  final String title, imagePath;
  final VoidCallback onTap;
  const _CategorySection({required this.title, required this.imagePath, required this.onTap});
  @override
  State<_CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) => Expanded(child: MouseRegion(cursor: SystemMouseCursors.click, onEnter: (_) => setState(() => _isHovered = true), onExit: (_) => setState(() => _isHovered = false), child: GestureDetector(onTap: widget.onTap, child: Stack(children: [
    Positioned.fill(child: _safeImage(widget.imagePath, BoxFit.cover)),
    AnimatedContainer(duration: const Duration(milliseconds: 300), decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: _isHovered ? [Colors.black12, Colors.black] : [Colors.transparent, Colors.black87]))),
    Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.only(bottom: 60), child: AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 300), style: TextStyle(fontSize: _isHovered ? 78 : 74, color: Colors.white, fontFamily: GoogleFonts.barlowCondensed().fontFamily), child: Text(widget.title))))
  ]))));
}