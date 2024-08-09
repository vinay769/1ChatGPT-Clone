class Messeges {
  Messeges({
    required this.fromid,
    required this.msg,
    required this.read,
    required this.sent,
    required this.toid,
    required this.type,
  });
  late final String fromid;
  late final String msg;
  late final String read;
  late final String sent;
  late final String toid;
  late final String type;

  Messeges.fromJson(Map<String, dynamic> json){
    fromid = json['fromid'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    toid = json['toid'].toString();
    type = json['type'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fromid'] = fromid;
    data['msg'] = msg;
    data['read'] = read;
    data['sent'] = sent;
    data['toid'] = toid;
    data['type'] = type;
    return data;
  }
}