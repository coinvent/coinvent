
/** Lets use a template to put some content into the page */
$(function() {

	loadTemplates('/static/blendui/blendui-templates.html', function(){		
		
		/*** **/

		$('#conceptEditor1').html(templates.ConceptEditor({name:'input1'}));
		$('#conceptEditor2').html(templates.ConceptEditor({name:'input2'}));


		/*** WIRING **/

		$('.doBlend').on('click',function(e){
			e.preventDefault();
			$.get('/cmd/blend?action=hdtp')
			.then(function(r){
				console.warn(r);
			});
		});
		
		$('.doBlendNext').on('click',function(e){
			e.preventDefault();
			$.get('/cmd/blend?action=next')
			.then(function(r){
				console.warn(r);
			});
		});
		
		$('.doBlendClose').on('click',function(e){
			e.preventDefault();
			$.get('/cmd/blend?action=close')
			.then(function(r){
				console.warn(r);
			});
		});
		
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


