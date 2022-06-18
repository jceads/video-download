//CAN DOWNLOAD VİDEO FROM DİZİYOU.COM

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:process_run/shell.dart';

void main(List<String> args) {
  searchAndDownload();
}

//https://www.diziyou.com/better-call-saul-1-sezon-2-bolum/ //this links works
searchAndDownload() async {
  final dio = Dio();
  final response =
      await dio.get("https://dizimag10.com/dizi/family-guy/1-sezon-1-bolum");
  final document = parseFragment(response.data);
  final anchors = document.querySelectorAll("iframe");

  String? newUrl;

  for (var attrib in anchors) {
    newUrl = attrib.attributes["src"];
  }
  if (newUrl == null) {
    print("url is null");
    return;
  }
  try {
    final newResponse = await dio.get(newUrl);
    final newDoc = parseFragment(newResponse.data);
    final newAnchors = newDoc.querySelectorAll("source");
    String? url;
    for (var element in newAnchors) {
      url = element.attributes["src"];
      print(url);
    }
    if (url == "null") return;

    downloadVideo(url);
  } on DioError catch (e) {
    if (e.type == DioErrorType.other) {
      print("geçersiz url");
    }
    print(e);
  }
}

downloadVideo(String? url) async {
  print("enter video name:");
  final shell = Shell();
  final String cmdCommand = "ffmpeg -i \"$url\" -codec copy asd.mp4";
  print(cmdCommand);
  await shell.run("$cmdCommand");
}
