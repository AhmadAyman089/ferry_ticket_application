import 'package:flutter/material.dart';


class NavBar extends StatelessWidget{ 
  @override  
  Widget build(BuildContext context) { 
    return Drawer( 
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(accountName: Text('Test'), accountEmail: Text('Test' ),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.network('https://wallpapers-clan.com/wp-content/uploads/2022/07/funny-cat-1.jpg',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              )
              ),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
              image:NetworkImage(
                'https://www.luxuriousmagazine.com/wp-content/uploads/2019/10/Sea-Paseo-Ferry-Japan-Hiroshima.jpg'

              ),
              fit: BoxFit.cover,
               ),
               ),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorite'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorite'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorite'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorite'),
            onTap: () => null,
          ),
        ],
      ),
    );
  }
  
}