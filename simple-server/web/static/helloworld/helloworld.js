
/** Lets use a template to put some content into the page */
$(function() {

	loadTemplates('helloworld-templates.html', function(){
		$('#MainContent').html( templates.HelloWorldTemplate({name:'Daniel'}) );
	}); 

});

/** Let's call the server */
$(function() {
	$('#ServerSays').text("Calling server...");

	$.get('/helloworld/HelloData.json')
	.then(function(a,b) {
		console.log('HelloData',a,b);
		$('#ServerSays').text(a.cargo.greeting);
	});
});
	