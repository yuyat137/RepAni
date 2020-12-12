$('#time_reset').on('click', function(){
  let lastMinute = $('#search_begin_minutes option:last-child').val()
  let lastSecond = $('#search_begin_seconds option:last-child').val()
  $("#search_begin_minutes").prop("selectedIndex", 0);
  $("#search_begin_seconds").prop("selectedIndex", 0);
  $("#search_end_minutes").prop("selectedIndex", lastMinute);
  $("#search_end_seconds").prop("selectedIndex", lastSecond);
})

