import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../model/show_model.dart';
import '../view_model/show_view_model.dart';


class ShowDetailsPage extends StatefulWidget {
  final ShowModel show;

  const ShowDetailsPage({super.key, required this.show});

  @override
  State<ShowDetailsPage> createState() => _ShowDetailsPageState();
}

class _ShowDetailsPageState extends State<ShowDetailsPage> {

  @override
  void initState() {
    super.initState();

    // Load cast information after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<ShowViewModel>(context, listen: false);
      vm.loadCast(widget.show.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = theme.colorScheme.onSurface;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final chipBackground = theme.colorScheme.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Collapsible app bar with show image
          SliverAppBar(
            expandedHeight: 800,
            pinned: true,
            stretch: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.show.name,
                style: TextStyle(
                  color: textColor,
                  shadows: const [Shadow(blurRadius: 4, color: Colors.white)],
                ),
              ),

              // Show background image with gradient overlay
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.show.image != null)
                    CachedNetworkImage(
                      imageUrl: widget.show.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    )
                  else
                    Container(
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                    ),

                  // Top gradient for better title readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          isDark
                              ? Colors.black.withValues(alpha: 0.6)
                              : Colors.white.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Show details section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Rating
                  Text(
                    "⭐ Rating: ${widget.show.ratings.isNotEmpty ? widget.show.ratings : ""}",
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 12),

                  // Genres displayed as chips
                  Wrap(
                    spacing: 8,
                    children: widget.show.genreList
                        .map(
                          (genre) => Chip(
                        label: Text(
                          genre.toString(),
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: 12),

                  // Show metadata (status, premiere date, schedule, network)
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: textColor),
                      const SizedBox(width: 4),
                      Text(widget.show.status, style: TextStyle(color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: textColor),
                      const SizedBox(width: 4),
                      Text(widget.show.premiereDate, style: TextStyle(color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: textColor),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.show.daysList.join(", ")} ${widget.show.time}",
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.tv, size: 16, color: textColor),
                      const SizedBox(width: 4),
                      Text(
                        widget.show.network.isNotEmpty ? widget.show.network : "",
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Summary section
                  Text(
                    "Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Render HTML summary
                  Html(
                    data: widget.show.summary,
                    style: {
                      "body": Style(
                        fontSize: FontSize(14),
                        lineHeight: LineHeight(1.5),
                        color: textColor,
                      ),
                      "p": Style(margin: Margins.only(bottom: 12)),
                    },
                  ),

                  const SizedBox(height: 30),

                  // Cast section (loaded from ViewModel)
                  Consumer<ShowViewModel>(
                    builder: (context, vm, _) {
                      if (vm.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (vm.cast.isEmpty) {
                        return const Text("No cast information available");
                      }

                      // Horizontal list of cast members
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "Cast",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: vm.cast.length,
                              itemBuilder: (context, index) {
                                final actor = vm.cast[index];

                                return Container(
                                  width: 120,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    children: [
                                      // Actor image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: actor.image != null
                                            ? CachedNetworkImage(
                                          imageUrl: actor.image!,
                                          height: 120,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )
                                            : Container(
                                          height: 120,
                                          width: 100,
                                          color: Colors.grey,
                                          child: const Icon(Icons.person),
                                        ),
                                      ),
                                      const SizedBox(height: 6),

                                      // Actor name
                                      Text(
                                        actor.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Character name
                                      Text(
                                        actor.character,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
