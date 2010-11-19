Widgets.SoundAlerts = function (chat) {
  
  /*------------------------------------------------------
  Preload audio objects
  -------------------------------------------------------*/
  var message_alert = $('<audio>').attr('src', '/audio/message.mp3').appendTo('body');
  var member_alert  = $('<audio>').attr('src', '/audio/member.mp3').appendTo('body');
  
  /*------------------------------------------------------
  Listen to messages
  -------------------------------------------------------*/
  chat.bind( 'message', function (message) {
    message_alert[0].load();
    message_alert[0].play();
  });
  
  chat.bind( 'pusher:member_added', function (message) {
    member_alert[0].load();
    member_alert[0].play();
  });
  
}