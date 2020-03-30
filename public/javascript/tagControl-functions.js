"use strict";

function updateList() {
	var searchVal = document.getElementById("tagSearch").value;
	searchVal = searchVal.toUpperCase();

	var items = document
		.getElementById("tagList")
		.getElementsByClassName("tagItem");

	var maxItems = 10;
	var currentlyItems = 0;

	for (var i = 0; i < items.length; i++) {
		var item = items[i];
		var txtValue = item.getElementsByTagName("label")[0].innerText;
		if (
			txtValue.toUpperCase().indexOf(searchVal) == -1 ||
			searchVal == ""
		) {
			item.style.display = "none";
		} else {
			item.style.display = "block";

			currentlyItems++;
			if (currentlyItems >= maxItems) break;
		}
	}
}
