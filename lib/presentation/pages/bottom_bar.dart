import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {

  @override 
  _BottomBarState createState() => _BottomBarState();
}
class _BottomBarState extends State<BottomBar>{
  int currentIndex=0;
  final List<Widget> screens =[
    HomeMoviePage(),
    HomeTvPage(),
  ];
  @override 
  Widget build(BuildContext context){
    return Scaffold(
    body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kGrey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        iconSize: 40,
        currentIndex: currentIndex,
        onTap: (index) => setState(()=>currentIndex = index),
        items: [
            BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
            backgroundColor: kDavysGrey,
             ),
             BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Tv',
            backgroundColor: kDavysGrey,
             ),
        ])
  );
  }
}