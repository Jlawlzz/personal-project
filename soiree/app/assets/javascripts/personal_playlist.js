function renderAllSongs(){

  var target = document.getElementById('personalSongs');

  if (target !== null) {
    var spinner = new Spinner().spin();
    target.appendChild(spinner.el);

    $.ajax({
      url: '/api/v1/personal/platform_playlists',
      type: 'POST',
      data: {id: document.querySelector('.playlistId').id},
      success: function(response) {
        console.log("Success!", response.songs);
      }
    });
  }

}
