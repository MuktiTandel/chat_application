class ChatModel {

  final String idFrom;
  final String idTo;
  final String timeStemp;
  final String content;
  final int type;

  ChatModel({
    required this.content,
    required this.idFrom,
    required this.idTo,
    required this.timeStemp,
    required this.type
  });

  Map<String, dynamic> toMap(){
    return {
      'idFrom' : idFrom,
      'idTo' : idTo,
      'timeStemp' : timeStemp,
      'content' : content,
      'type' : type
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        content: map['content'] ?? '',
        idFrom: map['idFrom'] ?? '',
        idTo: map['idTo'] ?? '',
        timeStemp: map['timeStemp'] ?? '',
        type: map['type'] ?? ''
    );
  }

}