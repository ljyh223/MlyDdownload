// import 'package:provider/provider.dart';

import '../src/down.dart';
import 'package:flutter/material.dart';
import 'MusicItem.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:developer' as dev;

class DownListParent extends StatefulWidget {
  const DownListParent({Key? key, required this.items}) : super(key: key);

  final List<ListItem> items;

  @override
  State<DownListParent> createState() => DownList(items);
}

class DownList extends State<DownListParent> {
  final List<ListItem> items;

  DownList(this.items);

  @override
  Widget build(BuildContext context) {
    // final _counter = Provider.of<CounterModel>(context);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        int itemNumber = index + 1;
        return ListTile(
          title: item.buildTitle(context),
          leading: Text('$itemNumber'),
          subtitle: item.buildSubtitle(context),
          trailing: StreamBuilder<List<double>>(
            stream: downloadInfos[index].stream, //
//initialData: ,// a Stream<int> or null
            builder: (BuildContext context,
                AsyncSnapshot<List<double>> snapshotDownfile) {
              if (snapshotDownfile.hasError) {
                return const Icon(Icons.error);
              }
              switch (snapshotDownfile.connectionState) {
//none
                case ConnectionState.none:
                  dev.log('none');
                  return const Icon(Icons.check);
                case ConnectionState.waiting:
                  dev.log('wait');
                  return CircularPercentIndicator(
                    radius: 18.0,
                    lineWidth: 2.0,
                    percent: 0,
                    center: const Text(
                      "0%",
                      style: TextStyle(fontSize: 8.0),
                    ),
                    progressColor: Colors.green,
                  );
                case ConnectionState.active:
                  return snapshotDownfile.data![index]!=-1?
                   CircularPercentIndicator(
                    radius: 18.0,
                    lineWidth: 2.0,
                    percent:
                        snapshotDownfile.data![index],
                    center: Text(
                      "${snapshotDownfile.data![index] * 100}%",
                      style: const TextStyle(fontSize: 8.0),
                    ),
                    progressColor: Colors.green,
                  ):
                      const Icon(Icons.close,color: Colors.orange,);
                case ConnectionState.done:
                  return const Icon(Icons.check,color: Colors.green,);
              }
            },
          ),
        );
      },
    );
  }

  getName(List<dynamic> artists, String title) {
    String artist;
    if (artists.length <= 3) {
      artist = artists.join(',');
    } else {
      artist = artists.sublist(0, 3).join(',');
    }
    return '$artist - $title';
  }
}

// downloadInfos.isEmpty
// ? const Icon(Icons.check)
// : CircularPercentIndicator(
// radius: 18.0,
// lineWidth: 2.0,
// percent: downloadInfos[index]?.progress ?? 0,
// center: Text(
// "${double.parse(downloadInfos[index]!.progress.toStringAsFixed(2)) * 100}%",
// style: const TextStyle(fontSize: 8.0),
// ),
// progressColor: Colors.green,
// )
