import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, this.data});
  final dynamic data;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  PhotoViewScaleStateController scaleController =
      PhotoViewScaleStateController();
  PhotoViewController controller = PhotoViewController();

  bool scaleAble = true;
  bool seeDetails = false;

  double detailsHeight = 0;

  handleDetails() {
    setState(() {
      seeDetails = !seeDetails;
      if (seeDetails) {
        detailsHeight = 0.6;
      } else {
        detailsHeight = 0.0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // controller.addIgnorableListener(() {
    //   var width = MediaQuery.of(context).size.width / 1000;
    //   double? scale = controller.scale;
    //   if (scale != null && scale < width) {
    //     setState(() {
    //       controller.scale = controller.initial.scale;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      bottomNavigationBar: BottomAppBar(
        color: MyTheme.colorWhite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_to_photos),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                handleDetails();
              },
              icon: Icon(
                  seeDetails ? Icons.arrow_circle_down : Icons.arrow_circle_up),
            ),
          ],
        ),
      ),
      body: Consumer<GalleryProvider>(
        builder: (context, provider, _) {
          final item = widget.data;
          final date = Helper().convertTimestamp(item['created_at']);

          return Stack(
            children: [
              // gallery content
              CachedNetworkImage(
                imageUrl: item['image_url'],
                imageBuilder: (context, imageProvider) => PhotoView(
                  customSize: MediaQuery.of(context).size,
                  minScale: PhotoViewComputedScale.contained * 1,
                  maxScale: PhotoViewComputedScale.covered * 1.8,
                  basePosition: Alignment.center,
                  scaleStateChangedCallback: (value) {},
                  controller: controller,
                  scaleStateController: scaleController,
                  backgroundDecoration:
                      const BoxDecoration(color: MyTheme.colorWhite),
                  imageProvider: imageProvider,
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[500]!,
                  highlightColor: Colors.grey[300]!,
                  child: const Skeleton(),
                ),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),

              // details modal
              Positioned(
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: MediaQuery.of(context).size.width,
                  color: MyTheme.colorWhite.withOpacity(0.3),
                  constraints: BoxConstraints(
                      maxHeight:
                          MediaQuery.of(context).size.height * detailsHeight),
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      buildDetails(
                        label: 'Label',
                        desc: item['label'],
                        marginTop: 0,
                      ),
                      buildDetails(
                        label: 'Description',
                        desc: item['description'],
                      ),
                      buildDetails(
                        label: 'Name',
                        desc: item['image_name'],
                      ),
                      buildDetails(
                        label: 'Location',
                        desc: item['location'],
                      ),
                      buildDetails(
                        label: 'Tag',
                        desc: 'Tagggggggg',
                      ),
                      buildDetails(
                        label: 'Date',
                        desc: date,
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget buildDetails({
    required String label,
    required String desc,
    double marginTop = 12,
  }) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: MyTheme.semiBold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: MyTheme.colorWhite,
      elevation: 0,
      title: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(backgroundColor: MyTheme.colorWhite),
        child: const Text(
          'Back',
          style: TextStyle(
            color: MyTheme.colorCyan,
          ),
        ),
      ),
    );
  }
}
