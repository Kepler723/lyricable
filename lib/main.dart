import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Flutter Music Player'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
            },
          ),
        ],
        bottom: PreferredSize(  
          preferredSize: const Size.fromHeight(kToolbarHeight),  
          child: Container(  
            color: Colors.green, // Set your custom background color here  
            child: TabBar(  
              controller: _tabController,  
              tabs: const <Widget>[  
                Tab(icon: Icon(Icons.directions_car)),  
                Tab(icon: Icon(Icons.directions_transit)),  
                Tab(icon: Icon(Icons.directions_bike)),  
              ],  
              labelColor: Colors.white, // Selected tab label color  
              unselectedLabelColor: Colors.grey, // Unselected tab label color  
              indicatorColor: Colors.red, // Underline color of the selected tab  
            ),  
          ),  
        ),  
      ),
      drawer: Drawer(
        // 抽屉菜单项代码
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Music'),
              onTap: () {
                Navigator.of(context).pop();
                // 跳转到音乐页面
              },
            ),
            ListTile(
              title: const Text('Playlist'),
              onTap: () {
                Navigator.of(context).pop();
                // 跳转到播放列表页面
              },
            ),
            // 更多菜单项...
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // 音乐页面
          ExampleDragTarget(),
          // 播放列表页面
          Icon(Icons.playlist_add),
          // 电台页面
          Icon(Icons.radio),
        ],
      ),
    );
  }
}

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({Key? key}) : super(key: key);

  @override
  _ExampleDragTargetState createState() => _ExampleDragTargetState();
}

class _ExampleDragTargetState extends State<ExampleDragTarget> {
  final List<XFile> _list = [];

  bool _dragging = false;
  void _handleLeftClick(String filePath) {
    // 处理左键点击事件
    print('Left click: $filePath');
  }

  void _handleRightClick(String filePath) {
    // 处理右键点击事件
    print('Right click: $filePath');
    _showContextMenu(filePath);
  }

  void _showContextMenu(String filePath) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox targetBox = context.findRenderObject() as RenderBox;
    final Offset offset = targetBox.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy + 30, offset.dx + 200, offset.dy),
      items: [
        PopupMenuItem<String>(
          value: 'open',
          child: Text('Open'),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 'open') {
        print('Opening file: $filePath');
      } else if (value == 'delete') {
        print('Deleting file: $filePath');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) {
        setState(() {
          _list.addAll(detail.files);
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Container(
        height: 200,
        width: 200,
        color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
        child: _list.isEmpty
            ? const Center(child: Text("Drop here"))
            : ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                    return GestureDetector(
                    onTap: () => _handleLeftClick(_list[index].path),
                    onSecondaryTap: () => _handleRightClick(_list[index].path),
                    child: ListTile(
                      leading: Icon(Icons.insert_drive_file), // 文件图标
                      title: Text(_list[index].name),
                      subtitle: Text('Size: 10 MB'), // 示例子标题
                      trailing: Icon(Icons.arrow_forward_ios), // 尾部图标
                    ),
                  );
                },
              ),
      ),
    );
  }
}


