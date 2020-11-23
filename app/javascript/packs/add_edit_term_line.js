$("#add_term_line").on('click', function() {
  $("#term_lines tbody tr:last").clone(true).appendTo("#term_lines tbody");
  $(".term-year:last").val("");
  $(".term-season:last").val("");
  $(".term-now:last").val("");
});
