desc "Updates weekly playlist"
task :update_playlists => :environment do
  Worker.update_group_playlists
  Worker.update_personal_playlists
end
