
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
		
	

        load_st(0);


		$('#l_their_suggestion').hide();
		$('#their_suggestion').hide();	
		$('#l_correctness').hide();
		$('#correctness').hide();	
        $('#l_proveability').hide();
		$('#proveability').hide();	
        $('#l_amended_suggestion').hide();
		$('#amended_suggestion').hide();
		$('#l_helpful').hide();
		$('#helpful').hide();	
		$('#l_creative').hide();
		$('#creative').hide();
		$('#nextbtn').hide();	

		/*** WIRING **/

		$('.doBlend').on('click',function(e){
			e.preventDefault();
			callBackend();
		});
		
		$('.doNext').on('click',function(e){
			e.preventDefault();
			callNext();

		});
		
	}); 

});

function st()
{
  $('textarea[name=tlemma]').val(tlemma);

}


function load_init()
{
$.ajax({
	url: '/cmd/Experiment',
	data: {
		action:"example"
			}
        })
	.then(function(c,d)
	{

		console.warn(c,d);
	    
	    $('textarea[name=slemma]').val(c.cargo.slemma);
	    $('textarea[name=ttheorem]').val(c.cargo.ttheorem);
	    $('textarea[name=stheorem]').val(c.cargo.stheorem);
	    $('textarea[name=stheory]').val(c.cargo.stheory);
	    $('textarea[name=ttheory]').val(c.cargo.ttheory);
	    tlemma = c.cargo.tlemma;
	});
}

function save_st()
{
    var res;
    if (result){res = "Analogy"}else{res="NoAnalogy"};
$.ajax({
	url: '/cmd/experiment',
	data: {
			action:"save",
			timestamp:currentname,
	        result:res,
	        file_id:file_id,
	    	suggestion:$('#their_suggestion').val(),
	    	correctness:$('#correctness').val(),
	    	proveability:$('#proveability').val(),
	    	amended_suggestion:$('#amended_suggestion').val(),
	    	helpful:$('#helpful').val(),
	    	creative:$('#creative').val()
	    }
        });
}


function load_st(num)  {
 $.ajax({
	url: '/cmd/Experiment',
	data: {
		action:"get",
		used:file_ids
			}
        })
	.then(function(c,d)
	{

		console.warn(c,d);
	    
	    $('textarea[name=slemma]').val(c.cargo.slemma);
	    $('textarea[name=ttheorem]').val(c.cargo.ttheorem);
	    $('textarea[name=stheorem]').val(c.cargo.stheorem);
	    $('textarea[name=stheory]').val(c.cargo.stheory);
	    $('textarea[name=ttheory]').val(c.cargo.ttheory);
	    tlemma = c.cargo.tlemma;
	    file_id = c.cargo.file_id;
	    if (file_ids == "")
	    	{file_ids = file_id;}
	    else
	    	{file_ids = file_ids+" "+file_id;}
	    //file_ids = file_ids.substring(0,(file_ids.length-1));
		result = (c.cargo.result =="yes");
	   });		
    
 
}


function getInput(name) {
	var $tab = $('#ConceptEditor'+name+' .active');	
	return {name: $tab.find('.form-control[name=name]').val(), 
			text: $tab.find('textarea[name=text]').val(), 
			url: $tab.find('.form-control[name=url]').val()
			};
}

function callNext()
{
    if (num==6)
    {
    	//Go to finished page....
    	//window.event.returnValue = false;
    	
    	//window.alert("Thanks for participating!");
    	save_st();
    	window.location.href='/static/experiment/thanks.html';
        return false;
    }
    else{
    	if (num != 0)
    	{save_st();}
		$('textarea[name=tlemma]').val('');  
		
		load_st(num);
		num = num + 1;
		$('#l_their_suggestion').hide();
		$('#their_suggestion').hide();	
		$('#their_suggestion').val('');
		$('#l_correctness').hide();
		$('#correctness').hide();	
		$('#correctness').val('');
		$('#l_proveability').hide();
		$('#proveability').hide();	
		$('#proveability').val('');	
        $('#l_amended_suggestion').hide();
		$('#amended_suggestion').hide();
		$('#amended_suggestion').val('');
		$('#l_helpful').hide();
		$('#helpful').hide();	
		$('#helpful').val('');
		$('#l_creative').hide();
		$('#creative').hide();	
		$('#creative').val('');
		$('#nextbtn').hide();	
		return true;
	}

}

function callBackend()
{
	st();
   if (result)
  {
     $('#l_correctness').toggle();
   $('#correctness').toggle();	
   $('#l_proveability').toggle();
   $('#proveability').toggle();	
   $('#l_amended_suggestion').toggle();
   $('#amended_suggestion').toggle();
   $('#l_helpful').toggle();
   $('#helpful').toggle();
   $('#l_creative').toggle();
   $('#creative').toggle();				
   $('#nextbtn').toggle(); 
  } 
  else
  {
   $('#l_their_suggestion').toggle();
   $('#their_suggestion').toggle();
   $('#l_correctness').toggle();
   $('#correctness').toggle();	
   $('#l_proveability').toggle();
   $('#proveability').toggle();	
   $('#nextbtn').toggle();
   }
}

