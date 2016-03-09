task :update_personal_playlists => :environment do
  Worker.update_personal_playlists

end
