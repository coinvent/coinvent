
/** Lets use a template to put some content into the page */
var num = 0;
var result = true;
var currentname = '';
var file_ids = "";
var file_id = "";
var tlemma = "";


$(function() {

	//var fConcepts = $.get('/cmd/blend?action=list-concepts');

	var fTemplates = loadTemplates('/static/experiment/blendui-templates.html');
    window.onload=function(){
		var d = new Date();
		currentname = (d.getTime()).toString();
    }
	console.log("f", fTemplates);

	$.when(fTemplates)
		.then(function() {		
		
	

		
		$('.doNext').on('click',function(e){
			e.preventDefault();
			window.location.href="/static/experiment_unsupervised/index2.html";
			return false;

		});
		
	}); 

});

