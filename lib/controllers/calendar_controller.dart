import 'package:get/get.dart';

import '../models/event_label_model.dart';
import '../models/event_model.dart';
import '../repositories/calendar_repo.dart';

class CalendarController extends GetxController {
  List<EventModel> events = [];
  List<EventLabelModel> labels = [];

  Future<bool> getEventList() async {
    final response = await calendarRepo.getEventList();

    if (response?.data != null) {
      events =
          (response?.data as List).map((e) => EventModel.fromJson(e)).toList();

      update();
      return true;
    }

    return false;
  }

  Future<bool> createEvent(EventModel event) async {
    final response = await calendarRepo.createEvent(event);

    if (response?.data != null) {
      events.add(EventModel.fromJson(response?.data));
      update();
      return true;
    }

    return false;
  }

  Future<bool> getLabels() async {
    final response = await calendarRepo.getLabels();

    if (response?.data != null) {
      labels = (response?.data as List)
          .map((e) => EventLabelModel.fromJson(e))
          .toList();

      update();
      return true;
    }

    return false;
  }

  Future<bool> deleteEvent(int eventId) async {
    final response = await calendarRepo.deleteEvent(eventId);

    if (response?.data != null) {
      events.removeWhere((element) => element.id == eventId);
      update();
      return true;
    }

    return false;
  }

  Future<EventModel?> getEvent(int eventId) async {
    final response = await calendarRepo.getEvent(eventId);

    if (response?.data != null) {
      return EventModel.fromJson(response?.data);
    }

    return null;
  }

  Future<bool> updateEvent(EventModel event) async {
    final response = await calendarRepo.updateEvent(event);

    if (response?.data != null) {
      final index = events.indexWhere((element) => element.id == event.id);
      events[index] = event;
      update();
      return true;
    }

    return false;
  }
}
