class Urls {
  static const server = 'http://160.30.168.228:8080';

  static const signup = '$server/it4788/signup';
  static const login = '$server/it4788/login';
  static const getUserInfo = '$server/it4788/get_user_info';

  static const getNotifications = '$server/it5023e/get_notifications';
  static const sendNotification = '$server/it5023e/send_notification';
  static const getUnreadNotificationCount =
      '$server/it5023e/get_unread_notification_count';
  static const markNotificationAsRead =
      '$server/it5023e/mark_notification_as_read';

  static const websocket = '$server/ws';
  static const getConversation = '$server/it5023e/get_conversation';
  static const getListConversation = '$server/it5023e/get_list_conversation';
  static const deleteMessage = '$server/it5023e/delete_message';
}

class Paths {
  static const serverUrl = 'https://w5r3ivuvh0.execute-api.us-east-1.amazonaws.com/prod';

  static const getClassList = '/get-weather?id=inside&date=';
  static const getAllSurveys = '/it5023e/get_all_surveys';
}
