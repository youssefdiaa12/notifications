import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:notifications/model/fireBase.dart';
import 'package:notifications/viewModel/provider.dart';
import 'package:provider/provider.dart';

class ShowFiles extends StatefulWidget {
  static const routeName = '/showFiles';

  const ShowFiles({super.key});

  @override
  State<ShowFiles> createState() => _ShowFilesState();
}

class _ShowFilesState extends State<ShowFiles> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  PlatformFile? file;
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    var provider1 = Provider.of<provider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: FutureBuilder(
        future: FireBaseData.getFiles("${provider1.user!.email ?? ''}/files/"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return snapshot.data![index].contains('.jpeg')
                    ? Image.network(
                        snapshot.data![index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : // pdf show
                    FutureBuilder(
                        future: createFileOfPdfUrl(snapshot.data![index]),
                        builder: (context, pdfSnapshot) {
                          if (pdfSnapshot.hasError) {
                            return Text(
                                'Error downloading PDF: ${pdfSnapshot.error}');
                          }
                          if (pdfSnapshot.hasData) {
                            return Container(
                              height: 500,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              child: PDFView(
                                filePath: pdfSnapshot.data!.path,
                                enableSwipe: true,
                                swipeHorizontal: true,
                                autoSpacing: false,
                                pageFling: true,
                                onRender: (pages) {
                                  setState(() {
                                    pages = pages;
                                    isReady = true;
                                  });
                                },
                                onError: (error) {},
                                onPageError: (page, error) {},
                                onViewCreated:
                                    (PDFViewController pdfViewController) {
                                  _controller.complete(pdfViewController);
                                },
                                onPageChanged: (int? page, int? total) {
                                  setState(() {
                                    currentPage = page;
                                  });
                                },
                              ),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  const Text('something went wrong'),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('Refresh'))
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center();
          }
          return const Center();
        },
      ),
    );
  }

  Future<File> createFileOfPdfUrl(String url1) async {
    Completer<File> completer = Completer();
    try {
      final url = url1;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      // print("Download files");
      // print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
}
