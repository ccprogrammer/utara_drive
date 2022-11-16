import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/themes/my_themes.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatefulWidget {
  const VideoDetailScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  final dynamic data;

  @override
  State<StatefulWidget> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(
        "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4");

    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
      materialProgressColors: ChewieProgressColors(
        bufferedColor: MyTheme.colorPurple.withOpacity(0.3),
        playedColor: MyTheme.colorPurple,
      ),
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: () {},
            iconData: Icons.download_rounded,
            title: 'Download',
          ),
        ];
      },
      hideControlsTimer: const Duration(seconds: 1),
    );
  }

  handleDownload() {
    Helper().downloadFileFromUrl(url: widget.data['file_url']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      backgroundColor: MyTheme.colorDarkPurple,
      body: SafeArea(
        child: Center(
          child: _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController!,
                )
              : Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          color: MyTheme.colorCyan,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Loading video',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: MyTheme.colorGrey,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    // not using container because the ripple effect from icon button is not showing so i change it to BottomAppBar

    return BottomAppBar(
      color: MyTheme.colorBlueGrey,
      elevation: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            color: MyTheme.colorGrey,
            onPressed: () async {},
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            color: MyTheme.colorGrey,
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          IconButton(
            color: MyTheme.colorGrey,
            onPressed: () {},
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            color: MyTheme.colorGrey,
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            color: MyTheme.colorGrey,
            onPressed: () {},
            icon: const Icon(Icons.file_download_outlined),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: MyTheme.colorDarkPurple,
      elevation: 0,
      title: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(backgroundColor: MyTheme.colorBlueGrey),
        child: const Text(
          'Back',
          style: TextStyle(
            color: MyTheme.colorGrey,
          ),
        ),
      ),
    );
  }
}
