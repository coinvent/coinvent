
/** Lets use a template to put some content into the page */
var num = 0;
var result = true;
var currentname = '';


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
		
		/*$('#PickConceptsForm').removeClass('loading');*/
		/*** **/
		/*var prev = fConcepts.responseJSON.cargo;
		console.log("context=", {name:'input1', previous:prev});
		$('#conceptEditor1').html(templates.ConceptEditor({name:'input1', previous:prev}));
		$('#conceptEditor2').html(templates.ConceptEditor({name:'input2', previous:prev}));
		$('.outputLoading').hide();*/

        load_st(num);


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
		$('#nextbtn').hide();	
		/*** WIRING **/

		$('.doBlend').on('click',function(e){
			e.preventDefault();
			callBackend();
		});
		
		$('.doNext').on('click',function(e){
			e.preventDefault();
			if (!callNext())
			{
				return false;
			}

		});
		
	}); 

});

function st()
{
  $('textarea[name=tlemma]').val(currentname);

}


function save_st()
{
    var res;
    if (result){res = "Analogy"}else{res="NoAnalogy"};
$.ajax({
	url: '/cmd/experiment',
	data: {
			action:"save",
	        result:res,
	    	suggestion:$('#their_suggestion').val(),
	    	correctness:$('#correctness').val(),
	    	proveability:$('#proveability').val(),
	    	amended_suggestion:$('#amended_suggestion').val(),
	    	helpful:$('#helpful').val()
	    }
        });
}


function load_st(num)  {
 $.ajax({
	url: '/cmd/Experiment',
	data: {
		action:"get",
		current:(num.toString())
			}
        })
	.then(function(c,d)
	{
// source theorem, target theorem, source theory, target theory, source lemma, target lemma, sourceid, targetid, result
           


		console.warn(c,d);
	    
	    $('textarea[name=slemma]').val(c.cargo.slemma);
	    $('textarea[name=ttheorem]').val(c.cargo.ttheorem);
	    $('textarea[name=stheorem]').val(c.cargo.stheorem);
	    $('textarea[name=stheory]').val(c.cargo.stheory);
	    $('textarea[name=ttheory]').val(c.cargo.ttheory);
	    currentname=c.cargo.tlemma;
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
    if (num==1)
    {
    	//Go to finished page....
    	window.event.returnValue = false;
    	window.location.href='localhost:8300/static/experiment/thanks.html';
    	window.alert("Thanks for participating!");
        return false;
    }
    else{
    	save_st();
		$('textarea[name=tlemma]').val('');  
		num = num +1;
		load_st(num);
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
		$('#nextbtn').hide();	
		return true;b
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

