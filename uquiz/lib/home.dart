import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UQuizApp')),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    // const url = 'https://fakestoreapi.com/products?limit=5';
                    const url = 'https://randomuser.me/api/';
                    Requests.get(url).then((r) {
                      print(r.json()['results'][0]['phone']);
                    });
                    // print('Press');
                  },
                ),
                const Text("Whooaaaa"),
              ],
            ),
          ),
          const Expanded(child: Text("I'm")),
          const Text("LOST"),
        ],
      ),
    );
  }
}
