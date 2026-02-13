import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_shows_appp/Features/presentation/view/show_detail_screen.dart';

import '../view model/show_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final vm = context.read<ShowViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadShows();
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
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
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShowViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("TV Shows", style: TextStyle(color: Colors.white)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search shows...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[900],
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

          body: Builder(
            builder: (_) {
              if (vm.errorMessage != null) {
                return ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 60),
                            const SizedBox(height: 16),
                            Text(
                              vm.errorMessage!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: vm.loadShows,
                              child: const Text("Retry"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (vm.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                // itemCount: vm.shows.length + (vm.hasMore ? 1 : 0),
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
                                    ? Image.network(
                                      show.image!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                    : Container(
                                      color: Colors.grey[800],
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),



                        Text(
                          show.genreNames,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20 ,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              show.ratings,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),


                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
