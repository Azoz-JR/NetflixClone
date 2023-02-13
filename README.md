# NetflixClone

NetflixClone is an iOS application to watch trailers of films and TV shows both old and new.



https://user-images.githubusercontent.com/77539943/218476418-5a68047d-ea54-4d46-a7af-46b16a3f8a75.mp4


# Built with
- SwiftUI


# Third parties
- TMDB API
- Youtube Data API
- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI).

# App Structure
- Netflix
  - Views
    - ContentView
    - HomeView
    - SearchView
    - DownloadView
    - HorizontalListView
    - MovieTrailerView
    - TvTrailerView
    - WebView
    
  - View Models
    - NetflixViewModel
    
  - Load Manager
    - APICaller
    
  - Resources
    - NetflixApp
    - Extensions
    - FileManager-DocumentsDirectory
    - Constants
    
  - Models
    - Movie
    - TV
    - YoutubeSearchResponse
    
