# ImageFeed

## Purpose and goals of the application ##

The multi-page app is designed to view images via the Unsplash API.

Application goals:

- browse an endless feed of images from Unsplash Editorial;
- view brief information from the user's profile.

## Description of the application ##
- The application requires authorization via OAuth Unsplash.
- The main screen consists of a ribbon with images. The user can view it, add and remove images from favorites.
- Users can view each image individually and share a link to them outside the app.
- The user has a profile with featured images and brief information about the user.
- Additionally, the mechanics of favorites and the ability to like photos when viewing the image in full screen.

## Technology stack ##
- Swift, UIKit
- Architecture: MVC, MVP
- Code layout
- UITabBarController, UITableView, WKWebView
- URLSession
- Swift Package Manager
- Keychain
- OAuth 2.0
- Kingfisher
- KVO
- Multithreading
- UnitTests, UITests

## Installation ##
Installation and launch via Xcode. Required dependencies are downloaded using Swift Package Manager.

Minimum system version iOS 13.0.

To use the application you must have an account in the [Unsplash](https://unsplash.com/)

## Links ##
[Design Figma](https://www.figma.com/file/HyDfKh5UVPOhPZIhBqIm3q/Image-Feed-(YP)?type=design&node-id=318-1469&mode=design&t=f39mrpLLMUakOhoy-0)
