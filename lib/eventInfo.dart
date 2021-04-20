import 'package:covidui/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventInfo {
  final String id;
  final String name;
  final String description;
  final String location;
  final String link;
  final List<dynamic> attendeeEmails;
  final bool shouldNotifyAttendees;
  final bool hasConfereningSupport;
  final int startTimeInEpoch;
  final int endTimeInEpoch;

  EventInfo({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.location,
    @required this.link,
    @required this.attendeeEmails,
    @required this.shouldNotifyAttendees,
    @required this.hasConfereningSupport,
    @required this.startTimeInEpoch,
    @required this.endTimeInEpoch,
  });

  EventInfo.fromMap(Map snapshot)
      : id = snapshot['id'] ?? '',
        name = snapshot['name'] ?? '',
        description = snapshot['desc'],
        location = snapshot['loc'],
        link = snapshot['link'],
        attendeeEmails = snapshot['emails'] ?? '',
        shouldNotifyAttendees = snapshot['should_notify'],
        hasConfereningSupport = snapshot['has_conferencing'],
        startTimeInEpoch = snapshot['start'],
        endTimeInEpoch = snapshot['end'];

  toJson() {
    return {
      'id': id,
      'name': name,
      'desc': description,
      'loc': location,
      'link': link,
      'emails': attendeeEmails,
      'should_notify': shouldNotifyAttendees,
      'has_conferencing': hasConfereningSupport,
      'start': startTimeInEpoch,
      'end': endTimeInEpoch,
    };
  }
}

class Storage {
  Future<void> storeEventData(EventInfo eventInfo, User user) async {
    DocumentReference documentReferencer = firestoreInstance
        .collection('users')
        .doc(user.uid)
        .collection('events')
        .doc(eventInfo.id);

    Map<String, dynamic> data = eventInfo.toJson();

    await documentReferencer.set(data).whenComplete(() {
      print("Event added to the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  Future<void> updateEventData(EventInfo eventInfo, User user) async {
    DocumentReference documentReferencer = firestoreInstance
        .collection('users')
        .doc(user.uid)
        .collection('events')
        .doc(eventInfo.id);

    Map<String, dynamic> data = eventInfo.toJson();

    await documentReferencer.update(data).whenComplete(() {
      print("Event updated in the database, id: {${eventInfo.id}}");
    }).catchError((e) => print(e));
  }

  Future<void> deleteEvent({@required String id, User user}) async {
    DocumentReference documentReferencer = firestoreInstance
        .collection('users')
        .doc(user.uid)
        .collection('events')
        .doc(id);

    await documentReferencer.delete().catchError((e) => print(e));

    print('Event deleted, id: $id');
  }

  Stream<QuerySnapshot> retrieveEvents(User user) {
    Stream<QuerySnapshot> myClasses = firestoreInstance
        .collection('users')
        .doc(user.uid)
        .collection('events')
        .orderBy('start')
        .snapshots();

    return myClasses;
  }
}
