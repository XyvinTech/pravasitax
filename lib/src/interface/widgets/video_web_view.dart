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

  const VideoWebView({
    Key? key,
    required this.videoUrl,
    this.autoPlay = true,
    this.looping = true,
    this.onVideoEnd,
  }) : super(key: key);

  @override
  State<VideoWebView> createState() => _VideoWebViewState();
}

class _VideoWebViewState extends State<VideoWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

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
    // Convert HTTP URLs to HTTPS
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
          }
          .video-container {
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
          }
          video {
            width: 100%;
            height: 100%;
            object-fit: contain;
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
            controls
          >
            <source src="$secureUrl" type="video/mp4">
            Your browser does not support the video tag.
          </video>
        </div>
        <script>
          document.getElementById('videoPlayer').addEventListener('ended', function() {
            if (!${widget.looping}) {
              VideoChannel.postMessage('videoEnded');
            }
          });
        </script>
      </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: LoadingIndicator(
             
            ),
          ),
      ],
    );
  }
}
