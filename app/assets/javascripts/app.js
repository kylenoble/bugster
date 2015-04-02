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
	    if (window.location.pathname == '/decision7/tickets') {
	    	$(this).attr("href","/decision7/tickets?status=open&search_term=" + encodeURIComponent(word.toString()));
	  	} else {
	  		$(this).attr("href","/ignitetek/tickets?status=open&search_term=" + encodeURIComponent(word.toString()));
	  	}
		});

	} else if (window.location.search.search(/[?&]status=completed(?:$|&)/) !== -1) {
		$("tabs a").removeClass("tab-active");
		$("#tab3 a").addClass("tab-active");

		$('#bugsearch').on('click',function(){
	    var word = $('#search_').val();
	    if (window.location.pathname == '/decision7/tickets') {
	    	$(this).attr("href","/decision7/tickets?status=completed&search_term=" + encodeURIComponent(word.toString()));
	  	} else {
	  		$(this).attr("href","/ignitetek/tickets?status=completed&search_term=" + encodeURIComponent(word.toString()));
	  	}
		});
	} else {
		$("tabs a").removeClass("tab-active");
		$("#tab1 a").addClass("tab-active");

		$('#bugsearch').on('click',function(){
	    var word = $('#search_').val();
	    if (window.location.pathname == '/decision7/tickets') {
	    	$(this).attr("href","/decision7/tickets?search_term=" + encodeURIComponent(word.toString()));
	  	} else {
	  		$(this).attr("href","/ignitetek/tickets?search_term=" + encodeURIComponent(word.toString()));
	  	}
		});
	}

	$('#requestsearch').on('click',function(){
    var word = $('#search_').val();
    $(this).attr("href","/requests?search_term=" + encodeURIComponent(word.toString()));
	});

	if ($("img[alt='Loading']").length > 0) {
    console.log("loader exists");
    setTimeout(function () {
      location.reload();
    }, 5000);
  }

});
