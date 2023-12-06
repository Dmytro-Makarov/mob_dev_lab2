import 'package:flutter/material.dart';
import 'package:mob_dev_lab2/db_manager.dart';
import 'package:mob_dev_lab2/oblast_details_page.dart';
import 'oblast.dart';

Widget oblastCard(Oblast oblast, BuildContext context) {

  return GestureDetector(behavior: HitTestBehavior.opaque,
  onTap: () => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => OblastDetailsPage(oblast: oblast,))
  ),
  child: Card(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Область: ${oblast.name}"),
        Text("Площа: ${oblast.area} km^2")
      ],
    ),
  ),
  );
}

// Widget requestOblastList(DBManager dbManager) {
//
//   return FutureBuilder<List<Oblast>>(
//       future: dbManager.oblasts(),
//       builder: (BuildContext context, AsyncSnapshot<List<Oblast>> snapshot) {
//         ListView listView ;
//         if (snapshot.hasData) {
//           var oblastList = snapshot.data;
//           listView = ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: oblastList?.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return oblastCard(oblastList!.elementAt(index), context);
//               });
//           return listView;
//         } else if (snapshot.hasError) {
//           builderError(snapshot);
//         } else {
//           progressBar();
//         }
//       });
// }

class OblastPage extends StatefulWidget {
  const OblastPage({super.key});


  @override
  State<OblastPage> createState() => _OblastPage();
}

class _OblastPage extends State<OblastPage> {
  late Future<DBManager> manager;
  late List<Oblast> oblastList = <Oblast>[];

  bool limited = false;

  @override
  void initState() {
    super.initState();

    manager = DBManager.init("oblasts");
    //manager.whenComplete(() => populateDatabase(manager))
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        FutureBuilder<DBManager>(
            future: manager,
            builder: (BuildContext context, AsyncSnapshot<DBManager> snapshot) {
              ListView listView;
              if (snapshot.hasData) {
                if(limited) {
                  snapshot.data?.getOblastsWithPopulationLimit(1000000).then((value) => {
                    if(value.isEmpty) {
                      //snapshot.data?.getOblastsWithPopulationLimit(1000000).then((value) => oblastList = value)
                      oblastList = value
                    } else {
                      oblastList = value
                    }
                  });
                } else {
                  snapshot.data?.oblasts().then((value) => {
                    if(value.isEmpty) {
                      populateDatabase(snapshot.data as DBManager),
                      snapshot.data?.oblasts().then((value) => oblastList = value)
                    } else {
                      oblastList = value
                    }
                  });
                }


                listView = ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: oblastList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return oblastCard(oblastList.elementAt(index), context);
                    });
                return Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      ElevatedButton(onPressed: () => {
                        setState(() { limited = !limited; })
                      },
                          child: const Text("Population less than 1 mil.")),
                    ],),
                    Expanded(child: listView)
                  ],);

              } else if (snapshot.hasError) {
                return builderError(snapshot);
              } else {
                return progressBar();
              }
            })
    );

  }

}

Widget progressBar() {
  return const Center(
    child: Column(children: <Widget>[
      SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Awaiting result...'),
      ),
    ],
    ),
  );
}

Widget builderError(AsyncSnapshot snapshot) {
  return Center(
    child: Column(children: <Widget>[
      const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text('Error: ${snapshot.error}'),
      ),
    ],),
  );
}