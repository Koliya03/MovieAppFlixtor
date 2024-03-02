
import 'package:app1/screens/favorite.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final VoidCallback onClose;

  const Sidebar({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:Colors.black.withOpacity(0.7) ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorite'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                   builder: (context) => 
                   FavoriteMoviesScreen()
                ),
              );
              // Handle favorite tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.watch_later),
            title: const Text('Watch List'),
            onTap: () {
              // Handle watch list tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Close'),
            onTap: onClose,
          ),
        ],
      ),
    );
  }
}