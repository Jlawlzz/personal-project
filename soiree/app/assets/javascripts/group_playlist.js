$(document).ready(function(){
  renderGroupSongs();
})


function renderGroupSongs(){

  var groupTarget = document.getElementById('groupSongs')

  if (groupTarget != null) {
    var groupSpinner = new Spinner().spin()
    groupTarget.appendChild(groupSpinner.el)

    $.ajax({
      url: "/api/v1/group/platform_playlists",
      type: "POST",
      data: {id: document.querySelector('.playlistId').id },
      success: function(response){
        console.log("Success!", response.songs)
      }

    })
  }


}
