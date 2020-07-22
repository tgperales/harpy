import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/api/media_data.dart';

/// Builds the images for the [TweetMedia].
///
/// Up to 4 images are built using [images].
class TweetImages extends StatelessWidget {
  const TweetImages(this.images);

  final List<ImageData> images;

  /// The padding between each image.
  static const double _padding = 2;

  Widget _buildImage(
    ImageData image, {
    bool topLeft = false,
    bool bottomLeft = false,
    bool topRight = false,
    bool bottomRight = false,
  }) {
    const Radius radius = Radius.circular(8);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: topLeft ? radius : Radius.zero,
        bottomLeft: bottomLeft ? radius : Radius.zero,
        topRight: topRight ? radius : Radius.zero,
        bottomRight: bottomRight ? radius : Radius.zero,
      ),
      child: CachedNetworkImage(
        imageUrl: image.medium,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget _buildOneImage() {
    return _buildImage(
      images[0],
      topLeft: true,
      bottomLeft: true,
      topRight: true,
      bottomRight: true,
    );
  }

  Widget _buildTwoImages() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildImage(
            images[0],
            topLeft: true,
            bottomLeft: true,
          ),
        ),
        const SizedBox(width: _padding),
        Expanded(
          child: _buildImage(
            images[1],
            topRight: true,
            bottomRight: true,
          ),
        ),
      ],
    );
  }

  Widget _buildTheeImages() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildImage(
            images[0],
            topLeft: true,
            bottomLeft: true,
          ),
        ),
        const SizedBox(width: _padding),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildImage(
                  images[1],
                  topRight: true,
                ),
              ),
              const SizedBox(height: _padding),
              Expanded(
                child: _buildImage(
                  images[2],
                  bottomRight: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFourImages() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildImage(
                  images[0],
                  topLeft: true,
                ),
              ),
              const SizedBox(height: _padding),
              Expanded(
                child: _buildImage(
                  images[2],
                  bottomLeft: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: _padding),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildImage(
                  images[1],
                  topRight: true,
                ),
              ),
              const SizedBox(height: _padding),
              Expanded(
                child: _buildImage(
                  images[3],
                  bottomRight: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      return _buildOneImage();
    } else if (images.length == 2) {
      return _buildTwoImages();
    } else if (images.length == 3) {
      return _buildTheeImages();
    } else if (images.length == 4) {
      return _buildFourImages();
    } else {
      return const SizedBox();
    }
  }
}