import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ionicons/ionicons.dart';

import 'image_data.dart';

void main() => runApp(const MyApp());

// stateful widget with a bottom navigation bar to switch between the different screens (widegts)
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const StandardGrid(),
    const StandardStaggeredGrid(),
    const InstagramSearchGrid(),
    const PinterestGrid(),
    const Quilted(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staggered Grids App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Staggered Grid View'),
          backgroundColor: CupertinoColors.activeBlue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _currentIndex == 0 || _currentIndex == 4
              ? _children[_currentIndex]
              : SingleChildScrollView(child: _children[_currentIndex]),
        ),
        bottomNavigationBar: Container(
          color: CupertinoColors.activeBlue,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: CupertinoColors.activeBlue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.rectangle_3_offgrid_fill),
                label: 'StandardGrid',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_3x3),
                label: 'StandardStaggeredGrid',
              ),
              BottomNavigationBarItem(
                icon: Icon(Ionicons.logo_instagram),
                label: 'InstagramSearchGrid',
              ),
              BottomNavigationBarItem(
                icon: Icon(Ionicons.logo_pinterest),
                label: 'PinterestGrid',
              ),
              BottomNavigationBarItem(
                icon: Icon(Ionicons.reader_outline),
                label: 'Quilted',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StandardGrid extends StatelessWidget {
  const StandardGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: imageList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) => ImageCard(
        imageData: imageList[index],
        imageHeight: 200,
        imageWidth: 200,
      ),
    );
  }
}

class StandardStaggeredGrid extends StatelessWidget {
  const StandardStaggeredGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiles = [
      const GridTile(2, 2),
      const GridTile(2, 1),
      const GridTile(1, 2),
      const GridTile(1, 1),
      const GridTile(2, 2),
      const GridTile(1, 2),
      const GridTile(1, 1),
      const GridTile(3, 1),
      const GridTile(1, 1),
      const GridTile(4, 1),
    ];

    return StaggeredGrid.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: [
        ...List.generate(
          tiles.length,
          (index) {
            final tile = tiles[index];
            return ImageCard(
              imageData: imageList[index],
              imageWidth: tile.crossAxisCount * 200,
              imageHeight: tile.mainAxisCount * 200,
            );
            // return StaggeredGridTile.count(
            //   crossAxisCellCount: tile.crossAxisCount,
            //   mainAxisCellCount: tile.mainAxisCount,
            //   child: ImageCard(
            //     imageData: imageList[index],
            //     imageWidth: 200,
            //     imageHeight: 200,
            //   ),
            // );
          },
        ),
      ],
    );
  }
}

class InstagramSearchGrid extends StatelessWidget {
  const InstagramSearchGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: [
        ...List.generate(
          imageList.length,
          (index) {
            final tile = GridTile(
              (index % 7 == 0) ? 2 : 1,
              (index % 7 == 0) ? 2 : 1,
            );
            return ImageCard(
              imageData: imageList[index],
              imageWidth: tile.crossAxisCount * 200,
              imageHeight: tile.mainAxisCount * 200,
            );
          },
        ),
      ],
    );
  }
}

class PinterestGrid extends StatelessWidget {
  const PinterestGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: [
        ...List.generate(
          imageList.length,
          (index) {
            // randomize the tile size
            final width = Random.secure().nextInt(imageList.length) + 1;
            final tile = GridTile(width, (width % 2));
            return ImageCard(
              imageData: imageList[index],
              imageWidth: tile.crossAxisCount * 200,
              imageHeight: tile.mainAxisCount * 300,
            );
          },
        ),
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.imageData,
    required this.imageWidth,
    required this.imageHeight,
  }) : super(key: key);
  final ImageData imageData;

  //
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: CachedNetworkImage(
        imageUrl: imageData.imageUrl,
        fit: BoxFit.cover,
        height: imageHeight,
        width: imageWidth,
      ),
    );
  }
}

class GridTile {
  const GridTile(this.crossAxisCount, this.mainAxisCount);
  final int crossAxisCount;
  final int mainAxisCount;
}

class Quilted extends StatelessWidget {
  const Quilted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          const QuiltedGridTile(2, 2),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 2),
        ],
      ),
      itemCount: imageList.length,
      itemBuilder: (BuildContext context, int index) {
        return ImageCard(
          imageData: imageList[index],
          imageHeight: 200,
          imageWidth: 200,
        );
      },
    );
  }
}
