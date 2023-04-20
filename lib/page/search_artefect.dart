import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'artefect_list.dart';

class SearchScreen extends StatefulWidget {
  final List<Artefact> artefacts;

  const SearchScreen({Key? key, required this.artefacts}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<Artefact> _searchResults = [];

  void _searchArtefacts() {
    setState(() {
      _searchResults = widget.artefacts.where((artefact) {
        return artefact.name.toLowerCase().contains(_searchText.toLowerCase()) ||
            artefact.collection.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,

          decoration: InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _searchText = _searchController.text.trim();
                _searchArtefacts();
              },
            ),
          ),
        ),
        backgroundColor: Colors.blue[300],
        elevation: 0,
      ),
      body: _searchResults.isEmpty
          ? const Center(
        child: Text('Enter a search term'),
      )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index){
            return const SizedBox(height: 10,);
        },
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
            Artefact artefact = _searchResults[index];
            return Container(
              color: Colors.blueGrey[300],
              child: ListTile(
                title: Text(artefact.name, style: const TextStyle(color: Colors.white),),
                subtitle: Text(artefact.collection, style: const TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ArtefactDetails2(artefact: artefact),
                    ),
                  );
                },
              ),
            );
        },
      ),
          ),
    );
  }
}


class ArtefactDetails2 extends StatelessWidget {
  final Artefact artefact;

  const ArtefactDetails2({super.key, required this.artefact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text(artefact.name),
        backgroundColor: Colors.blue[300],
        automaticallyImplyLeading: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Image.network(
            artefact.imageUrl,
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
                  artefact.name,
                  style: const TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Collection: ${artefact.collection}',
                  style: const TextStyle(fontSize: 18, color: Colors.white,),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: ${artefact.location}',
                  style: const TextStyle(fontSize: 18, color: Colors.white,),
                ),
                const SizedBox(height: 16),
                Text(
                  artefact.description,
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
