
import 'package:app1/screens/LogInPage.dart';
import 'package:app1/screens/authentication.dart';
import 'package:app1/screens/favorite.dart';
import 'package:app1/screens/watch_list.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final VoidCallback onClose;

  const Sidebar({Key? key, required this.onClose}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  

  Future<void> signOut() async {
    await Auth().signOut();
    // Navigate to LoginPage after sign out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  //  Future <void> signOut() async{
  //   await Auth().signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:Color(0xff0A0B10).withOpacity(0.8) ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                   builder: (context) => 
                   WatchlistScreen()
                ),
              );
              // Handle watch list tap
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: signOut
    
              // Handle logout tap
            
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Close'),
            onTap: widget.onClose,
          ),
        ],
      ),
    );
  }
}