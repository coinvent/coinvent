/**
 * Convenience for making Bootstrap notifications. 
 * Depends on: jQuery, Bootstrap
 * 
 * Example:
 * 
 * Toast.i("Some information").delay(1000).fadeOut();
 */
function Toast() {		
}
Toast.$div = $('<div style="position:fixed;top:50px;left:50px;right:50px;"></div>');
$('body').append(Toast.$div);
Toast.toast = function(type, msg) {
	var toast = $('<div class="alert alert-'+type+' alert-dismissible" role="alert"><button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>'
			+msg+'</div>');
	Toast.$div.append(toast);
	return toast;
};
/**
 * Warning!
 */
Toast.w = function(msg) {
	return Toast.toast("warning", msg);
};
/**
 * Error! (aka danger)
 */
Toast.e = function(msg) {
	return Toast.toast("danger", msg);
};
/**
 * Information
 */
Toast.i = function(msg) {
	return Toast.toast("info", msg);
};
/**
 * Success :)
 */
Toast.s = function(msg) {
	return Toast.toast("success", msg);
};