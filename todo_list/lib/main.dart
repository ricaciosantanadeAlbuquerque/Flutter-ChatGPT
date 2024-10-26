import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ListaTarefasApp());
}

class ListaTarefasApp extends StatelessWidget {
  const ListaTarefasApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ListaTarefasScreen(),
    );
  }
}

class ListaTarefasScreen extends StatefulWidget {
  const ListaTarefasScreen({super.key});
  @override
  ListaTarefasScreenState createState() => ListaTarefasScreenState();
}

class ListaTarefasScreenState extends State<ListaTarefasScreen> {
  List<String> _tarefas = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tarefas = prefs.getStringList('tarefas') ?? [];
    });
  }

  Future<void> _salvarTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tarefas', _tarefas);
  }

  void _adicionarTarefa() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tarefas.add(_controller.text);
        _controller.clear();
      });
      _salvarTarefas(); // Salva as tarefas após adicionar
    }
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
    _salvarTarefas(); // Salva as tarefas após remover
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: _tarefas.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma tarefa adicionada!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tarefas.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin:  const EdgeInsets.symmetric(vertical: 5),
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              _tarefas[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _removerTarefa(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Digite uma nova tarefa',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                ),
                onSubmitted: (value) => _adicionarTarefa(),
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: _adicionarTarefa,
              backgroundColor: Colors.teal,
              elevation: 5,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
