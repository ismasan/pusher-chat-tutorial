Widgets.Messages = function (chat) {
  
  /*------------------------------------------------------
  Listen to messages
  -------------------------------------------------------*/
  chat.bind( 'message', function (message) {
    $('<li>')
      .text(message.user + ' dice: ' + message.body)
      .appendTo('#messages');
  });
  
}