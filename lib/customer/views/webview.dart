import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:harvest/customer/models/orders.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'Basket/order_done.dart';


class WebViewExample extends StatefulWidget {
  final String url;
  final Order order;

  WebViewExample({Key key, this.url, this.order}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  bool showButton = false;

  onButtonClicked() {
    flutterWebviewPlugin.close();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDone(
            order: widget.order,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.launch(widget.url);
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      // print(url);
      if (url.contains('fail')) {
        Navigator.pop(context);
        flutterWebviewPlugin.close();
      } else if (url.contains('success')) {
        setState(() {
          showButton = true;
        });
      }
    });
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return
      Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: size.height * .9,
              child: WebviewScaffold(
                url: widget.url,
                withZoom: true,
              ),
            ),
            Container(
              width: size.width,
              height: showButton
                  ? size.height * .1:0,
              child: Center(
                child: showButton
                    ? GestureDetector(
                        onTap: () => onButtonClicked(),
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            height: 61,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: kPrimaryColor,
                            ),
                            child: Center(
                              child: Text(
                                'Save'.trs(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  height: 1.25,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      );
  }
}
