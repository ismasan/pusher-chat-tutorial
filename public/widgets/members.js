Widgets.Members = function (chat) {
  
  /*------------------------------------------------------
  Add a member
  -------------------------------------------------------*/
  function addMember (member) {
    var avatar = $('<span>').addClass('avatar');
    $('<img>').attr('src', member.user_info.gravatar_url).appendTo(avatar);
    var name = $('<span>').addClass('name').text(member.user_info.user_name);
    
    var li = $('<li>')
      .attr('id', member.user_id)
      .addClass('member')
      .append(avatar)
      .append(name)
      .appendTo('#members');
  }
  
  /*------------------------------------------------------
  Remove member
  -------------------------------------------------------*/
  function removeMember (member) {
    $('#members').find('#' + member.user_id).remove();
  }
  
  /*------------------------------------------------------
  Handle existing members
  -------------------------------------------------------*/
  chat.bind('pusher:subscription_succeeded', function (members) {
    $.each(members, function (i, member) {
      addMember(member)
    })
  });
  
  /*------------------------------------------------------
  Handle new member
  -------------------------------------------------------*/
  chat.bind('pusher:member_added', addMember);
  
  /*------------------------------------------------------
  Handle remove member
  -------------------------------------------------------*/
  chat.bind('pusher:member_removed', removeMember);
  
}