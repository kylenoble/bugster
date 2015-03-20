$( document ).ready(function() {
	$(".comments-button").on("click", function() {
		$(".comments-form").toggle();
		$(".comments-button").toggle();
	});

	$(".bug-submit, .comment-submit, .request-submit").on("click", function() {
		Pace.restart();
	});

	if (window.location.search.search(/[?&]status=open(?:$|&)/) !== -1) {
		$("tabs a").removeClass("tab-active");
		$("#tab2 a").addClass("tab-active");

		$('#bugsearch').on('click',function(){
	    var word = $('#search_').val();
	    $(this).attr("href","/tickets?status=open&search_term=" + word.toString());
		});

	} else if (window.location.search.search(/[?&]status=completed(?:$|&)/) !== -1) {
		$("tabs a").removeClass("tab-active");
		$("#tab3 a").addClass("tab-active");

		$('#bugsearch').on('click',function(){
	    var word = $('#search_').val();
	    $(this).attr("href","/tickets?status=completed&search_term=" + word.toString());
		});
	} else {
		$("tabs a").removeClass("tab-active");
		$("#tab1 a").addClass("tab-active");

		$('#bugsearch').on('click',function(){
	    var word = $('#search_').val();
	    $(this).attr("href","/tickets?search_term=" + word.toString());
		});
	}

	$('#requestsearch').on('click',function(){
    var word = $('#search_').val();
    $(this).attr("href","/requests?search_term=" + word.toString());
	});

	if ($("img[alt='Loading']").length > 0) {
    console.log("loader exists");
    setTimeout(function () {
      location.reload();
    }, 5000);
  }

});
