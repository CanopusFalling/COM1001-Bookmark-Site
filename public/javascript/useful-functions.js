"use strict";

function openInNewTab(url) {
	var win = window.open(url, "_blank");
	win.focus();
}

function openInNewTabAndRecordView(url, ID) {
	var win = window.open(url, "_blank");
	window.location = "bookmark-addView?bookmarkID=" + ID;
	win.focus();
}

function showAdvancedOptions() {
	var advancedSearch = document.getElementById("advanced-search-form");
	advancedSearch.style.display = "block";

	var dropdownButton = document.getElementById("advancedSearch-button");
	dropdownButton.onclick = function() {
		hideAdvancedOptions();
	};
	dropdownButton.src = "assets/images/minus.png";
}

function hideAdvancedOptions() {
	var advancedSearch = document.getElementById("advanced-search-form");
	advancedSearch.style.display = "none";

	var dropdownButton = document.getElementById("advancedSearch-button");
	dropdownButton.onclick = function() {
		showAdvancedOptions();
	};
	dropdownButton.src = "assets/images/plus.png";
}
