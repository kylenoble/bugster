$( document ).ready(function() {
	$(".comments-button").on("click", function() {
		$(".comments-form").toggle();
		$(".comments-button").toggle();
	});

	$(".bug-submit, .comment-submit, .request-submit").on("click", function() {
		Pace.restart();
	});
});
