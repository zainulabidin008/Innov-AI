// ignore_for_file: await_only_futures, deprecated_member_use, must_be_immutable, avoid_print, depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../constants/app_colors.dart';

class AppVideoPlayer extends StatefulWidget {
  String videoUrl;
  bool locale;

  AppVideoPlayer({
    super.key,
    this.videoUrl = '',
    this.locale = false,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  double maxHeight = 370.h;
  var height;

  initializeVideo() async {
    if (widget.locale) {
      videoPlayerController =
          await VideoPlayerController.asset('assets/videos/welcome_video.mp4')
            ..initialize().then((value) {
              setState(() {});
            })
            ..setLooping(true);
    } else {
      videoPlayerController =
          await VideoPlayerController.network(widget.videoUrl)
            ..initialize().then((value) async {
              if (videoPlayerController!.value.size.height <
                  videoPlayerController!.value.size.width) {
                height = videoPlayerController!.value.size.height;
              } else {
                if (videoPlayerController!.value.size.height > maxHeight) {
                  height = maxHeight;
                } else {
                  height = videoPlayerController!.value.size.height;
                }
              }

              setState(() {});
            })
            ..setLooping(true);
    }
  }

  @override
  void initState() {
    initializeVideo();

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController != null &&
            videoPlayerController!.value.isInitialized
        ? SizedBox(
            width: Get.width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                var offset = 0.0;
                var videoRatio = videoPlayerController!.value.size.width /
                    videoPlayerController!.value.size.height;
                offset = ((constraints.maxWidth / videoRatio) - maxHeight) / 2;

                return VisibilityDetector(
                  key: ObjectKey(videoPlayerController),
                  onVisibilityChanged: (visibility) {
                    if (visibility.visibleFraction > 0.8) {
                      videoPlayerController?.play();
                    } else {
                      if (videoPlayerController!.value.isInitialized) {
                        videoPlayerController?.pause();
                      }
                    }
                  },
                  child: SizedBox(
                    height: maxHeight,
                    child: Center(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: ScrollController(
                                initialScrollOffset: offset,
                                keepScrollOffset: true),
                            child: AspectRatio(
                              aspectRatio:
                                  videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.black,
            ),
          );
  }
}
