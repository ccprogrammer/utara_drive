import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:utara_drive/helper/helper.dart';
import 'package:utara_drive/providers/add_gallery_provider.dart';
import 'package:utara_drive/providers/edit_gallery_provider.dart';
import 'package:utara_drive/providers/gallery_provider.dart';
import 'package:utara_drive/routes/routes.dart';
import 'package:utara_drive/themes/my_themes.dart';
import 'package:utara_drive/ui/Components/add_album_modal.dart';
import 'package:utara_drive/ui/Components/loading_fallback.dart';
import 'package:utara_drive/ui/Components/skeleton.dart';

class GalleryDetailScreen extends StatefulWidget {
  const GalleryDetailScreen({super.key, this.data});
  final dynamic data;

  @override
  State<GalleryDetailScreen> createState() => _GalleryDetailScreenState();
}

class _GalleryDetailScreenState extends State<GalleryDetailScreen> {
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

  handlSaveToAlbum() {
    Helper(ctx: context).showCustomModal(
      context: context,
      child: AddAlbumModal(gallery: widget.data),
    );
  }

  handleDelete() {
    String docId = widget.data is QueryDocumentSnapshot
        ? widget.data.id
        : widget.data['id'];
    Provider.of<AddGalleryProvider>(context, listen: false)
        .deleteGallery(context, docId, widget.data['image_name']);
  }

  handleDownload() {
    Helper().downloadFileFromUrl(url: widget.data['image_url']);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();

    FlutterDownloader.registerCallback(downloadCallback);

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
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingFallback(
      isLoading: Provider.of<AddGalleryProvider>(context).isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        bottomNavigationBar: buildBottomBar(),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Consumer<GalleryProvider>(
      builder: (context, provider, _) {
        // image from home sending QuerySnapshot object, image from album sending normal object. this widget.data.id is for QuerySnapshot because image from home doesn't have id in the object
        String id = widget.data is QueryDocumentSnapshot
            ? widget.data.id
            : widget.data['id'];

        // select gallery item from provider gallery list where selected gallery QuerySnapshot id from previous screen equal to album id in provider
        dynamic item = provider.galleryList
            .where((element) => element.id == id)
            .toList()[0];

        final date = Helper().convertTimestamp(item['created_at']);

        return OrientationBuilder(builder: (context, orientation) {
          return Stack(
            children: [
              // gallery content
              CachedNetworkImage(
                imageUrl: item['image_url'],
                imageBuilder: (context, imageProvider) => Hero(
                  tag: id,
                  child: PhotoView(
                    minScale: PhotoViewComputedScale.contained * 1,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    basePosition: Alignment.center,
                    customSize: orientation == Orientation.portrait
                        ? MediaQuery.of(context).size
                        : null,
                    scaleStateChangedCallback: (value) {},
                    onTapUp: (context, details, controllerValue) {
                      handleDetails();
                    },
                    controller: controller,
                    scaleStateController: scaleController,
                    backgroundDecoration:
                        const BoxDecoration(color: MyTheme.colorDarkPurple),
                    imageProvider: imageProvider,
                  ),
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
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width,
                  color: MyTheme.colorDarkPurple.withOpacity(0.6),
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
        });
      },
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
              color: MyTheme.colorDarkGrey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: MyTheme.colorDarkGrey,
            ),
          ),
        ],
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
            onPressed: () async {
              Provider.of<EditGalleryProvider>(context, listen: false)
                  .initTextController(
                label: widget.data['label'],
                description: widget.data['description'],
                location: widget.data['location'],
              );
              Navigator.pushNamed(context, AppRoute.edit,
                  arguments: widget.data);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            color: MyTheme.colorGrey,
            onPressed: () {
              Helper(ctx: context).shareContent(image: widget.data);
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            color: MyTheme.colorGrey,
            onPressed: () {
              handlSaveToAlbum();
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            color: MyTheme.colorGrey,
            onPressed: () {
              handleDelete();
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            color: MyTheme.colorGrey,
            onPressed: () {
              handleDownload();
            },
            icon: const Icon(Icons.file_download_outlined),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget appBar() {
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
