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
			$("#loginDiv").html("<h2>Über Google-Konto einloggen:</h2> "+
					"<div class='loginOption'>Hier können Sie dieses Spiel bequem über einen Klick an Ihre Google-Nummer knüpfen.<br/>"+
					"Persönliche Daten, wie Ihr Name oder Ihre E-Mail Adresse werden von uns generell nicht gespeichert.<br/><br/><button class='gbqfb'>Über Ihr Google-Konto einloggen</button></div>"+
					"");
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

var isNewKey = false;
$(function()
{
	$("#generateKey").click(function(e)
	{
		e.preventDefault();
		var myKey = "K";
		myKey += (new Date()).getTime();
		for(var i=0; i<=6; i++)
			myKey += parseInt((Math.random()*10)-1)
//		Math.random()
		$("#myKey").val(myKey);
		alert("Ihr neuer Schlüssel wurde in das Schlüsselfeld übertragen.\nBitte notieren/kopieren Sie sich diesen Schlüssel auf Ihren Computer für spätere Logins.")
		isNewKey = true;
	});

	$("#keyLogin").click(function(e)
	{
		e.preventDefault();
		var myKey = $("#myKey").val();
		if(!myKey || myKey.length < 20)
			alert("Bitte geben Sie Ihren Schlüssel ein.\n\nSollten Sie noch keinen Schlüssel besitzen, (und nur dann) erzeugen Sie\nbitte einen neuen über 'Schlüssel erzeugen' und notieren / kopieren Sie sich diesen an einen sicheren Ort.");
		else
		{
			if(isNewKey)
				alert("Bitte notieren/kopieren Sie sich ihren Schlüssel:\n\n"+myKey+"\n\n..Verwenden Sie bei künftigen Logins nur noch diesen Schlüssel und erzeugen Sie später keinen weiteren.\n(Das Verwenden mehrerer Schlüssel kann zur Löschung Ihres Accounts führen)");
			location.replace("/beta/pages/login.jsp?key="+myKey);
		}
	});
})