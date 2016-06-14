App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log(data['message'])

    if(data['message'] ==  "Data Inserted into the channel")
      messageContent = '<p>' + data['message'] + '</p>';
      $('#write_message').append(messageContent) 
      
    else
      #alert data
      console.log(data['message'])

      for arr in data['message']
          #console.log(feed.created_at)
          tableContent = '<tr>';
          tableContent += "<td>" + arr.created_at + "</td>";
          tableContent += "<td>" + arr.entry_id + "</td>";
          tableContent += "<td>" + arr.field3 + "</td>";
          $('#mostRecentData').append(tableContent);

      


  speak: (message) ->
    @perform 'speak', message: message

$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
	if event.keyCode is 13 # return = send
		App.room.speak event.target.value
		event.target.value = ''
		event.preventDefault()

$(document).on 'keypress', '[data-behavior~=room_writer]', (event) ->
  if event.keyCode is 13 # return = send
    App.room.speak event.target.value + "write"
    event.target.value = ''
    event.preventDefault()