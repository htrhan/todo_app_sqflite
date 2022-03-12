class Notes {
  String? title;
  String? description;
  int? id;
  Notes({this.title, this.description});
  Notes.withId({required this.id, this.title, this.description});

  Notes.fromJson(Map<String, dynamic> data) {
    title = data["title"];
    description = data["description"];
    id = data["id"];
  }

  Map toMap() {
    Map<String, dynamic> data = {};
    data["title"] = title;
    data["description"] = description;
    data["id"] = id;
    return data;
  }
}
