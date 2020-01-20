# Changelog


* Doing

    + Next up
        + `Tournaments` cache
            + Test (hopefully without search quota cost due to working cache)
            + Fetch sharkscope status after requests (explicitly in controllers)
                + A simple authenticated request with error can be sufficient 
        
    + Quick Features (to right-click context menus)
        + Normalized / Absolute switch for Finishes histogram
        + Slope could be drawn for a distinct small icon (not cover histogram)
        + `TableWindowInfo`
            + Regex title recognition (with tests)

    + Features
        + Final table positions column
        + Add nationality (flag icon) with local time (!)
        + Game distribution in time Graph (scatter)
        + Cursor for Finishes (get live tourney data)
        + Get player stats for hero filtered for villain (clickable)
        + SharkScope
            + Filters
                + Last one year
                + Only sit and gos
                + Only this type of tourney (entrants, stake)
            + Profit graph (?)

* Feature/Data/SharkScope/Tournaments/0.2.3

    + Removed hardcoded base path stripping
        + Removed `SharkScope.Service.basePath`
        + Caching is initialized from `ApiRequest` instead of `UrlCompoments`

* Feature/Data/SharkScope/Tournaments/0.2.0

    + SharkScope Request / Response refactor (for supporting CSV responses)
        + `ApiRequest` now have `basePath` and `contentType`
        + Created `ApiResponse` as base protocol for every response (for `SharkScope.Service.fetch`)
            + Can be initialized from string (either JSON or CSV)
            + Can be represented as string (either beautyfied JSON or CSV)
        + Removed serialization code from `SharkScope.Service.fetch`
            + Created `JsonResponse` with default implementations for JSON serialization
            + Created  `Tournaments` for (the only) CSV serialization
        + Created `Tournaments` request (yet untested)

* Feature/Data/SharkScope/Tournaments/0.1.0

    + Created `Tournaments` model
        + Added `SharkScope.Request.basePath` / `SharkScope.Request.contentType` (with default values) 
        + Can be intialized from SharkScope `Tournaments.csv` format
    + Added `SwiftCSV` to `SharkScope` module
    + Added `SharkScopeTests` target
        + Moved `LinearRegression` tests in place
        + Created tests for CSV parsing

* 1.8.9

    + Every `Model.Player` use a single shared (static) `PokerTracker.Service()` (no connection overload)

* 1.8.8

    + Hooked up missing delegate binding in `TournamentViewController`
    + Columns can be hidden when instantiating `PlayersWindowController`
        + Hide `Seat` and `Stack` columns for player collections

* 1.8.7

    + Created windows for player tables (`PlayersWindowController` / `PlayersViewController`)

* 1.8.5

    + Merged `Feature/UI/TableView_Refactor`
    + Added `PlayersTableWindowController` for standalon player lists
    + Added player list menu items for `StatusBarItem`

* Feature/UI/TableView_Refactor/0.2.6

    + `PlayersTableViewController` / `TournamentViewController` auto-layout

* Feature/UI/TableView_Refactor/0.2.5

    + Renamed `Tourney` window things to `Tournament`

* Feature/UI/TableView_Refactor/0.2.4

    + ViewModels use delegates for callbacks (distinct Player and Tourney updates)
    + `Finished` cell drawing tweaks

* Feature/UI/TableView_Refactor/0.2.2

    + Cleaned up `TourneyViewModel`

* Feature/UI/TableView_Refactor/0.1.0 - 0.2.0

    + Extracted `Model.Player` UI to `PlayersTableViewController`
        + Can be updated with any `[Model.Player]` collection
        + Extracted model features to `PlayersTableViewModel`
        + Tournament related features left in `TourneyViewModel`
    + Rewired IB bindings
        + Top-level objects are strong referenced in cell prototypes

* 1.8.1

    + Rows with zero stack gets dimmed only when playing (when `Model.Player.PokerTracker.handPlayer` is available)

* 1.8.0

    + Merged `Feature/Data/Model_Refactor`
    + Cleanup

* Feature/Data/Model_Refactor/0.2.0

    + `Model.Player.PokerTrackerData`
        + Became optional as well
        + Initialized with `playerName` as well
        + `Model.Player` (and corresponding UI) is fully functional with `name` only

* Feature/Data/Model_Refactor/0.1.6

    + `PokerTracker.Statistics` is queried based on `player_name` (instead of `id_player`)

* Feature/Data/Model_Refactor/0.1.5

    + Fixed unnecessary `TourneyTableViewModel` process
    + Created some basic `Model.Players` list

* Feature/Data/Model_Refactor/0.1.4

    + Fetching `Model.Player` collection(s) is extracted to `Model.Players`

* Feature/Data/Model_Refactor/0.1.3

+ `Model.Player` is initialized with `name` only (`PokerTracker.HandPlayer` is optional)

* Feature/Data/Model_Refactor/0.1.2

    + Extracted `PokerTracker` into a framework

* Feature/Data/Model_Refactor/0.1.1

    + Renamed `SharkScope.RequestError` to just `SharkScope.Error`

* Feature/Data/Model_Refactor/0.1.0

    + Extracted `SharkScope` into a framework

* Feature/Data/Model_Refactor/0.0.9

    + Added notes for getting `tournaments.csv`

* Feature/Data/Model_Refactor/0.0.8

    + Moved `PokerTracker.Error` into namespace

* Feature/Data/Model_Refactor/0.0.7

    + Renamings

* Feature/Data/Model_Refactor/0.0.6

    + Namespaced every (!) `PokerTracker` stuff into `PokerTracker` enum

* Feature/Data/Model_Refactor/0.0.5

    + Namespaced `PokerTracker` into `PT` enum (soon to be `PokerTracker`)

* Feature/Data/Model_Refactor/0.0.4

    + Renamed `playerViewModel` uses to `player`

* Feature/Data/Model_Refactor/0.0.3

    + Namespaced `Player` into `Model` enum

* Feature/Data/Model_Refactor/0.0.2

    + Renamings (`PlayerViewModel` to `Player`)

* Feature/Data/Model_Refactor/0.0.0 - 0.0.1

    + Basic branching

* 1.7.1

    + Renamed `master` to `Development` (builds live there)

* 1.7.0

    + Switched dependency management to CocoaPods (for `YapDatabase`)

* 1.6.9

    + Implemented `CompletedTournamentsRequest` (yet without UI)
    + Minor fix for window instantiation

* 1.6.8

    + Don't reinstantiate window if only table seating changed (within the same tournament)
    + Color range tweaks (`Finishes` color range limits to 70 instead of 80)

* 1.6.7

    + Layout adjustments
        + Hid window control buttons
        + Removed window title
        + Removed detailed summary
        + Merged status labels (fixed SharkScope update)
    + M-Display
        + M-Count is factoring player count (matched with PokerTracker M formula)
        + Player count is considering zero stack
        

* 1.6.6

    + `TableWindowInfo`
        + Extracted `TableInfo`
        + Created tests for various window titles / number formats
        + Refactored test suites

* 1.6.5

    + Losing / Winning days designed for less significance (narrower / dimmer)

* 1.6.4

    + Clamped width layout constraint value to 0+
        + Handle players with empty stats (e.g. "Pop737")
    + Count values into parenthesis (`Hands` / `Count`)
    + M-Display
        + Show each M below 5 M
    + Window title parsing fix
        + Enables for "-" in tournament name

* 1.6.2

    + Fixed stack bar percentage display (maximum plug)

* 1.6.1

    + Stack cell designs (colors / chunks / )

* 1.6.0

    + M-Display
        + `StackCellView` hooks
        + `StackBarView` drawing

* 1.5.9

    + Stack size bars now simply linear

* 1.5.8

    + Added hand count (for player statistics)

* 1.5.7

    + Get session player stats only for hero
        + Added `tourneyNumber` initialization parameter to `BasicPlayerStatistics` / `PlayerViewModel`
        + Fetch tourney statistics only for hero (`PlayerViewModel.pokerTracker.latestHandPlayer.flg_hero`)

* 1.5.6

    + Don't count `0` as stack display minimum

* 1.5.5

    + Column order tweaks (`Count` / `Entrants` / `Stake` / `Years` after `Finishes`)
    + PFR adjustments (color ranges / bar width)
    + 

* 1.5.4

    + Clear tables cache / Clear sharkscope cache for player (at context menu)

* 1.5.3

    + Context Menu for players
        + Copy name / basic statistics to clipboard

* 1.5.1

    + Menu item prototypes

* 1.5.0

    + SharkScope Finishes graph cell (custom drawing)
        + Extracted `LinearRegression` calculations
        + `GraphData` uses index for `x` value

* 1.4.1

    + Trial and error tweaks on nil value displaying
    + Opt-In statistics became optionals

* 1.4.0

    + Modeled JSON (with `Decodable` / `Equatable` implementation) for field beaten graph

* 1.3.8

    + Started to model "ByPositionPercentage" statistical dataset

* 1.3.7

    + Added linear regression prototype (test only yet)

* 1.3.5 - 1.3.6

    + Cell design 

* 1.3.5

    + Cell design / `ColorRanges`

* 1.3.4

    + More cell design
    + Fade row when stack is zero

* 1.3.3

    + More cell design
    + `SharkScope.fetch()` thread fixes
    + Added easing to `LayoutParameters`
    + Custom drawn row selection

* 1.3.2

    + Row Selection color
    + Hook up dynamic Stack Layout Properties maximum

* 1.3.1

    + Window title parsing / Table row selection tweaks

* 1.3.0

    + Cell desig for major statistics / Layout constraint cleanup

* 1.2.8 - 1.2.83

    + Added `LayoutParameters` to manage bar percentage values
    + More cell design

* 1.2.7

    + Tweaked percentage layout constraint

* 1.2.6

    + Created percentage cell design
        + Cell base class `PlayerViewModelCellView` (cleaned up cell creation call site)
        + Cell subclass for percentage display `PercentBarCellView`
        + Constraint based layout (data driven constraints can be hooked up via `@IBOutlet`) 

* 1.2.41

    + Minor fixes
        + Ante parsing
        + Turn back window drag after tourney

* 1.2.4

    + Update summary / table when blinds change
    + Update window title along table info
    + Some design (Font size / color)

* 1.2.3

    + Automatic closing of window is disabled by default (can be opted-in via configuration)   

* 1.2.2

    + Player Table retains row selection 

* 1.2.1

    + Added remaining statistics (with sorting / text field setters)

* 1.2.0

    + Sorting
        + Defined in Interface Builder for actual Table Column
            + Key only used for identification (not actual keypath of anything)
            + Actual comparison behaviour is implemented right on `PlayerViewModel.isInIncreasingOrder` (naming will change probably)
            + Sort after process any new data / also when clicked
        + Implemented for `Stack`, `VPIP`, `PFR` and `Tables`
    + Added a test suite target (only for some sorting prototype work for now)

* 1.0.1

    + Added more SharkScope statistics

* 1.0.0

    + Fixed Player model collection updating
        + Create new models for each hand
        + Preserve SharkScope data if any

* 0.9.9

    + `PlayerViewModel`
        + Moved SharkScope queries into 
        + Create column data on the fly (see `textFieldDataForColumnIdentifiers`)
        + Created boxed value holders for text fields (see `TextFieldData`)      
    
* 0.9.81

    + Rename `TourneyTablePlayer` to `LatestHandPlayers` (or `LatestTourneyHandPlayers`)
    
* 0.9.8

    + Refactored / cleaned up view models to use `TourneyTablePlayer` only
    + Update stats / stack when new hand available for tourney

* 0.9.6

    + Added `App.Configuration`
        + Live table tracking can be simulated
            + Using real (past) PokerTracker data
            + Queries / models works entirely the same 
            + See `App.Configuration` docs for more

* 0.9.5

    + Created `TourneyTablePlayer` entity / query
        + Fetches latest hand info for a given tourney number
        + More robust substitute for `LiveTourneyTable`

* 0.9.2

    + Screen Recording permission
    + Table tracking
        + Instantiate new window every time
        + Data bindings
    
* 0.9.0

    + Refactorings
        + `App`
        + `TablesStatusBarItem`
        + Table tracking extracted to `TableTracker` 
    + Table name parsing (see `TableWindowInfo`)

* 0.8.6

    + SharkScope table
        + Added more statistics
        + Number formatting is done in interface builder

* 0.8.5

    + Indicate opted-out statistics on UI
    + Table selection now reset player collection
    + Minor refactors

* 0.8.4

    + Created `PlayerViewModel` for `ViewModel` (factored every data into)
    + SharkScope models are `Equatable` as well (for detecting changes later)

* 0.8.2

    + Created SharkScope table prototypes

* 0.8.1

    + Added table count query flow prototype

* 0.8.0

    + Implemented `ApiError` modeling SharkScope API errors / added to `SharkScope.fetch()`

* 0.7.8

    + Preserve `Request.parameters` order (using `KeyValuePairs`)

* 0.7.7

    + Fixed `?` issue in cache filenames 
    + Implement `Decodable.init` for `ActiveTournaments`
        + When no tables playing (key missing)
        + When one table playing (key contains dictionary)

* 0.7.6

    + Resolve cache filenames with URL paramenters
    	+ Can cache `activeTournaments.json` like `activeTournaments?network1=PokerStars&player1=Taren%20Tano.json`

* 0.7.5

    + Refactored `SharkScope.fetch(player:)` response.
    + `Statistics` can be decoded nicely with unauthorized statistics as well 
    + Narrowed down `Tournament` implementation (easy fix to deal with optional values)
    
* 0.7.3

    + Minor UI tweaks
    + Created `SharkScope.fetch(player:)`

* 0.7.2

    + Implemented `ActiveTournaments` query
    + Implemented `Error` response type

* 0.7.1

    + Added more custom computed statistics

* 0.7.0

    + Gently modeled `PlayerSummary.Response.PlayerResponse.PlayerView.Player.Statistics`
    + Created key index for statistics (see `Statistics.init(from:)`)
        + Added `Accessors` extension (see tests)
        + Added (some) custom computed statistics 

* 0.6.0

    + A lot
    + SharkScope Model improvements
        + Added `StringRepresentable` and `StringRepresenting`
            + Can decode string-wrapped JSON values while preserving auto-Codable (!!!)
        + Added Generic Protocols for Response
            + `RootResponse`, `Response`, `UserInfo`
        + New models (`PlayerSummary`, `Timeline`, `Metadata`)
        + Requests
            + Added `useCache` property
                + Can opt-out using `withoutCache()`
                
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

