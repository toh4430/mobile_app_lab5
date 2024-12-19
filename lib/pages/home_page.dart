import 'package:flutter/material.dart';
import 'package:mobile_app_lab6/model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];

  loadData() async {
    todos = await Todo().select().toList();
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  todoAdd(String todoTitle) async {
    Todo todoToAdd = Todo();
    todoToAdd.title = todoTitle;
    todoToAdd.completed = false;
    await todoToAdd.save();
    loadData();
  }

  showTodoAddDialog() {
    String newTitle = "";

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Add Task",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64B5F6), // Sky Blue
          ),
        ),
        content: TextField(
          onChanged: (value) => newTitle = value,
          decoration: InputDecoration(
            labelText: 'Task Title',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              todoAdd(newTitle);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1976D2), // Blue
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text("Add", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD), // Light Sky Blue Background
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Todo List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Color(0xFF1976D2), // Blue
        actions: [
          IconButton(
            onPressed: () async {
              await Todo().select().completed.equals(true).delete();
              loadData();
            },
            icon: Icon(Icons.delete, color: Colors.white),
            tooltip: "Clear Completed Tasks",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: todos.isEmpty
            ? Center(
                child: Text('No tasks available',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600])))
            : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        todos[index].completed = !todos[index].completed!;
                      });
                      await todos[index].save();
                      loadData();
                    },
                    child: Card(
                      elevation: 6,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: todos[index].completed!
                          ? Color(0xFFBBDEFB) // Light Blue for completed tasks
                          : Colors.white,
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        title: Text(
                          todos[index].title ?? "",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: todos[index].completed!
                                ? TextDecoration.lineThrough
                                : null,
                            color: todos[index].completed!
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        leading: Icon(
                          todos[index].completed!
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: todos[index].completed!
                              ? Color(0xFF1976D2) // Blue for completed tasks
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1976D2), // Blue
        onPressed: showTodoAddDialog,
        child: Icon(Icons.add, size: 30),
        tooltip: "Add Task",
      ),
    );
  }
}
