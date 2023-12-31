
# Touhou Labyrinth 2 Save Editor

This repository provides a save editor for Touhou Labyrinth 2, capable of editing many of the event flags and character stats in your save file, among other things. Unlike editing a raw hex file, which would require computing the correct offsets and hexadecimal convertions, this program aims to provide an intuitive interface for each piece of data in the save file:

TODO: Insert some pictures here?

So far it is only compatible with the Steam save format. You can use [this tool](https://github.com/Thurler/thlaby2-save-convert) to convert your DLsite save into a Steam save. Free conversion between the formats is a planned feature for this software, check the Roadmap section below.

## Supported Platforms

Windows and Linux binaries are provided in the [Releases page](https://github.com/Thurler/thlaby2-save-editor/releases) page, and should work out of the box. A Mac build is not provided since I do not own a Mac, and have no idea how to build and test a release without one. Please follow the [Flutter install instructions](https://docs.flutter.dev/get-started/install) if you are using a Mac or want to compile the software yourself.

## Features and Roadmap

- Current release (0.4.0)
  - Edit character parameters
    - Level, EXP, BP, Subclass
    - Library points
    - Level bonuses
    - Skill points and levels
    - Tome and Gem investments
  - Edit which characters are in the party
  - Edit character unlock flags
  - Edit inventory unlock flags and amount
  - Steam format compatibility
  - Logging for debugging purposes
- Version 0.5.0
  - Edit character equipment 
- Version 0.6.0
  - Edit achievement data
- Version 0.7.0
  - Edit general data (money amount, play time, IC floor, FOE kills, etc)
- Version 0.8.0
  - Edit map data
- Version 0.9.0
  - Edit bestiary data
- Version 0.10.0
  - Edit event flags (dungeon events, story events, etc)
- Version 1.0.0
  - DLSite format compatibility
- Version 1.1.0
  - Multi-language support
- Not planned
  - MacOS support
  - Japanese translation
  - Chinese translation
  - Add more in-game validation checks
    - Changing library points changes current money
    - Changing training manuals / tomes / gems changes current item amounts
    - Changing equipment changes current item amounts

## Contributing

If you have found a problem with the software, please open an issue and describe the problem - give as much information as you can so I can reliably replicate the problem! That might include sharing log files or the save file being used when the problem happened.

If you would like to contribute to the code base, feel free to open a Pull Request with your proposed changes and ask for a review. The code is formatted using [this tool](https://github.com/Thurler/dart_style) instead of Dart's standard one, since it more closely matches my subjective takes on formatting. This project is still stuck on Flutter version 3.7.12, for the time being.

## Disclaimers

This software is a hobby project. The author provides this software with no warranty whatsoever. Always be careful when editing save files that are precious to you. ALWAYS BACKUP YOUR FILES BEFORE EDITING THEM!
