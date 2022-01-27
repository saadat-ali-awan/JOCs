import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class HtmlEditorTest extends StatelessWidget {
  HtmlEditorTest({Key? key}) : super(key: key);

  QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Theme(
              data: ThemeData(
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  )
              ),
              child: Container(color: Colors.black, padding: EdgeInsets.all(8.0),child: QuillToolbar.basic(controller: _controller))),
          Expanded(
            child: Container(
              color: Colors.white,
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            ),
          )
        ],
      )
    );
  }
}
