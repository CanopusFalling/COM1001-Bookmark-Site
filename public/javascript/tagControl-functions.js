"use strict";

/*
When user types a name display first {MAX_ITEMS} tags in the list
that containg the name
*/
function updateList() {
	var searchVal = document.getElementById("tagSearch").value;
	searchVal = searchVal.toUpperCase();

	var items = document
		.getElementById("tagList")
		.getElementsByClassName("tagItem");

	const MAX_ITEMS = 10;
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
			if (currentlyItems >= MAX_ITEMS) break;
		}
	}
}

/*
When user tries to add new tag check if it already exists 
if not add a new item to the list
 */
function addTag() {
	var tagList = document.getElementById("tagList");
	var proposedTagField = document.getElementById("tagSearch");
	var proposedTag = proposedTagField.value;
	//check if proposed tag already exists if yes then tell user and return
	if (document.getElementById(proposedTag + "_tag") != null) {
		alert("This tag already exists");
		return;
	}

	//crete new list item with checkbox and with label and append to the list

	var newInput = document.createElement("INPUT");
	newInput.type = "checkbox";
	newInput.id = proposedTag + "_tag";
	newInput.onclick = function() {
		clickedTag(proposedTag);
	};

	var newLabel = document.createElement("LABEL");
	newLabel.htmlFor = proposedTag + "_tag";
	newLabel.innerText = proposedTag;

	var newItem = document.createElement("LI");
	newItem.classList = "tagItem";
	newItem.style.display = "none";

	newItem.appendChild(newInput);
	newItem.appendChild(newLabel);

	tagList.appendChild(newItem);

	updateList();
}

function clickedTag(name) {
	var counter = document.getElementsByName("numOfTags")[0];
	var count = counter.value;
	var tagControl = document.getElementById("tagControl");

	var found = false;
	//check if tag was on the list
	for (var i = 0; i < count; i++) {
		var checking = document.getElementsByName("tagNo" + i)[0];

		if (found) {
			//if tag was already removed the rest has to change index
			checking.name = "tagNo" + (i - 1);
		} else if (checking.value == name) {
			//if given tag is on the list remove it
			tagControl.removeChild(checking);
			counter.value = count - 1;
			found = true;
		}
	}

	if (!found) {
		//if given tag wasn't on the list addd a new one
		var newTag = document.createElement("INPUT");
		newTag.type = "hidden";
		newTag.name = "tagNo" + parseInt(count);
		newTag.value = name;
		counter.value = parseInt(count) + 1;

		tagControl.appendChild(newTag);
	}
}
