$(document).ready(function(){
  renderGroupSongs();
})


function renderGroupSongs(){
  $.ajax({
    url: "/api/v1/group/platform_playlists",
    type: "POST",
    data: {id: document.querySelector('.groupPlaylistId').id },
    success: function(response){
      console.log("Success!", response.songs)
    }

  })

}
