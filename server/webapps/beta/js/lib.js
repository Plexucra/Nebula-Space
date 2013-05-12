function showAjaxDialog( url, title,  options )
{
	var div = $("<div class='cn_dialog'>Wird geladen..</div>");
	if(title) div.attr("title", title);
	$.get(url).done(function(data2) 
	{
		div.html(data2);
	}).fail(function(e1,e2,e3) 
	{
		alert("Ein Fehler ist aufgetreten. \nBitte die Folgeseite dem Entwicklerteam senden..")
		document.write(e1.responseText);
	});
	if(options)
		div.dialog(options);
	else
		div.dialog({  modal: true  });
}