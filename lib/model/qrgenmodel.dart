class EventCreateModel{
  String? firstName;
  String? lastName;
  String? eventName;
  String? eventAddress;

  EventCreateModel({this.firstName, this.lastName, this.eventAddress, this.eventName});

  //data from server
  factory EventCreateModel.fromMap(map){
    return EventCreateModel(
      firstName: map['firstName'],
      lastName: map['lastName'],
      eventName: map['eventName'],
      eventAddress: map['eventAddress'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap(){
    return{
      'firstName': firstName,
      'lastName': lastName,
      'eventName': eventName,
      'eventAddress': eventAddress,
    };
  }
}