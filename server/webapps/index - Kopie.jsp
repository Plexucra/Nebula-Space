<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="de">

<head>

	<style>
		body
		{
			margin:40px;
			font-family:"courier";
			font-size:1.5em;
		}
	</style>
<!--Add a button for the user to click to initiate auth sequence -->
    <button id="authorize-button" style="visibility: hidden">Authorize</button>
    <script type="text/javascript">

      var clientId = '1075254781543.apps.googleusercontent.com';

      var apiKey = 'AIzaSyCrOSBclOKhZIFzCTutIYh6zic8BmUCeTM';

      var scopes = 'https://www.googleapis.com/auth/plus.me';

      function handleClientLoad() {
        // Step 2: Reference the API key
        gapi.client.setApiKey(apiKey);
        window.setTimeout(checkAuth,1);
      }

      function checkAuth() {
        gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: true}, handleAuthResult);
      }

      function handleAuthResult(authResult) {
        var authorizeButton = document.getElementById('authorize-button');
        if (authResult && !authResult.error) {
          authorizeButton.style.visibility = 'hidden';
          makeApiCall();
        } else {
          authorizeButton.style.visibility = '';
          authorizeButton.onclick = handleAuthClick;
        }
      }

      function handleAuthClick(event) {
        // Step 3: get authorization to use private data
        gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: false}, handleAuthResult);
        return false;
      }

      // Load the API and make an API call.  Display the results on the screen.
      function makeApiCall() {
        // Step 4: Load the Google+ API
        gapi.client.load('plus', 'v1', function() {
          // Step 5: Assemble the API request
          var request = gapi.client.plus.people.get({
            'userId': 'me'
          });
          // Step 6: Execute the API request
          request.execute(function(resp) {
        	  alert(resp);
        	  for(var t in resp) alert(resp[t]);
            var heading = document.createElement('h4');
//             var image = document.createElement('img');
//             image.src = resp.image.url;
//             heading.appendChild(image);
            heading.appendChild(document.createTextNode(resp.displayName));

            document.getElementById('content').appendChild(heading);
          });
        });
      }
    </script>
    // Step 1: Load JavaScript client library
    <script src="https://apis.google.com/js/client.js?onload=handleClientLoad"></script>
    
    
    	</head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<body>
		<a href="javascript:;" onclick="makeApiCall()">test</a>
		<div id="content"></div>
		<div>
			<div id="headDiv"></div>
			<div id="viewDiv">
				Nebula-space - ihr Einstieg ins Internet ist bald wieder für Sie da..
			</div>
			<div id="footDiv"></div>
		</div>
	</body>
</html>