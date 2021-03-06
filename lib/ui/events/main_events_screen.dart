
import 'package:flutter/material.dart';
import 'package:unites_flutter/ui/events/events_list_screen.dart';
import 'package:unites_flutter/ui/events/map/events_on_map_screen.dart';

class MainEventsScreen extends StatefulWidget {
  @override
  _MainEventsScreenState createState() => _MainEventsScreenState();
}

class _MainEventsScreenState extends State<MainEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Список'),
                Tab(text: 'Карта'),
              ],
            ),
            title: Text('Мероприятия'),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              EventsListScreen(),
              EventsOnMapScreen(),
            ],
          ),
        ),
      ),
    );;
  }
}
