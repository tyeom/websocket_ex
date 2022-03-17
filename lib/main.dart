import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:websocket_ex/symbolInfo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Flutter Demo Home Page',
          channel: IOWebSocketChannel.connect('wss://pubwss.bithumb.com/pub/ws'),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePage({Key? key, required this.title, required this.channel}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _recvData = 'loading...';
  final List<SymbolInfo> _symbolInfoList = [];

  @override
  void initState() {
    super.initState();

    // 웹 소켓 메세지 수신
    widget.channel.stream.listen((message) async {
      setState(() {
        _recvData = message;

        var data = jsonDecode(message);
        if(data == null || data.containsKey('content') == false) return;

        var content = data['content'];
        var symbolInfo = SymbolInfo.fromJson(content);

        var findSymbolInfo = _symbolInfoList.firstWhere((element) =>
        element.symbol == symbolInfo.symbol,
            orElse: () => SymbolInfo(symbol: '', openPrice: "", lowPrice: "", highPrice: "", closePrice: "", volume: "", chgRate: "",));

        // 기존 추가된 Symbol 정보
        if (findSymbolInfo.symbol != '') {
          findSymbolInfo.openPrice = symbolInfo.openPrice;
          findSymbolInfo.lowPrice = symbolInfo.lowPrice;
          findSymbolInfo.highPrice = symbolInfo.highPrice;
          findSymbolInfo.closePrice = symbolInfo.closePrice;
          findSymbolInfo.volume = symbolInfo.volume;
          findSymbolInfo.chgRate = symbolInfo.chgRate;
        }
        else {
          _symbolInfoList.add(symbolInfo);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text('실시간 json 데이터 : ${_recvData}'),
              padding: EdgeInsets.only(left: 10, top: 20, bottom: 20),
            ),

            // 헤더
            Row(

              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    width: 80.0,
                    child: Text(
                      "코인명",
                      style: TextStyle(fontSize: 18),
                    )),

                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    width: 160.0,
                    child: Text(
                      "시가",
                      style: TextStyle(fontSize: 18),
                    )),

                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    width: 160.0,
                    child: Text(
                      "저가",
                      style: TextStyle(fontSize: 18),
                    )),

                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    width: 160.0,
                    child: Text(
                      "고가",
                      style: TextStyle(fontSize: 18),
                    )),

                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    width: 160.0,
                    child: Text(
                      "종가 (현재가)",
                      style: TextStyle(fontSize: 18),
                    )),

                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    width: 70.0,
                    child: Text(
                      "변동률",
                      style: TextStyle(fontSize: 18),
                    )),

                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    width: 200.0,
                    child: Text(
                      "누적 거래량",
                      style: TextStyle(fontSize: 18),
                    )),
              ],
            ),

            // 리스트뷰
            Expanded(
              child: ListView.builder(itemBuilder: (context, posirion) {
                return Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4.0),
                          width: 80.0,
                          child: Text(_symbolInfoList[posirion].symbol)
                      ),

                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4.0),
                          width: 160.0,
                          child: Text(_symbolInfoList[posirion].openPrice)
                      ),

                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4.0),
                          width: 160.0,
                          child: Text(_symbolInfoList[posirion].lowPrice)
                      ),

                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4.0),
                          width: 160.0,
                          child: Text(_symbolInfoList[posirion].highPrice)
                      ),

                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4.0),
                          width: 160.0,
                          child: Text(_symbolInfoList[posirion].closePrice)
                      ),

                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4.0),
                          width: 70.0,
                          child: Text(_symbolInfoList[posirion].chgRate)
                      ),

                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(4.0),
                          width: 200.0,
                          child: Text(_symbolInfoList[posirion].volume)
                      ),
                    ],
                  ),
                );
              }, itemCount: _symbolInfoList.length,),
            )
          ],
        )

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.channel.sink.add('{"type":"ticker", "symbols": ["BTC_KRW","XRP_KRW","ETH_KRW"],"tickTypes":["MID"]}');
        },
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }
}