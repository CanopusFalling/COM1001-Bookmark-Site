"use strict";

function openInNewTab(url) {
	var win = window.open(url, "_blank");
	win.focus();
}

function openInNewTabAndRecordView(url, ID) {
	window.location = "bookmark-addView?bookmarkID=" + ID;
	openInNewTab(url);
}
