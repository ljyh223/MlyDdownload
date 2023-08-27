
import 'package:flutter/material.dart';


abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);

}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();

}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String title;
  final String artist;
  final String id;

  MessageItem(this.title, this.artist, this.id);
  getId() => id;

  @override
  Widget buildTitle(BuildContext context) => Text(title,style: const TextStyle(color: Colors.black),);

  @override
  Widget buildSubtitle(BuildContext context) => Text(artist,style:const TextStyle(color: Colors.grey,fontSize: 12.0));
}