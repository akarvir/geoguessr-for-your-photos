# Roll Guesser

A personal GeoGuesser for your iPhone camera roll. Each round picks 5 random geotagged photos and asks you to identify when and where they were taken.

## How it works

**Guess.** For each photo you pick the year (multiple choice), the month, and drop a pin on a map zoomed to the region where the photo was taken.

**Score.** Year correct earns 2 pts. Month correct earns 2 pts. Location is scored on distance, up to 6 pts for a pin within 10 km. Each photo is worth 10 pts, 50 pts per round.

**Review.** After each guess you see exactly how close you were: your date vs the actual date, your pin coordinates vs the real ones, and a distance in km.

## Screenshots

<p float="left">
  <img src="screenshots/permission.jpeg" width="30%" />
  <img src="screenshots/game.jpeg" width="30%" />
  <img src="screenshots/result.jpeg" width="30%" />
</p>

## Requirements

Xcode 16 or later. iOS 17 or later. Only photos with both GPS and date metadata are used.
