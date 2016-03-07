class Song < ActiveRecord::Base
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  def truncate(string)
    case string
    when 'title' then self.title[0..25]
    when 'artist' then self.artist[0..25]
    when 'album' then self.album[0..25]
    end
  end
end
