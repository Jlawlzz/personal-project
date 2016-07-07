# Tango Music

Tango is a project aiming to off-board playlist curation and creation from the streaming services responsibility to a
third-party source. Tango music automatically re-populates your streaming service weekly with suggested tracks
(similar to Discover Weekly), or what your friends have been liking in the past week via group playlists.

##Current Build:
  - Tango can currently create a weekly updated playlist for users with Spotify that is informed by what
    they have saved in the past few days. Suggested songs are gathered using Echonest API, which is a similar process to how Spotify
    creates their Discover Weekly playlists.
  - Users can create Group Playlists with other friends who use Tango. These playlists grab the most recent liked songs from each
    person in the group and populates one single playlist. This feature also updates weekly.

##Future Goals:
  - If too many users are utilizing playlist creation our service returns a REST error from excessive requests. Breaking individual functions into micro-services with their own API keys may solve many aspects of this issue.
  - The aesthetic and UX/UI of this site are not quite where they should be. The exception to this would be the nav-bar on the left side of the page, which seems great functionally.
  - We would love to expand functionality to other streaming apps like Google Play and possibly Tidal. Echonest allows us to agnostify the track data we take from these services, playlist collaboration across services is not something offered by the industry currently.

##Code

[Original Github Repo](https://github.com/Jlawlzz/personal-project/tree/master/soiree)  
[Production Site](https://tango-music.herokuapp.com/)  

![Screenshot of app in action](http://g.recordit.co/YC9c0XAQIY.gif)  

###[Code Im Proud of](https://github.com/Jlawlzz/tango-music/blob/master/app/models/worker.rb)

This is a worker we created to update all playlists on the app every week.  
We are currently utilizing the Heroku scheduler for this task.

Areas to improve:
- We are subjected to rate limits currently which results in request timing issues. Because of this when the worker runs,
it must rest so that a rest client error does not result.  To make testing efficient we needed to tell the tasks not to rest,
Which is why we have env='dev' as a default (pass in 'test' while testing). This seems like a less than ideal approach to the
problem. It may be worthwhile to consider switching to SideKiq for this task in future iterations.



###[Code that still needs work](https://github.com/Jlawlzz/tango-music/blob/master/app/models/group.rb)

This code represents the start of our group playlist creation, from here data is passed to a variety of other processes.
The logic in this flow is still not broken into an ideal refactored state. When we break the backend off into a stand-alone
API, it may be best to allow this code to inform our design decisions but start fresh and rethink our structure.  Creating
a micro-service for track id translation between the streaming service and Echonest would do a lot to declutter and organize
this process.
