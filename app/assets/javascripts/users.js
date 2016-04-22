function countNonEmptyStrings(list) {
  var count = 0;
  for (var i = 0; i < list.length; i++) {
    if (list[i]) { count++; }
  }
  return count;
}

function updateWordCount() {
  textArea = document.getElementById("user_description") || document.getElementById("word_definition");
  words = textArea.value.trim().split(/ |\n/);
  length = countNonEmptyStrings(words);
  wordCount = document.getElementById("word_count");
  wordCount.innerHTML = length + "/100";
}
