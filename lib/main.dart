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
  // 用于控制地址栏文本的内容
  final TextEditingController _urlController = TextEditingController(text: 'https://www.google.com');

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // 当网页开始加载时，自动更新地址栏的文本
          onPageStarted: (String url) {
            setState(() {
              _urlController.text = url;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_urlController.text));
  }

  // 处理网址输入的函数
  void _loadUrl() {
    String url = _urlController.text.trim();
    if (!url.startsWith('http')) {
      url = 'https://$url'; // 如果没写 http，自动补全
    }
    controller.loadRequest(Uri.parse(url));
    FocusScope.of(context).unfocus(); // 输入后收起键盘
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 将输入框放在标题位置
        title: TextField(
          controller: _urlController,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            hintText: '输入网址...',
            border: InputBorder.none,
          ),
          onSubmitted: (_) => _loadUrl(), // 按下回车键加载网页
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _loadUrl,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.reload(),
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
      bottomNavigationBar: BottomAppBar(
        child: Row(
