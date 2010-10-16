$(document).ready(function() {
	
});


  var gameId = false;
	clientId = false;
	
  function init()
  {
    output = document.getElementById("output");
    serverWebsocket();
  }

  function serverWebsocket()
  {
    server = new WebSocket("ws://localhost:10000/game");
	
    server.onopen = function(evt) { 
			console.log("requesting game id");
	};
	
    server.onclose = function(evt) { 
		console.log("game DISCONNECTED");
		$('#connection').html('Disconnected');
		$('#dList').html('');
	};
	
    server.onmessage = function(evt) { 
	
		$('#log').css({opacity:1});
		$('#log').html(evt.data);
		$('#log').stop().animate({opacity:0}, 3000);
	
			// save game id on first message
			if(!gameId) { 
				gameId = evt.data;
				//console.log('game id: ' + evt.data);
				$('#gameID').append('GameID: '+evt.data)
				clientWebsocket(gameId);
				}
				
				else {
				
				msg = evt.data.split(" ");
				//console.log("message received: " + msg[1])
				if(msg[0]>1) {
				
					if(msg[1]=='connected') {
						$('#dList').append('<li class="device'+msg[0]+' device">Client: '+msg[2]+' Connected</li>');
						$('.device'+msg[0]).animate({opacity:1}, 500);
					}
					
					else if(msg[1]=='disconnected') {
						$('.device'+msg[0]).animate({opacity:0}, 500, function(){
							$('.device'+msg[0]).remove();
						});
					}
					
					else {
						
							message = msg[1].split("/");
							
							if(message[0] =='') {
							}
							
							else if(message[0] == 'ACCEL') {
								ax = message[1];
								ay = message[2];
								az = message[3];
								speed = ax/100000*(-1);
								yawRate= ay/3000*(-1);
								
							}
							
							else if(message[0] == 'GYRO') {
								gx = message[1];
								gy = message[2];
								gz = message[3];
								yawRate = gx/12*(-1);
								pitchRate = (gy/13);
							}
					}
				
				}
				//console.log("message received: " + evt.data)
			}
			
	 	};
    	
		server.onerror = function(evt) { 
			console.error(evt.data); 
		};
  }

	function clientWebsocket(id)
	{
		console.log("try to connect to game: " + id);
		client = new WebSocket("ws://localhost:10000/" + id + "/connect/WebClient");
		
    	client.onopen = function(evt) { 
		
			console.log("connected to game");
			$('#connection').html('Connected Game to Server!');
			
	  	};
		
    	client.onclose = function(evt) { 
		
			console.log("client: DISCONNECTED"); 
			
		};
    	
		client.onmessage = function(evt) { 
			// save game id on first message
			if(!clientId) { 
				clientId = evt.data;
				//console.log('client id: ' + evt.data);
				
			} else {
				//console.log("message received: " + evt.data);
			}
	 	};
    	
		client.onerror = function(evt) { 
			console.error(evt.data); 
		};
	}

  window.addEventListener("load", init, false);