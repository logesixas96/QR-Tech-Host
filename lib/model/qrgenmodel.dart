class EventCreateModel{
  String? eventName;
  String? eventAddress;
  String? timeStamp;
  String? qrData;

  EventCreateModel({this.eventAddress, this.eventName, this.timeStamp, this.qrData});

  //data from server
  factory EventCreateModel.fromMap(map){
    return EventCreateModel(
      eventName: map['eventName'],
      eventAddress: map['eventAddress'],
      timeStamp: map['timeStamp'],
      qrData: map['qrData'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap(){
    return{
      'eventName': eventName,
      'eventAddress': eventAddress,
      'timeStamp': timeStamp,
      'qrData': qrData,
    };
  }
}