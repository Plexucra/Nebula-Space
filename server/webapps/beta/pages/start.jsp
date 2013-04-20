<%@ page pageEncoding="UTF-8"%>
<!doctype html>
<html lang="de">
<head>
	<meta charset="utf-8">
	<title>jQuery UI Example Page</title>
	<link href="../css/default_thema/jquery-ui-1.10.1.custom.css" rel="stylesheet">
	<link href="../css/default_thema/colony.css" rel="stylesheet">
	<script src="../js/jquery-1.9.1.js"></script>
	<script src="../js/jquery-ui-1.10.1.custom.js"></script>
	<script>
		$(function()
		{
			$( "#button_login" ).button().click(function(e) 
			{
				e.preventDefault();
				$.getJSON('/json/checkLogin.jsp?email='+$("#email").val()+'&kennwort='+$("#kennwort").val(), function(data2)
				{
					alert(data2["errorMessage"]);
					if(data2["errorMessage"])
					{
						alert(data2["errorMessage"]);
					}
					else location.replace("/pages/karte.jsp");
				});
			});
		});
	</script>
</head>
<body>
<div class="pages_start">
	<div class="loginForm ui-widget">
		<form>
		<table>
			<tr>
				<td><label for="email">E-Mail:</label></td>
				<td><input type="text" name="email" id="email"/></td>
			</tr>
			<tr>
				<td><label for="kennwort">Kennwort:</label></td>
				<td><input type="password" name="kennwort" id="kennwort"/></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><button id="button_login">Einloggen</button></td>
			</tr>
		</table>
		</form>
	</div>
</div>
</body>
</html>