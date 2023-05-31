import 'package:npssolutions_mobile/models/event_model.dart';

import '../models/response_model.dart';
import 'dio_repo.dart';

final calendarRepo = _CalendarRepo();

class _CalendarRepo extends DioRepo {
  Future<ResponseModel?> getEventList() async {
    return await get('/api/v1/calendar/events');
  }

  Future<ResponseModel?> createEvent(EventModel event) async {
    return await post('/api/v1/calendar/events', data: event.toJson());
  }

  Future<ResponseModel?> getLabels() async {
    return await get('/api/v1/calendar/labels');
  }

  Future<ResponseModel?> deleteEvent(int eventId) async {
    return await delete('/api/v1/calendar/events/$eventId');
  }

  Future<ResponseModel?> getEvent(int eventId) async {
    return await get('/api/v1/calendar/events/$eventId/detail');
  }

  Future<ResponseModel?> updateEvent(EventModel event) async {
    return await put('/api/v1/calendar/events', data: event.toJson());
  }
}
