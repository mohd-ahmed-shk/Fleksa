import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final WebViewController _controller = WebViewController();
  double progress = 0;
  String onPageStarted = "";


  Future<void> _canPop() async {
    final NavigatorState navigator = Navigator.of(context);
    if (await _controller.canGoBack()) {
      _controller.goBack();
    } else {
      navigator.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) {
          setState(() {
            progress = p/100;
            print("==progress----*******---------$p-----------------");
          });
        },
        onPageStarted: (url) {
          onPageStarted = url;
          print("==onPageStarted--/////-----------$url-----------------");

        },
        onUrlChange: (change) {
          print("==onUrlChange-------===------$change-----------------");


        },
        onPageFinished: (url) {
          print("==onPageFinished-------+++++------$url-----------------");

        },

      ))
      ..clearCache()
      ..clearLocalStorage()
      ..enableZoom(true)
      ..loadRequest(Uri.parse("https://prodtestv3.fleksa.de/"));


    // print('===========${_controller.reload}=============');
    // print('===========${_controller.getTitle()}=============');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _canPop();
      },

      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SafeArea(
          child: Column(children: [
            if(progress > 0 && progress < 1)
              LinearProgressIndicator(
                value: progress,
                valueColor: const AlwaysStoppedAnimation(
                  Colors.cyan,
                ),
                backgroundColor: Colors.greenAccent,
              ),
            Text(onPageStarted,style: const TextStyle(color: Colors.white),),
            Expanded(
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
