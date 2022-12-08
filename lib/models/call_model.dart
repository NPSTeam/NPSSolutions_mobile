class CallModel {
  bool? video;
  int? times;

  CallModel({this.video, this.times});

  CallModel.fromJson(dynamic json) {
    video = json['video'];
    times = int.tryParse(json['times'].toString()) ?? 0;
  }
}
