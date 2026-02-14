import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows_appp/Features/presentation/view/show_detail_screen.dart';
import 'package:tv_shows_appp/Features/utils/methods.dart' show Methods;
import '../../../main.dart';
import '../view_model/show_view_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  // for checking internet status
  InternetStatus? _internetConnectionStatus;
  late StreamSubscription<InternetStatus> _streamSubscription;



  @override
  void initState() {
    super.initState();
    final vm = context.read<ShowViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadShows();
    });

    // Enables infinity scroll and pagination
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // listen to internet connectivity changes
    _streamSubscription = InternetConnection().onStatusChange.listen((status) {
      setState(() {
        _internetConnectionStatus = status;
      });
    });
  }

  void _onScroll() {
    final vm = context.read<ShowViewModel>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      vm.loadMore();
    }
  }

  @override
  void dispose() {
    // dispose controllers
    _scrollController.dispose();
    _searchController.dispose();
    // cancel subscription
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sets the theme in the ui
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

        return Consumer<ShowViewModel>(
          builder: (context, vm, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "TV Shows",
                  style: TextStyle(color: isDark ? Colors.white : Colors.white),
                ),
                actions: [
                  IconButton(
                    icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () {
                      themeNotifier.value =
                      isDark ? ThemeMode.light : ThemeMode.dark;
                    },
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    // Enables the debounce search trigger method
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search shows...",
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[900] : Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        vm.search(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Searching..."),
                            duration: const Duration(milliseconds: 500),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double heightOfParentContainer = constraints.maxHeight;

                  if (vm.errorMessage != null) {
                    return ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  vm.errorMessage!,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  if (vm.isLoading) {
                    // return const Center(child: CircularProgressIndicator());
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8, // Adjust based on your card design
                        ),
                        itemCount: 6, // Number of placeholder items to show
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Rectangle for show image placeholder
                                FadeShimmer(
                                  height: 150,
                                  width: double.infinity,
                                  radius: 12,
                                  fadeTheme: isDark ? FadeTheme.dark : FadeTheme.light,
                                ),
                                SizedBox(height: 8),
                                // line for show name placeholder
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: FadeShimmer(
                                    height: 12,
                                    width: 120,
                                    radius: 4,
                                    fadeTheme: isDark ? FadeTheme.dark : FadeTheme.light,
                                  ),
                                ),
                                SizedBox(height: 6),
                                // show genres placeholder
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: FadeShimmer(
                                    height: 10,
                                    width: 80,
                                    radius: 4,
                                    fadeTheme: isDark ? FadeTheme.dark : FadeTheme.light,
                                  ),
                                ),
                                SizedBox(height: 6),
                                // show rating placeholder
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      FadeShimmer.round(
                                        fadeTheme: isDark ? FadeTheme.dark : FadeTheme.light, size: 12,
                                      ),
                                      SizedBox(width: 5),
                                      FadeShimmer(
                                        height: 10,
                                        width: 20,
                                        radius: 4,
                                        fadeTheme: isDark ? FadeTheme.dark : FadeTheme.light,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }

                  if (vm.shows.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "No results found",
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              vm.loadShows();
                            },
                            child: const Text("Refresh"),
                          ),
                        ],
                      ),
                    );
                  }


                  return Column(
                    children: [
                      SizedBox(

                        //checking for internet availability
                        height: _internetConnectionStatus == InternetStatus.disconnected? heightOfParentContainer * 0.94:
                        heightOfParentContainer * 1,
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            // show 4 items for tablet and 2 for mobile
                            crossAxisCount: Methods.isTabletScreen(context: context) ? 4 : 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: vm.shows.length,
                          itemBuilder: (context, index) {
                            final show = vm.shows[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShowDetailsPage(show: show),
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${show.name} selected"),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:
                                      show.image != null

                                      //CachedNetworkImage for offline viewing

                                          ? CachedNetworkImage(
                                        imageUrl: show.image ?? "",
                                        imageBuilder:
                                            (
                                            context,
                                            imageProvider,
                                            ) => Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        errorWidget:
                                            (context, url, error) =>
                                            Icon(Icons.error),
                                      )
                                          : Container(
                                        color:
                                        isDark
                                            ? Colors.grey[800]
                                            : Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.tv,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    show.name,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    show.genreNames,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        show.ratings,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isDark ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: _internetConnectionStatus == InternetStatus.disconnected,
                        child: SizedBox(
                          height: heightOfParentContainer * 0.06,
                          child: Container(
                            width:  MediaQuery.of(context).size.width * 1,
                            color:  isDark ? Colors.grey[900] : Colors.white,
                            alignment: Alignment.center,
                            child: Text(
                              "You are offline",
                              style: TextStyle(
                                  color:isDark ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),


              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                selectedItemColor: isDark ? Colors.white : Colors.red,
                unselectedItemColor: isDark ? Colors.white54 : Colors.black54,
                currentIndex: _selectedIndex,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.tv), label: "Shows"),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: "Favorites",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: "Settings",
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });

                  final vm = context.read<ShowViewModel>();

                  switch (index) {
                    case 0:
                      _searchController.clear();
                      vm.loadShows();
                      Navigator.popUntil(context, (route) => route.isFirst);
                      break;
                    case 1:
                      break;
                    case 2:
                      break;
                  }
                },
              ),
            );
          },
        );
  }
}

