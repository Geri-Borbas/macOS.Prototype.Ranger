# Changelog

* Doing

    + Next up
        + Start getting `ActiveTournaments` data
            + Setup basic database for players   
        + Switch to session statistics
        + Show my statistics filtered for player         
        + Get `CompletedTournaments` with limits
            + Implement latest date of completed tournaments
        + UI for Opted-Out SharkScope players
        + Aggregate `Tournaments` sessions / calculate session stats
        
    + Features
        + Final table positions column
        + Game distribution in time Graph (scatter)
        + Cursor for Finishes (get live tourney data)
        + Get player stats for hero filtered for villain (clickable)
        + SharkScope
            + Filters
                + Last one year
                + Only sit and gos
                + Only this type of tourney (entrants, stake)
            + Profit graph (?)
        + Normalized / Absolute switch for Finishes histogram
        + `TableWindowInfo`
            + Regex title recognition (with tests)

* 2.3.1

    + Added `DetailedStatistics.Statistic._3Bet`, `foldTo3Bet`  

* 2.3.0

    + `DetailedStatistics.Statistic`
        + Created `.Aligned` accessors (to align corresponding statistics)
        + Added steal statistics
        + Added right-click context menu to `SeatViewOverlay` to preview detailed statistics

* 2.2.31

    + Wrapped statistics into `Statistic` struct (to have count / opportunities information in place)

* 2.2.3

    + Changed statistics (`VPIP`/`PFR`) to be in line with PokerTracker statistics definitions (100 multiplier)
        + Updated each corresponding `NumberFormatter` / `PercentProvider` / `ColorRanges`
    + Added documentation to calculations

* 2.2.1

    + `PlayersTableView` click callback
    + Created `PokerTracker.DetailedStatistics`
        + Replaced statistics in `Model.Player`

* 2.2.0

    + Merged `Feature/UI/Table_Overlay`
    + Minor String extension fix

* Feature/UI/Table_Overlay/0.5.5

    `SeatViewOverlay`
        + Clamp width constraints
        + Removed remaining hand counter (deal)
    + Window layering
        + Refactored window info change tracking (to manual)
        + Resume `.normal` window levels when tables are not active
    + Some convinient String extension

* Feature/UI/Table_Overlay/0.5.2

    + Added `Gray` color range assets
    + `Ranger` can be opted out easily in table tracker
    + More `SeatViewController` UI tweaks

* Feature/UI/Table_Overlay/0.5.0

    + Color range adjustments / UI refinements
    + Added `Tables.ColorRanges`

* Feature/UI/Table_Overlay/0.4.8

    + Created `Right Seat View Controller` (with mirrored assets)

* Feature/UI/Table_Overlay/0.4.7

    + Wired in `SeatViewController` data hooks

* Feature/UI/Table_Overlay/0.4.6

    + Added `ColorRanges` (M / VPIP / PFR / Stack) with `ColorRangeProvider` compatibility         

* Feature/UI/Table_Overlay/0.4.5 

    + Layout (M / wrappers / Tooltip)

* Feature/UI/Table_Overlay/0.4.4

    + Created VPIP / PFR Bar sizing (layout constraints)

* Feature/UI/Table_Overlay/0.4.3

    + Window shadow updating
    + Empty / Zero states for `SeatViewController`

* Feature/UI/Table_Overlay/0.4.2

    + Created `NSTextField.fontSize` extension
    + Implemented font scaling in `SeatView`

* Feature/UI/Table_Overlay/0.4.0

    + `SeatViewController` size layout
        + Countless trial and error with layout constraints
        + Container views / `SeatViewController`  use simple autoresizing rules (best fit for proportional scaling)
        + Created `SeatView` to manage layout size finetunes (corner radiuses / font sizes)
        + Extracted common outlets to `SeatViewOutles` 

* Feature/UI/Table_Overlay/0.3.7

    + Created / Added `SeatViewController` assets

* Feature/UI/Table_Overlay/0.3.6

    + Tweaked `Finished` colors
    + Added `SeatViewController.nameBox` / `SeatViewController.nameTextField` to showcase colors more 
    
* Feature/UI/Table_Overlay/0.3.5

    + `TournamentTableWindow.window` is now `NSPanel`
        + Doesn't steal focus from other processes using `.nonactivatingPanel`

* Feature/UI/Table_Overlay/0.3.4

    + `SeatViewController` color codes rings by `Finishes`
    + Fixed SharkScope data flow into `TableOverlay`  

* Feature/UI/Table_Overlay/0.3.3

    + Created JSON / Asset based `ColorRanges`
        + Storyboard based ranges renamed to `ColorRangeProvider` (with some hardcoded compatibility)
        + Ranges now delimited with both `min` and `max` values (can provide `nil` for infinity)
        + Created ranges for `Finished` with more granular limits
        + Added `ColorRangesTests`

* Feature/UI/Table_Overlay/0.3.0

    + Created conversion to table seat (considering preferred seat)

* Feature/UI/Table_Overlay/0.2.9

    + Added player model hooks to `TableOverlayViewController`
        + `TableOverlayViewController.update(with:)`
        + `SeatViewController.update(with:)`
    + Added delegates to receive events from seats
        + `TableOverlayViewControllerDelegate` / `SeatViewControllerDelegate`
    + Some renaming

* Feature/UI/Table_Overlay/0.2.8

    + `PlayersTableViewController` is added via content view / embed segue as well
    + Removed `TournamentViewController.track()` leaving only `TournamentViewController.update()` to inject table info updates

* Feature/UI/Table_Overlay/0.2.7

    + Strong typed child view controller referencing upon `TournamentViewController` embed segues
    + Added `SeatViewController`
        + `TableOverlayViewController` embed each via storyboard segues (from two prototypes Left and Right)
        + `seat` index gets injected from `segue.identifier`
        + `side` gets injected from storyboard "User Defined Runtime Attributes"

* Feature/UI/Table_Overlay/0.2.5

    + `TableOverlayViewController` added using storyboard `ContentView`
    + Fixed up layout / resizing

* Feature/UI/Table_Overlay/0.2.1

    + `Table Overlay` view layout is aligned (per pixel level)

* Feature/UI/Table_Overlay/0.2.0

    + Refactored `TournamentWindowController` layout / hieararchy
        + A borderless / floating window above the entire table window
        + Created seat assets for layout (and some basic template)
        + Tracking Observed Table windows as well

* Feature/UI/Table_Overlay/0.0.1

    + Created design files
    + Added layout assets yet to `SimulatedTable`    
    
* 2.0.1

    + Moved `Tournaments` statistics to `RangerTests.TournamentsTests`

* 2.0.0

    + Added Local time to country flag tooltip
        + Created `Countries` (tool for estimate local time for country)
        + Covered `Countries` with tests

* 2.0.0

    + Added `Country Flags` to asset catalog
    + Minor layout tweaks

* 1.9.9

    + Added `PlayerNameCellView` with nationality (flag icon)
    + Columns ordering tweaks

* 1.9.8

    + Added `Model.Players.load()` to load player lists from `plist` 
    + Added some basic `Tournaments` calculations.
    + SharkScope status in `PlayersViewController`

* 1.9.6

    + Created `SharkScope.User` request
    + Fetch Shark Scope status afterΩ requests (explicitly in `TournamentViewController`)

* 1.9.5

    + `TableTracker` sends update on window order change as well 

* 1.9.4

    + Added `tourney_no` check to  `PokerTracker.StatisticsQuery.sql` 

* 1.9.3
    
    + Updated  `PokerTracker.StatisticsQuery.sql`

* 1.9.2

    + `PokerTracker.Service` became a singleton
        + Maintains a single connection to the database
        + Global access
        + Close connection on quit

* Feature/UI/Window_Tracking/0.1.1

    + `TableTracker` only delegates updates when window is changed (either `name` or `bounds)

* Feature/UI/Window_Tracking/0.1.0

    + `TableTracker` now maintains a collection of tracked tables
        + Uses collection diffing to report changes (collection order is independent from window layering)
        + `TableWindowInfo.Equatable` uses `tournamentNumber` only (!) to consider change
    + Multi-tabling works nicely (with simulated tables)

* Feature/UI/Window_Tracking/0.0.8

    + Simulated Table resizing

* Feature/UI/Window_Tracking/0.0.7

    + `TableSimulator` uses actual PokerTracker tournament histories
        + Added `PokerTracked.TourneyHandSummary` (list every hand for a tournament number)
        + `TableSimulator.Configuration`
            + Simply uses a tournament `number` and a playback speed (`handInterval`)
            + Added more `Tourney` from database
        + `TableSimulator` track active simulated windows
            + Prevents opening duplicate tournaments
            + `TournamentViewModel` can ask for `handOffset` if any
        + `SimulatedTableViewController` gets blind levels from actual PokerTracker hands

* Feature/UI/Window_Tracking/0.0.5

    + Removed simulation related things from `App.Configuration`
    + Added blind level string to `TableSimulator.Configuration`
    + `TableTracker` tracks `Ranger` windows as well
    + `SimulatedTableViewController` now ticks

* Feature/UI/Window_Tracking/0.0.4

    + Added `TableSimulator`
        + Simple window simulating PokerStars table window titles
        + Suitable to test `TableTracker`
    
* Feature/UI/Window_Tracking/0.0.2

    + Added application menu items
        + Windows gets added to window menu
        + `StatusBarItem` is deprecated

* 1.9.1

    + Added `Cache` column to see if there is cache available any

* 1.9.0

    + Every `Model.Player` use a single shared (static) `PokerTracker.Service()` (no connection overload)
    
* Feature/Data/SharkScope/Tournaments/0.2.7

    + `SharkScope.Service.fetch`
        + Cache request before decode (`ApiResponse.stringRepresentation` is static)
        + Fixed "Accept" header (strict `application/json` for JSON requests)
        

* Feature/Data/SharkScope/Tournaments/0.2.6

    + Added `SharkScope.Configuration.StatisticsPassword` (for `/poker-statistics/` requests)
    + Fixed `Tournaments` path (added extension)
    + Some calculation prototype from `Tournaments` data

* Feature/Data/SharkScope/Tournaments/0.2.5

    + Hooked up `TournamentsQuery` to UI / fixed cache file name

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

