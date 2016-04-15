/* bootstrap */
ready = function() {
	$(".modal").on('shown.bs.modal', function() {
	    $(this).find("[autofocus]:first").focus();
	});

	$(".modal").on('hidden.bs.modal', function() {
	    $(this).html("");
	});

	$("#lists").on('hide.bs.collapse', '.panel', function (e) {
	  $(e.currentTarget).css("border-radius", "4px");
	});

	$("#lists").on('show.bs.collapse', '.panel', function (e) {
	  $(e.currentTarget).css("border-radius", "");
	});
};
$(document).ready(ready);
// turbolinks event 
// https://habrahabr.ru/post/167161/
$(document).on("page:load", ready);

/* other */
closeFlash = function() {
	$("#flash").remove();
}

