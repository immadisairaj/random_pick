<p align="center">
    <img src="./random_pick_logo.png" height="150">
</p>
<h1 align="center">Random Pick</h1>
<p align="center">
    an application which decides/picks an item from the given pool
</p>
<p align="center">
 <!-- <a href="https://randompick.immadisairaj.dev">
    <img src="https://img.shields.io/badge/Visit-Website-e91e62" alt="website"></img>
  </a> -->
  <a href="https://github.com/immadisairaj/random_pick/actions/workflows/random_pick.yaml">
    <img src="https://github.com/immadisairaj/random_pick/actions/workflows/random_pick.yaml/badge.svg" alt="tests">
  </a>
  <a href="https://pub.dev/packages/very_good_analysis">
    <img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style">
  </a>
  <a href="https://github.com/immadisairaj/random_pick/blob/main/LICENSE.md">
    <img src="https://img.shields.io/github/license/immadisairaj/random_pick.svg" alt="license">
  </a>
  <a href="https://randompick.immadisairaj.dev/privacy_policy.html">
    <img src="https://img.shields.io/badge/privacy-policy-ea4ca0.svg" alt="privacy policy">
  </a>
</p>
<p align="center">
  <a href='https://play.google.com/store/apps/details?id=com.immadisairaj.random_pick&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img width="150px" alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png'/></a>
  <a href='https://apps.apple.com/us/app/random-pick-a-click-away/id6473739306'><img width="164px" alt='Download on the App Store' src='https://randompick.immadisairaj.dev/screenshots/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg'/></a>
</p>
<br>

## What this app does

The application has the following functions as of now.

1. Numbers - It takes in two integer values __min__ _(inclusive)_ and __max__ _(inclusive)_, then returns a picked random number from the range.
2. List - It takes a list of items<sup>[1]</sup>, then returns a random item (picked) from the pool. The items inside the list can be (un)checked to include in the item pool.
3. History - All the picks are stored in the device, with an option to delete them when not needed.

<sup>[1]</sup>item: The item can be any string - a number, a name, a place, an animal, a thing, an object, etc.

## Motivation

As a Sri Sathya Sai Baba devotee, whenever struck somewhere, we have a habit of writing a few chits, putting them near Swamy and then picking one of the chits. We then blindly follow what is there in the chit as a command from Swamy.

Many people across the globe use the similar concept of picking randomly to decide something, which inspired me to create this application, in general, to solve the problem using an application that is handy and paper-free.

## Screenshots

<img src="./screenshots/screenshot_1.png" height="500"> <img src="./screenshots/screenshot_2.png" height="500"> <img src="./screenshots/screenshot_3.png" height="500"> <img src="./screenshots/screenshot_4.png" height="500"> <img src="./screenshots/screenshot_5.png" height="500"> <img src="./screenshots/screenshot_6.png" height="500"> <img src="./screenshots/screenshot_7.png" height="500">

## Architecture

This application uses a clean architecture (feature first) with the help of bloc library for the business logic.

## Open Source Libraries

Thanks to the Open Source community for providing many great libraries which improve the application performance in many great ways.

## Privacy Policy

The Privacy Policy of the app is in the site: [https://randompick.immadisairaj.dev/privacy_policy.html](https://randompick.immadisairaj.dev/privacy_policy.html)

## License

The project is licensed under the BSD-3-Clause License, see the [LICENSE.md](https://github.com/immadisairaj/random_pick/blob/main/LICENSE.md) for more details
