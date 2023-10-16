import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListedView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListedViewState();
  }
}

class _ListedViewState extends State<ListedView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Header'),
        Expanded(
          child: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
                tileColor: Color.fromARGB(
                    255, index ~/ 2 + 50, index * 3 + 10, index ~/ 2 + 11),
              );
            },
          ),
        )
      ],
    );
  }
}
