import 'package:flutter/material.dart';

import '../data/dummy_chats.dart';
import '../widgets/chat_tile.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008069),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'WhatsApp',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [IconButton(onPressed: () {},icon: const Icon(Icons.camera_alt_outlined),),
      IconButton(onPressed: () {}, icon: const Icon(Icons.search),),
      PopupMenuButton<String>(onSelected: (value){}, itemBuilder (context)=> const[PopupMenuItem(value:'settings', child:Text('Settings'),),],),
      ],
      bottom : TabBar(controller: tabController, indicatorColor: Colors.white, indicatorWeight:3, labelColor:Colors.white, unselectedLabelColor:Colors.white70, tabs: const[
        Tab(text:'CHATS'),
        Tab(text:'UPDATES'),
        Tab(text:'CALLS'),
      ],),
      body: TabBarView(
        controller:tabController,
        children: [
          _buildChats(),
          _buildUpdates(),
          _buildCalls(),
        ],
      ),
      floatingActionButton:FloatingActionButton(
        backgroundColor:const Color(0xFF00A884),foregroundColor: Colors.white,onPressed: () {}, child:const Icon (Icons.chat),
      ),
    );
  }
  Widget _buildChats() {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.all(10),
        child:TextField(decoration: InputDecoration(hintText: 'Search chats', prefixIcon: Icon(Icons.search), filled:true, fillColor:Colors.grey.shade100, border:OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none),),),),
        Expanded(
          child:ListView.builder(
            itemCount:dummyChats.length,
            itemBuilder:(context, index) {
              final chat = dummyChats[index];
              return ChatTile(chat: chat, onTap:(){
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) 
                  => ChatScreen (chat:chat,),),
                );
              },
            },
          )
        )
      ],
    );
  }
  Widget _buildUpdates() {
    return const Center(
      child:Text('Updates', style:TextStyle(fontSize:20),),
    )
  }
  Widget _buildCalls() {
    return const Center(
      child:Text('Calls', style:TextStyle(fontSize:20),),
    );
  }
}
