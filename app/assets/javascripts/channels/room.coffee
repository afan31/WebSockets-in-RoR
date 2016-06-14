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
      #console.log(data['message'][0][1])
      #console.log(data['message'][1][1].created_at)
      channel_header_content = "<th>Channel Id</th><th>Channel Name</th><th>Field Name</th><th>Last Entry Id</th>"
      $('#channel_details').append(channel_header_content)
      channel_table_content = '<tr>';
      channel_table_content += "<td>" + data['message'][1][1].id + "</td>";
      channel_table_content += "<td>" + data['message'][1][1].name + "</td>";
      channel_table_content += "<td>" + data['message'][1][1].field3 + "</td>";
      channel_table_content += "<td>" + data['message'][1][1].last_entry_id + "</td>";
      $('#channel_details').append(channel_table_content);

      headerContent = "<th>Created</th><th>Entry Id</th><th>Field value</th>"
      $('#mostRecentData').append(headerContent)
      for arr in data['message']
        #console.log(arr)
        for feed in arr[1]
          #console.log(feed.created_at)
          tableContent = '<tr>';
          tableContent += "<td>" + feed.created_at + "</td>";
          tableContent += "<td>" + feed.entry_id + "</td>";
          tableContent += "<td>" + feed.field3 + "</td>";
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