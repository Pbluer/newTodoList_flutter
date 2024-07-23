import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp( MaterialApp(
    home: Home()
  ));
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _todoController = TextEditingController();
  List _todoList = [];


  void addTodo(){
    setState(() {
      Map<String,dynamic> newTodo = Map();
      newTodo['tittle'] = _todoController.text;
      print(_todoController.text);
      _todoController.text = '';
      newTodo['ok'] = false;

      _todoList.add(newTodo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefa'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                 Expanded(
                   child: TextField(
                     controller: _todoController,
                    decoration: InputDecoration(
                      labelText:'Nova Tarefa',
                      labelStyle: TextStyle(
                        color: Colors.blueAccent
                      )
                    ),
                                   ),
                 ),
                ElevatedButton(
                  onPressed: addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent
                  ),
                  child: const Text(
                    'Adicionar',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.5),
              itemCount: _todoList.length,
              itemBuilder: (context,index){
                return CheckboxListTile(
                  title: Text(_todoList[index]['tittle']),
                  value: _todoList[index]['ok'],
                  secondary: CircleAvatar(
                    child: Icon(
                        _todoList[index]['ok'] ? Icons.check_circle : Icons.error_outline
                    ),
                  ), onChanged: (c) {
                    setState(() {
                      _todoList[index]['ok'] = c;
                    });
                },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<void> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();

    return file.writeAsStringSync(data);
  }

  Future<String?> _readData() async {
    try{
      final file = await _getFile();
      return file.readAsString();
    }catch( err ){
      return null;
    }
  }
}
