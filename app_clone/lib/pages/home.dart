import 'package:app_clone/pages/appdrawer.dart';
import 'package:app_clone/pages/express.dart';
import 'package:app_clone/pages/metro.dart';
import 'package:app_clone/pages/pnr.dart';
import 'package:app_clone/pages/tickets.dart';
import 'package:app_clone/pages/cell_tower_status.dart';
import 'package:flutter/material.dart';
import 'package:app_clone/utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int selectBottomNavIndex = 0;
  PageController bottomNavPageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    bottomNavPageController.dispose();
    super.dispose();
  }

  void onTapBottomNavItem(int index) {
    setState(() {
      selectBottomNavIndex = index;
    });
    bottomNavPageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "RailPulse",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            Row(
              children: [
                IconButton(
                  tooltip: 'Cell tower tracking',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CellTowerStatusPage()),
                    );
                  },
                  icon: Icon(Icons.cell_tower, size: 25, color: AppColors.appBarFontColor),
                ),
                Icon(Icons.mic, size: 28, color: AppColors.appBarFontColor),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.appbarColor,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
                top: MediaQuery.of(context).size.width * 0.03,
                bottom: MediaQuery.of(context).size.width * 0.03,
              ),
              decoration: BoxDecoration(color: AppColors.appbarColor),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.tabBarHoverColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                tabs: const [Tab(text: "EXPRESS"), Tab(text: "METRO")],
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 0,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [Center(child: ExpressPage()), Center(child: MetroPage())],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        color: AppColors.appbarColor,
        height: MediaQuery.of(context).size.width * 0.145,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PNRPage()));
              },
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white, size: 24),
                  SizedBox(width: 6),
                  Text("PNR", style: TextStyle(color: Colors.white, fontSize: 19)),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.03),
              color: Colors.grey,
              width: 1,
              height: MediaQuery.of(context).size.width,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TicketsPage()));
              },
              child: const Row(
                children: [
                  Icon(Icons.confirmation_num_outlined, color: Colors.white, size: 24),
                  SizedBox(width: 6),
                  Text("Tickets", style: TextStyle(color: Colors.white, fontSize: 19)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}