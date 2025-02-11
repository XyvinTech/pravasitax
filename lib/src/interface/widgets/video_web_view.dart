import 'package:flutter/material.dart';
import 'package:pravasitax_flutter/src/interface/widgets/loading_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'dart:developer' as developer;

class VideoWebView extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final VoidCallback? onVideoEnd;
  final double borderRadius;

  const VideoWebView({
    Key? key,
    required this.videoUrl,
    this.autoPlay = true,
    this.looping = true,
    this.onVideoEnd,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  State<VideoWebView> createState() => _VideoWebViewState();
}

class _VideoWebViewState extends State<VideoWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..addJavaScriptChannel(
        'VideoChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'videoEnded' && widget.onVideoEnd != null) {
            widget.onVideoEnd!();
          } else if (message.message == 'videoPlaying') {
            setState(() => _isPlaying = true);
          } else if (message.message == 'videoPaused') {
            setState(() => _isPlaying = false);
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            developer.log('Web Resource Error: ${error.description}',
                name: 'VideoWebView');
          },
        ),
      )
      ..loadHtmlString(_generateHtmlContent());
  }

  String _generateHtmlContent() {
    String secureUrl = widget.videoUrl;
    if (secureUrl.startsWith('http://')) {
      secureUrl = 'https://' + secureUrl.substring(7);
    }

    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body {
            margin: 0;
            padding: 0;
            background-color: black;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            border-radius: ${widget.borderRadius}px;
            overflow: hidden;
          }
          .video-container {
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            border-radius: ${widget.borderRadius}px;
            overflow: hidden;
          }
          video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: ${widget.borderRadius}px;
          }
        </style>
      </head>
      <body>
        <div class="video-container">
          <video
            id="videoPlayer"
            webkit-playsinline
            playsinline
            ${widget.autoPlay ? 'autoplay' : ''}
            ${widget.looping ? 'loop' : ''}
          >
            <source src="$secureUrl" type="video/mp4">
            Your browser does not support the video tag.
          </video>
        </div>
        <script>
          const video = document.getElementById('videoPlayer');
          
          video.addEventListener('play', function() {
            VideoChannel.postMessage('videoPlaying');
          });
          
          video.addEventListener('pause', function() {
            VideoChannel.postMessage('videoPaused');
          });
          
          video.addEventListener('ended', function() {
            if (!${widget.looping}) {
              VideoChannel.postMessage('videoEnded');
            }
          });
          
          // Add touch/click event to toggle play/pause
          document.body.addEventListener('click', function() {
            if (video.paused) {
              video.play();
            } else {
              video.pause();
            }
          });
        </script>
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: LoadingIndicator(),
              ),
            ),
          if (!_isPlaying && !_isLoading)
            GestureDetector(
              onTap: () {
                _controller.runJavaScript(
                    'document.getElementById("videoPlayer").play()');
              },
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 50,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
