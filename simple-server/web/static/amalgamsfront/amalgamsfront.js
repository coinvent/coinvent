
/** Lets use a template to put some content into the page */
$(function() {

	loadTemplates('hdtpfront-templates.html', function(){
		$('#MainContent').html( templates.HdtpFrontTemplate({name:'Ewen'}) );
	}); 

});

/** Let's call the server */
$(function() {
	$('#ServerSays').text("Calling server...");

	/** $.get('/cmd/hdtp/hdtp.json?request=start')
	.then(function(a,b) {
		console.log('HelloData',a,b);
		$('#ServerSays').text(a.cargo.output); 
	});*/
});
	