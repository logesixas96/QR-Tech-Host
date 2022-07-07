class EventCreateModel {
  String? eventName;
  String? eventAddress;
  DateTime? eventDate;
  String? qrData;

  EventCreateModel(
      {this.eventAddress, this.eventName, this.eventDate, this.qrData});

  factory EventCreateModel.fromMap(map) {
    return EventCreateModel(
        eventName: map['eventName'],
        eventAddress: map['eventAddress'],
        eventDate: map['eventDate'],
        qrData: map['qrData']);
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventAddress': eventAddress,
      'eventDate': eventDate,
      'qrData': qrData
    };
  }
}
