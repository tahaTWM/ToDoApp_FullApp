class ToDoList {
  int id;
  String title;
  String time;
  String desc;

  ToDoList({
    this.id,
    this.title,
    this.time,
    this.desc,
  });

  factory ToDoList.fromMap(Map<String, dynamic> json) => ToDoList(
      id: json["id"],
      title: json["title"],
      time: json["time"],
      desc: json["desc"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "time": time,
        "desc": desc,
      };
}
