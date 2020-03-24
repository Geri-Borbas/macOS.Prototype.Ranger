<p align="center">
<img src="Documentation/Ranger.png" width="323" height="79" alt="Ranger"><br />
<img src="Documentation/Ranger_Services.png" width="323" height="49" alt="PokerStars, PokerTracker, SharkScope">
</p align="center">

**Powerful PokerStars macOS HUD integrating both PokerTracker and SharkScope statistics.** Detects open tables in [PokerStars], fetches corresponding hand history and plaer statistics from [PokerTracker] PostgreSQL database, then it fetches detailed [SharkScope] statistics using JSON REST API. All wrapped up into an actionable live UI, with a precisely aligned HUD.

<img align="center" src="Documentation/Ranger_Screenshot.png" width="963" height="855">

### Motivation

**The project is under development, not meant for public use (yet).** The app needs a licensed [PokerTracker 4] installed (with PostgreSQL database setup), and a [Gold SharkScope subscription] with API access. At the current state this repository is more of a collection/future reference of the building blocks of the interoperability with the services above.

### PokerTracker

The [**`PokerTracker`**] module is responsible for fetching live tournament and player data from [PokerTracker]. The app connects to the local [PokerTracker] PostgreSQL database using credentials setup in [`PokerTracker.Configuration.plist`] (configurations are simple `Decodable` structs using `PropertyListDecoder` for `plist` decoding). 

> More documentation is to come.

### License

Copyright © 2020. Geri Borbás. All rights reserved.


[PokerStars]: https://www.pokerstars.com
[PokerTracker]: https://www.pokertracker.com
[PokerTracker 4]: https://www.pokertracker.com/products/PT4/
[SharkScope]: https://www.sharkscope.com
[Gold SharkScope subscription]: https://www.sharkscope.com/#Pricing--html

[**`PokerTracker`**]: PokerTracker
[`PokerTracker.Configuration.plist`]: Ranger/Configuration/PokerTracker.Configuration.plist

