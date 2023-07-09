import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/pages/createpage.dart';
import 'package:todo/pages/editpage.dart';
import 'package:todo/utils/custom_checkbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEyeActive = false;
  final List<TodoModel> _todos = [];

  void navigateToCreatePage() async {
    final result = await Navigator.push<TodoModel>(
      context,
      MaterialPageRoute(builder: (context) => const CreatePage()),
    );
    if (result != null) {
      setState(() {
        _todos.add(result);
      });
    }
  }

  void navigateToEditPage(int index, String text, DateTime? deadline) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(index: index, text: text, deadline: deadline),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final int editedIndex = result['index'];
      final bool delete = result['delete'] ?? false;

      setState(() {
        if (delete) {
          _todos.removeAt(editedIndex);
        } else {
          final TodoModel editedTodo = result['todo'];
          _todos[editedIndex] = editedTodo;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    final filteredTodos = isEyeActive ? _todos : _todos.where((todo) => !todo.done).toList();

    final finishedCount = _todos.where((todo) => todo.done).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.background,
        centerTitle: true,
        title: Text(
          'Мои дела',
          style: themeData.textTheme.headlineSmall?.copyWith(),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Выполнено - $finishedCount',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEyeActive = !isEyeActive;
                          });
                        },
                        child: SvgPicture.asset(
                          isEyeActive ? 'lib/assets/active_eye.svg' : 'lib/assets/eye.svg',
                        ),
                      ),
                    ],
                  ),
                ),
                LimitedBox(
                  maxHeight: screenHeight * 0.075 * _todos.length,

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        final todoText = filteredTodos[index].text;
                        final displayText = todoText.length <= 30 ? todoText : todoText.substring(0, 30) + '...';
                        final deadline = filteredTodos[index].deadline;

                        return Dismissible(
                          key: Key(todoText),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.green,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          secondaryBackground: Container(
                            color: Colors.red,
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              // Swipe from right to left (Apply action)
                              setState(() {
                                _todos[index] = _todos[index].copyWith(done: true);
                              });
                              return false; // Do not dismiss the item
                            } else if (direction == DismissDirection.endToStart) {
                              // Swipe from left to right (Delete action)
                              final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Удаление'),
                                    content: const Text('Вы точно хотите удалить?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Да'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Нет'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (result == true) {
                                setState(() {
                                  if (index >= 0 && index < _todos.length) {
                                    _todos.removeAt(index);
                                  }
                                });
                              }
                              return false;
                            }
                            return false;
                          },
                          child: ListTile(
                            onLongPress: () {
                              navigateToEditPage(index, filteredTodos[index].text, filteredTodos[index].deadline);
                            },
                            leading: CustomCheckbox(
                              value: filteredTodos[index].done,
                              onChanged: (value) {
                                setState(() {
                                  filteredTodos[index] = filteredTodos[index].copyWith(done: value);
                                });
                              },
                            ),
                            title: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Моё дело'),
                                      content: Text(todoText),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                displayText,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  decoration: filteredTodos[index].done ? TextDecoration.lineThrough : null,
                                  color: filteredTodos[index].done ? Colors.grey : null,
                                ),
                              ),
                            ),
                            subtitle: filteredTodos[index].deadline != null
                                ? Text(
                              'Дедлайн: ${DateFormat('dd.MM.yyyy HH:mm').format(filteredTodos[index].deadline!)}',
                              style:
                              TextStyle(
                                color: Colors.grey,
                              ),
                            )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreatePage,
        backgroundColor: const Color(0xFFFF9900),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
