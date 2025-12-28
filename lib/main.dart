import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const MaterialApp(home: MyBrowser()));

class MyBrowser extends StatefulWidget {
  const MyBrowser({super.key});
  @override
  State<MyBrowser> createState() => _MyBrowserState();
}

class _MyBrowserState extends State<MyBrowser> {
  late final WebViewController controller;
  final TextEditingController _urlController = TextEditingController(text: 'https://www.baidu.com');

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_urlController.text));
  }

  void _loadUrl() {
    String url = _urlController.text.trim();
    if (!url.startsWith('http')) url = 'https://$url';
    controller.loadRequest(Uri.parse(url));
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _urlController,
          decoration: const InputDecoration(hintText: '输入网址...'),
          onSubmitted: (_) => _loadUrl(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => controller.reload()),
        ],
      ),
      body: WebViewWidget(controller: controller),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () async {
              if (await controller.canGoBack()) await controller.goBack();
            }),
            IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () async {
              if (await controller.canGoForward()) await controller.goForward();
            }),
          ],
        ),
      ),
    );
  }
}
