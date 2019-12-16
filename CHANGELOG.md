# Changelog


* Doing

    + Model `PlayerSummary`

* 0.5.1

    + Added custom key decoding strategy
        + Convert XML specific JSON keys (`@` and `$`)
        + No need for specify each `CodingKey` manually

* 0.5.0

    + Constraint fixes

* 0.4.9

    + Minor fix in `SharkScope.Configuration.plist`

* 0.4.8

    + Window tracking prototype (nicely tracks Tourney Lobby windows)

* 0.4.4

    + SharkScope refactor (being more value / protocol / generic oriented)
        + Same structure like PokerTracker (except async `Result`)

* 0.4.2

    + Window tracking prototype

* 0.4.1

    + `LiveTourneyPlayer: Equatable` tweaks  
    + Removed `MTT` filter from `BasicPlayerStatistics`
    + `playerStatisticsAtSelectedTable` set can also indicate change

* 0.4.0

    + Added statistics to players table
    + `BasicPlayerStatistics`  can be filtered for `id_player` list

* 0.3.81

    + Some comments / access level adjustments

* 0.3.8

    + Removed retaining any display data
        + Only retain actual models
        + Display data created on demand

* 0.3.7

    + Moved Table Selector Model to ViewModel as well
    + ViewModel holds actual model data instead of display data
    + Cleaned ViewModel `changed` lookup 

* 0.3.62

    + PokerTracker models now `Equatable`    

* 0.3.61

    + Some renamings

* 0.3.6

    + Hooked up player names

* 0.3.5

    + PokerTracker refactor
        + Models are pure values (`Entry` and `Query`)
        + `PokerTracker.fetch` does the only Postgres communication (using Generics)
    + UI refactor
        + Cleaned up ViewController (only hooks to ViewModel and Outlets)
        + ViewModel does all the data fetching / formatting / event handling
    
* 0.3.1

    + Combine multiple query results prototype

* 0.3.0

    + Hooked up actual player list from Poker Tracker

* 0.2.9

    + Created Players `TableView`
        + Extracted data bindings to `TourneyTableViewModel` (started to move down data)
    + Further Layout refinements

* 0.2.8

    + Added Table Selector
    + Layout refactors

* 0.2.5

    + Created `RequestCache`
        + FIlename / Folder creation
        + Encapsulated decoding
    + Config from `plist`

* 0.2.1

    + Minor refactorings
    + Save JSON result to `Documents` folder

* 0.2.0

    + Refactored `Request`
        + Uses `Result`
        + Swift 5 API conversion
        + Added errors
        + Response is `Decodable`

* 0.1.4
    
    + Authentication / JSON previews

* 0.1.3

    + Added XML parsing
        + Implemented `VersionCheckResponse`

* 0.1.2

    + Removed textfields

* 0.1.1

    + Hooked up PokerTracker values to UI

* 0.1.0

    + Created PokerTracker model protocols / implementation
        + `LiveTourneyTable`
        + `LiveTourneyPlayer`
        + `BasicPlayerStatistics` (added corresponding calculations)

* 0.0.5

    + Created PokerTracker models, populate from SQL

* 0.0.4

    + `PokerTracker` (Postgres connection / fetch prototype)
    
* 0.0.1 - 0.0.3
    
    + Initial commit / Basic blind level calculations / Overlay UI 

