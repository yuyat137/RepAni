$('#clipboard_copy').on('click', function(){
  let text = $('#copy_text').text();
  let $textarea = $('<textarea></textarea>');
  $textarea.text(text);
  $(this).append($textarea);
  $textarea.select();
  document.execCommand('copy');
  $textarea.remove();
});
