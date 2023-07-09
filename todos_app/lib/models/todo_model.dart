class TodoModel {
  final int? id;
  final String text;
  final DateTime? deadline;
  final bool done;

  TodoModel({
    this.id,
    required this.text,
    this.deadline,
    this.done = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'deadline': deadline?.millisecondsSinceEpoch,
      'done': done ? 1 : 0,
    };
  }
  Map<String, dynamic> toUpdateMap() {
    final map = {
      'text': text,
    };
    if (deadline != null) {
      map['deadline'] = deadline!.millisecondsSinceEpoch.toString();

    }
    return map;
  }
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      text: map['text'],
      deadline: map['deadline'] != null ? DateTime.fromMillisecondsSinceEpoch(map['deadline']) : null,
      done: map['done'] == 1,
    );
  }

  TodoModel copyWith({
    int? id,
    String? text,
    DateTime? deadline,
    bool? done,
  }) {
    return TodoModel(
      id: id ?? this.id,
      text: text ?? this.text,
      deadline: deadline ?? this.deadline,
      done: done ?? this.done,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TodoModel &&
              runtimeType == other.runtimeType &&
              text == other.text &&
              deadline == other.deadline &&
              done == other.done;

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ deadline.hashCode ^ done.hashCode;
}
