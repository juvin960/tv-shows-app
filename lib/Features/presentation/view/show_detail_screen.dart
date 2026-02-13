import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../main.dart';
import '../../data/model/show_model.dart';

class ShowDetailsPage extends StatelessWidget {
  final ShowModel show;

  const ShowDetailsPage({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;

        final textColor = isDark ? Colors.white : Colors.black;
        final backgroundColor = isDark ? Colors.black : Colors.white;
        final chipBackground = isDark ? Colors.grey[800] : Colors.grey[300];

        return Scaffold(
          backgroundColor: backgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                stretch: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: textColor),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    show.name,
                    style: TextStyle(
                      color: textColor,
                      shadows: const [
                        Shadow(blurRadius: 4, color: Colors.black54)
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (show.image != null)
                        Image.network(show.image!, fit: BoxFit.cover)
                      else
                        Container(color: isDark ? Colors.grey[800] : Colors.grey[300]),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              isDark
                                  ? Colors.black.withOpacity(0.6)
                                  : Colors.white.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating
                      Text(
                        "⭐ Rating: ${show.ratings.isNotEmpty ? show.ratings : ""}",
                        style: TextStyle(fontSize: 16, color: textColor),
                      ),
                      const SizedBox(height: 12),

                      // Genres
                      Wrap(
                        spacing: 8,
                        children: show.genreList
                            .map((genre) => Chip(
                          label: Text(
                            genre.toString(),
                            style: TextStyle(color: textColor),
                          ),
                          backgroundColor: chipBackground,
                        ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),

                      // Status
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: textColor),
                          const SizedBox(width: 4),
                          Text(show.status, style: TextStyle(color: textColor)),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Premiere Date
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: textColor),
                          const SizedBox(width: 4),
                          Text(show.premiereDate, style: TextStyle(color: textColor)),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Schedule
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: textColor),
                          const SizedBox(width: 4),
                          Text("${show.daysList.join(", ")} ${show.time}",
                              style: TextStyle(color: textColor)),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Network
                      Row(
                        children: [
                          Icon(Icons.tv, size: 16, color: textColor),
                          const SizedBox(width: 4),
                          Text(show.network.isNotEmpty ? show.network : "",
                              style: TextStyle(color: textColor)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Summary
                      Text(
                        "Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Html(
                        data: show.summary,
                        style: {
                          "body": Style(
                            fontSize: FontSize(14),
                            lineHeight: LineHeight(1.5),
                            color: textColor,
                          ),
                          "p": Style(margin: Margins.only(bottom: 12)),
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
