import 'package:nrs_tele_apps/config/global.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/show_loading_dialog.dart';
import 'package:nrs_tele_apps/widgets/global_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/widgets/custom_container.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DownloadModal extends ConsumerStatefulWidget {
  final audioList;
  final videoList;

  DownloadModal({
    Key? key,
    required this.audioList,
    required this.videoList,
  }) : super(key: key);

  @override
  ConsumerState<DownloadModal> createState() => _DownloadModalState();
}

class _DownloadModalState extends ConsumerState<DownloadModal> {
  Map<String, bool> _selectedMedia = {};
  List<String> audioFilenames = [];
  List<String> videoFilenames = [];
  List<String> selectedMediaUrls = [];
  bool _isDownloading = false;
  bool _isSelected = false;
  String mediaName = '';
  String filename = '';
  String newFileName = '';
  String pathname = '';
  double dynamicHeight = 0;
  var dynamicMargin;

  @override
  void initState() {
    super.initState();
    AppDebug().printDebug(
        msg: 'widgetinitialstate:${widget.audioList},${widget.videoList}');

    // loading();
    getData();
  }

  getData() {
    if (widget.audioList != null) {
      if (mounted) {
        setState(() {
          mediaName = 'audio';
        });
      }
    } else if (widget.videoList != null) {
      if (mounted) {
        setState(() {
          mediaName = 'video';
        });
      }
    }
    AppDebug().printDebug(msg: 'medianame:$mediaName');
  }

  setHeight(list) {
    if (list.length == 1) {
      dynamicHeight = Adaptive.h(20);
    } else if (list.length == 2) {
      dynamicHeight = Adaptive.h(25);
    } else if (list.length == 3) {
      dynamicHeight = Adaptive.h(35);
    } else if (list.length == 4) {
      dynamicHeight = Adaptive.h(45);
    } else if (list.length == 5) {
      dynamicHeight = Adaptive.h(55);
    } else if (list.length >= 6) {
      dynamicHeight = Adaptive.h(65);
    }
  }

  setMargin(list) {
    double screenHeight = MediaQuery.of(context).size.height;
    if (list.length == 1) {
      dynamicMargin = EdgeInsets.only(top: screenHeight * 0.3);
    } else if (list.length == 2 || list.length == 3) {
      dynamicMargin = EdgeInsets.only(top: screenHeight * 0.2);
    } else if (list.length >= 4) {
      dynamicMargin = EdgeInsets.only(top: screenHeight * 0.1);
    }
    // else {
    //   dynamicMargin = EdgeInsets.only(top: Adaptive.h(15));
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (mediaName == 'audio') setMargin(widget.audioList);
    if (mediaName == 'video') setMargin(widget.videoList);

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        margin: dynamicMargin,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ],
            ),
            if (mediaName == 'audio') audioDataList(),
            if (mediaName == 'video') videoDataList(),
          ],
        ),
      ),
    );
  }

  Widget audioDataList() {
    setHeight(widget.audioList);
    return widget.audioList.isNotEmpty
        ? Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0), color: Colors.white),
              width: double.maxFinite,
              height: dynamicHeight,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.audioList.length,
                      itemBuilder: (context, index) {
                        final data = widget.audioList[index];
                        String filename = data['audio_name'];
                        String pathname = data['audio_path'];

                        return CheckboxListTile(
                          title: Text(filename),
                          value: _selectedMedia[pathname] ?? false,
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedMedia[pathname] = value ?? false;
                              if (value == true) {
                                audioFilenames.add(filename);
                              } else {
                                audioFilenames.remove(filename);
                              }
                              _isSelected = _selectedMedia.containsValue(true);
                            });
                            AppDebug()
                                .printDebug(msg: '${_selectedMedia[pathname]}');
                          },
                          controlAffinity: ListTileControlAffinity.trailing,
                        );
                      },
                    ),
                  ),
                  downloadButton(),
                ],
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              children: [
                Center(child: Image.asset('assets/icons/no-audio.png')),
                Center(
                    child: const Text('No audio available for this campaign')),
              ],
            ),
          );
  }

  Widget videoDataList() {
    setHeight(widget.videoList);
    return widget.videoList.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0), color: Colors.white),
            width: double.maxFinite,
            height: dynamicHeight,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.videoList.length,
                    itemBuilder: (context, index) {
                      final data = widget.videoList[index];
                      String filename = data['video_name'];
                      String pathname = data['video_path'];

                      return CheckboxListTile(
                        title: Text(filename),
                        value: _selectedMedia[pathname] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedMedia[pathname] = value ?? false;
                            if (value == true) {
                              videoFilenames.add(filename);
                            } else {
                              videoFilenames.remove(filename);
                            }
                            _isSelected = _selectedMedia.containsValue(true);
                          });
                          AppDebug()
                              .printDebug(msg: '${_selectedMedia[pathname]}');
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                      );
                    },
                  ),
                ),
                downloadButton(),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              children: [
                Center(child: Image.asset('assets/icons/no-video.png')),
                Center(
                    child: const Text('No video available for this campaign')),
              ],
            ),
          );
  }

  Widget downloadButton() {
    return Container(
      color: Colors.white,
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Adaptive.w(5), vertical: Adaptive.h(2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isDownloading
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.primary,
                    ),
                    width: Adaptive.w(60),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Adaptive.h(2)),
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          strokeAlign:
                              CircularProgressIndicator.strokeAlignCenter,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  )
                : CustomContainer(
                    onPressed: () {
                      _isSelected
                          ? _startDownload()
                          : showCustomDialog(context, '',
                              'Please choose file to download', 'OK', () {
                              AppDebug().printDebug(msg: 'OK is press');
                            });
                    },
                    title: 'DOWNLOAD',
                    color: Colors.white,
                    backgroundColor: AppColors.primary,
                    width: Adaptive.w(60),
                    borderRadius: BorderRadius.circular(5),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _startDownload() async {
    setState(() {
      _isDownloading = true;
    });

    selectedMediaUrls = _selectedMedia.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    AppDebug().printDebug(msg: 'selectedmediaurl:$selectedMediaUrls');

    await _downloadAudioVideo(selectedMediaUrls);
  }

  Future<void> _downloadAudioVideo(List<String> selectedMediaUrls) async {
    try {
      List<DownloadTask> taskList = [];
      int successCount = 0;
      int failCount = 0;
      List<String> failedFilenames = [];

      for (int i = 0; i < selectedMediaUrls.length; i++) {
        var mediaUrl = selectedMediaUrls[i];

        if (mediaName == 'audio') {
          newFileName = '${audioFilenames[i]}.mp3';
        } else if (mediaName == 'video') {
          newFileName = '${videoFilenames[i]}.mp4';
        }

        final downloadPath = await getDownloadDirectory();

        // Create a download task for each media URL
        final task = DownloadTask(
          url: mediaUrl,
          filename: newFileName,
          directory: downloadPath,
          updates: Updates.statusAndProgress,
          metaData: 'Downloading audio/video',
        );

        taskList.add(task); // Add the task to the list
      }

      if (taskList.length > 1) {
        // Handle batch download if more than one item is selected
        final result = await FileDownloader().downloadBatch(taskList,
            batchProgressCallback: (succeeded, failed) => AppDebug().printDebug(
                msg:
                    'Completed $succeeded out of ${taskList.length}, $failed failed'));

        // Handle results for each task
        for (var entry in result.results.entries) {
          final task = entry.key;
          final status = entry.value;

          if (status == TaskStatus.complete && task is DownloadTask) {
            AppDebug()
                .printDebug(msg: 'Download complete for: ${task.filename}');
            successCount++;

            final newFilePath = await FileDownloader()
                .moveToSharedStorage(task, SharedStorage.downloads);

            if (newFilePath == null) {
              AppDebug().printDebug(
                  msg:
                      'Failed to move the file to shared storage for: ${task.filename}');
            } else {
              AppDebug().printDebug(msg: 'File moved to: $newFilePath');
            }
          } else {
            AppDebug().printDebug(msg: 'Download failed for: ${task.filename}');
            failCount++;
            failedFilenames
                .add(task.filename); // Add the failed filename to the list
          }
        }

        // Show a single dialog summarizing the results, including failed filenames
        String failedFilesMessage = failedFilenames.isNotEmpty
            ? 'Files failed to download:\n${failedFilenames.join('\n')}'
            : '';

        String downloadCompleteMessage = failCount == 0
            ? 'Download complete!'
            : 'Download complete: $successCount\nDownload failed: $failCount\n$failedFilesMessage';

        showCustomDialog(
          context,
          '',
          downloadCompleteMessage,
          'OK',
          () {},
        );
      } else {
        // Handle single item download
        final result = await FileDownloader().download(
          taskList.first, // Since we only have one task, get the first one
          onProgress: (progress) =>
              AppDebug().printDebug(msg: 'Progress: ${progress * 100}%'),
          onStatus: (status) => AppDebug().printDebug(msg: 'Status: $status'),
        );

        switch (result.status) {
          case TaskStatus.complete:
            AppDebug().printDebug(
                msg: 'Download complete: ${taskList.first.filename}');
            final newFilePath = await FileDownloader()
                .moveToSharedStorage(taskList.first, SharedStorage.downloads);

            if (newFilePath == null) {
              AppDebug().printDebug(
                  msg: 'Failed to move the file to shared storage.');
            } else {
              AppDebug().printDebug(msg: 'File moved to: $newFilePath');
            }

            showCustomDialog(context, '', 'Download complete!', 'OK', () {});
            break;
          case TaskStatus.canceled:
            AppDebug().printDebug(msg: 'Download was canceled');
            break;
          case TaskStatus.paused:
            AppDebug().printDebug(msg: 'Download was paused');
            break;
          default:
            AppDebug().printDebug(msg: 'Download failed');
            failedFilenames.add(taskList.first.filename); // Add failed filename

            showCustomDialog(
                context,
                '',
                'Download failed for: ${taskList.first.filename}!',
                'OK',
                () {});
        }
      }
    } catch (e) {
      AppDebug().printDebug(msg: 'Error downloading media: $e');
      GlobalUtils.showFloatingMessage(context, 'Error downloading media');
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  Future<String> getDownloadDirectory() async {
    if (Platform.isIOS) {
      AppDebug().printDebug(msg: 'Platform is IOS');

      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else if (Platform.isAndroid) {
      AppDebug().printDebug(msg: 'Platform is android');
      final directory = '/storage/emulated/0/Download/';
      return directory;
    } else {
      throw Exception('Unsupported platform');
    }
  }
}
