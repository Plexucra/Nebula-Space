		var clientId = '1075254781543.apps.googleusercontent.com';
		var apiKey = 'AIzaSyCrOSBclOKhZIFzCTutIYh6zic8BmUCeTM';
		var scopes = 'https://www.googleapis.com/auth/userinfo.email';

		function handleClientLoad()
		{
			checkAuth();
//			showLoginMsg();
		}

		function checkAuth()
		{
			gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: true}, handleAuthResult);
		}

		function showLoginMsg()
		{
			$("#loginDiv").html("Bitte melden Sie sich über Ihr Google-Konto an. "+
					"Eine klassische Registrierungsmethode mit E-Mail und Kennwort wird aus Sicherheitsgründen "+
					"derzeit noch nicht unterstützt <br/><small>(Aus Kostengründen ist kein eigenes HTTPS Zertifikat vorhanden)</small>"+
					"<br/><br/><button class='gbqfb'>Über Ihr Google-Konto einloggen</button><br/><br/>"+
					"<i>Hinweise: <ul><li>Aus Gründen des Datenschutzes werden von uns generell keine E-Mail-Adressen gespeichert. Der Google-Login dient lediglich der eindeutigen Identifizierung des Spieler-Accounts."+
					"</li><li>Wenn Sie kein Google-Konto besitzen können Sie dieses Spiel vorerst leider nicht spielen. (Alternativ-Login ist bereits in Arbeit)</li></ul></i>");
			$("#loginDiv button").click(function(tne)
			{
				gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: false}, handleAuthResult);
				tne.preventDefault();
			});
		}
		function showLoginForwardMsg()
		{
			$("#loginDiv").html("<i>Ihr Zugang wird geprüft. Bitte einen Augenblick geduld...</i>");

		}
		function handleAuthResult(authResult)
		{
			if (authResult && !authResult.error)
			{
				showLoginForwardMsg();
 				$.getJSON('https://www.googleapis.com/oauth2/v1/userinfo?access_token='+authResult.access_token, function(data)
 				{
 					try
 					{
 						location.replace("/beta/pages/login.jsp?key="+data.id);
 					}
 					catch(ex)
 					{
 						console.log(data);
 						alert("Beim Login ist ein Fehler aufgetreten.");
 					}
 				});
	        }
			else
				showLoginMsg();
		}