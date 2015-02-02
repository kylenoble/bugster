$(".comments-button").on("click", function() {
	$(".comments-form").css("display","block");
	$(".comments-button").css("display", "none");
});

$(".bug-submit, .comment-submit").on("click", function() {
	Pace.restart();
});