import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/utils/custom_checkbox.dart';

class EditPage extends StatefulWidget {
  final int index;
  final String text;
  final DateTime? deadline;

  const EditPage({
    Key? key,
    required this.index,
    required this.text,
    this.deadline,
  }) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _textEditingController;
  bool isEyeActive = false;
  DateTime? deadline;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.text);
    deadline = widget.deadline;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> showDatePickerDialog() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        setState(() {
          deadline = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  Future<void> showConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Удаление'),
          content: Text('Вы точно хотите удалитьВы точно хотите удалить?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Да'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Нет'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Remove the item and navigate back to the home page
      Navigator.of(context).pop({'index': widget.index, 'delete': true});
    }
  }

  void saveTodo() {
    final String enteredText = _textEditingController.text;
    if (enteredText.isNotEmpty) {
      final TodoModel todo = TodoModel(text: enteredText, deadline: deadline);
      Navigator.of(context).pop({'index': widget.index, 'todo': todo});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.background,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: saveTodo,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'сохранить',
                style: themeData.textTheme.displayLarge?.copyWith(),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Container(
                  height: screenHeight * 0.3,
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
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Введите текст заметки...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Дедлайн',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    CustomCheckbox(
                      value: deadline != null,
                      onChanged: (value) {
                        setState(() {
                          if (value) {
                            showDatePickerDialog();
                          } else {
                            deadline = null;
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (deadline != null)
                  GestureDetector(
                    onTap: showDatePickerDialog,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        DateFormat('dd.MM.yyyy HH:mm').format(deadline!),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                const Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: showConfirmationDialog,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Удалить',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
