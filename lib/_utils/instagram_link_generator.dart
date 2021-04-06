String getInstaGraphQLLink(String link) {
  var linkEdit = link.replaceAll(" ", "").split("/");
  return '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}' +
      "/?__a=1";
}
