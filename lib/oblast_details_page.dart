import 'package:flutter/material.dart';

import 'oblast.dart';

class OblastDetailsPage extends StatefulWidget {
  OblastDetailsPage({super.key, required this.oblast});

  Oblast oblast;

  @override
  State<OblastDetailsPage> createState() => _OblastDetailsPage();
}

class _OblastDetailsPage extends State<OblastDetailsPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text(widget.oblast.name),
    ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ID: ${widget.oblast.id}"),
          Text("Область: ${widget.oblast.name}"),
          Text("Обл. Центр: ${widget.oblast.oblastCenter}"),
          Text("Населення: ${widget.oblast.population}"),
          Text("Площа: ${widget.oblast.area}"),
        ],
      ),
    );

  }

}