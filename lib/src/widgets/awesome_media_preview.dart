import 'dart:io';

import 'package:camerawesome/src/orchestrator/models/media_capture.dart';
import 'package:camerawesome/src/widgets/camera_awesome_builder.dart';
import 'package:camerawesome/src/widgets/utils/awesome_bouncing_widget.dart';
import 'package:camerawesome/src/widgets/utils/awesome_oriented_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AwesomeMediaPreview extends StatelessWidget {
  final MediaCapture? mediaCapture;
  final OnMediaTap onMediaTap;

  const AwesomeMediaPreview({
    super.key,
    required this.mediaCapture,
    required this.onMediaTap,
  });

  @override
  Widget build(BuildContext context) {
    return AwesomeOrientedWidget(
      child: AspectRatio(
        aspectRatio: 1,
        child: AwesomeBouncingWidget(
          onTap: mediaCapture != null &&
                  onMediaTap != null &&
                  mediaCapture?.status == MediaCaptureStatus.success
              ? () => onMediaTap!(mediaCapture!)
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white30,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white38,
                width: 2,
              ),
            ),
            child: ClipOval(child: _buildMedia(mediaCapture)),
          ),
        ),
      ),
    );
  }

  Widget _buildMedia(MediaCapture? mediaCapture) {
    switch (mediaCapture?.status) {
      case MediaCaptureStatus.capturing:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Platform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          ),
        );
      case MediaCaptureStatus.success:
        if (mediaCapture!.isPicture) {
          return Image(
            fit: BoxFit.cover,
            image: ResizeImage(
              FileImage(
                File(mediaCapture.filePath),
              ),
              width: 300,
            ),
          );
        } else {
          return Ink(
            child: const Icon(Icons.play_arrow),
          );
        }
      case MediaCaptureStatus.failure:
        return const Icon(Icons.error);
      case null:
        return const SizedBox(
          width: 32,
          height: 32,
        );
    }
  }
}