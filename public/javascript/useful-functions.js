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
