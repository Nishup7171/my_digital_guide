import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_digital_guide/firebase_options.dart';

class Artefact {
  final String name;
  final String collection;
  final String location;
  final String description;
  final String imageUrl;

  Artefact({
    required this.name,
    required this.collection,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

// class ArtefectListPage extends StatefulWidget {
//   const ArtefectListPage({Key? key}) : super(key: key);
//
//   @override
//   State<ArtefectListPage> createState() => _ArtefectListPageState();
// }
//
// class _ArtefectListPageState extends State<ArtefectListPage> {
//   final List<Artefact> artefacts = [
//     Artefact(
//       name: 'Artefact 1',
//       collection: 'Collection 1',
//       location: 'Location 1',
//       description: 'Description 1',
//       imageUrl: 'https://via.placeholder.com/150',
//     ),
//     Artefact(
//       name: 'Artefact 2',
//       collection: 'Collection 2',
//       location: 'Location 2',
//       description: 'Description 2',
//       imageUrl: 'https://via.placeholder.com/150',
//     ),
//     Artefact(
//       name: 'Artefact 3',
//       collection: 'Collection 1',
//       location: 'Location 3',
//       description: 'Description 3',
//       imageUrl: 'https://via.placeholder.com/150',
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Artefact List'),
//         automaticallyImplyLeading: true,
//       ),
//       body: ListView.builder(
//         itemCount: artefacts.length,
//         itemBuilder: (BuildContext context, int index) {
//           final artefact = artefacts[index];
//           return ListTile(
//             title: Text(artefact.name),
//             subtitle: Text(artefact.collection),
//             leading: Image.network(artefact.imageUrl),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ArtefactDetails(artefact: artefact),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class ArtefectList extends StatelessWidget {
  const ArtefectList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          if(snapshot.connectionState == ConnectionState.done){
            return Scaffold(
              backgroundColor: Colors.deepPurple,
              appBar: AppBar(
                title: const Text("Artefect List"),
                backgroundColor: Colors.blue[300],
                automaticallyImplyLeading: true,
                elevation: 0.0,
              ),
              body: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('artefects').snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        separatorBuilder: (context, index){
                          return const SizedBox(height: 10.0,);
                        },
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data?.docs.length??0,
                        itemBuilder: (context, index){
                          DocumentSnapshot? documentSnapshot = snapshot.data?.docs[index];
                          return Container(
                            color: Colors.blueGrey[300],
                            child: ListTile(
                              title: Text(documentSnapshot?['name'], style: const TextStyle(color: Colors.white),),
                              subtitle: Text(documentSnapshot?['collection'], style: const TextStyle(color: Colors.white),),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ArtefactDetails(artefact: documentSnapshot)));
                              },
                            ),
                          );
                    }),
                  );
                },
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}


class ArtefactDetails extends StatelessWidget {
  final DocumentSnapshot? artefact;

  const ArtefactDetails({super.key, required this.artefact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text(artefact?['name']),
        backgroundColor: Colors.blue[300],
        automaticallyImplyLeading: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Image.network(
            artefact?['image'],
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artefact?['name'],
                  style: const TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Collection: ${artefact?['collection']}',
                  style: const TextStyle(fontSize: 18, color: Colors.white,),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: ${artefact?['location']}',
                  style: const TextStyle(fontSize: 18, color: Colors.white,),
                ),
                const SizedBox(height: 16),
                Text(
                  artefact?['description'],
                  style: const TextStyle(fontSize: 16, color: Colors.white,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
