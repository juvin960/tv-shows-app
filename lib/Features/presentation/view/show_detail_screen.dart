import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../data/model/show_model.dart';

class ShowDetailsPage extends StatelessWidget {
  final ShowModel show;

  const ShowDetailsPage({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                show.name,
                style: const TextStyle(
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (show.image != null)
                    Image.network(
                      show.image!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(color: Colors.grey.shade300),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
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

          // 🔹 Show Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text(
                    "⭐ Rating: ${show.ratings.isNotEmpty ? show.ratings : ""}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 12),


                  Wrap(
                    spacing: 8,
                    children: show.genreList
                        .map((genre) => Chip(label: Text(genre.toString())))
                        .toList(),
                  ),

                  const SizedBox(height: 12),


                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16),
                      const SizedBox(width: 4),
                      Text(show.status),
                    ],
                  ),

                  const SizedBox(height: 8),


                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(show.premiereDate),
                    ],
                  ),

                  const SizedBox(height: 8),


                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16),
                      const SizedBox(width: 4),
                      Text("${show.daysList.join(", ")} ${show.time}"),
                    ],
                  ),

                  const SizedBox(height: 8),


                  Row(
                    children: [
                      const Icon(Icons.tv, size: 16),
                      const SizedBox(width: 4),
                      Text(show.network.isNotEmpty ? show.network : "N/A"),
                    ],
                  ),

                  const SizedBox(height: 20),


                  const Text(
                    "Summary",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Html(
                    data: show.summary,
                    style: {
                      "body": Style(
                        fontSize: FontSize(14),
                        lineHeight: LineHeight(1.5),
                      ),
                      "p": Style(
                        margin: Margins.only(bottom: 12),
                      ),
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
