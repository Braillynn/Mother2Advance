

# Mother 2 Advance
This is a work-in-progress Engish translation patch for Mother 2 on the Gameboy Advance that utilizes the Maternal Bound Redux script and jeffman's variable-width-font codebase. This project builds off of the ground work from the Mother 1 + 2 Fan Translation(in progress) but omits elements related to Earthbound.

## Resources
https://github.com/ShadowOne333/MaternalBound-Redux and https://github.com/jeffman/Mother2GbaTranslation


# Testing

## Dependencies
- [mGBA 0.9.3 or later, or nightly built after Nov 29, 2021](https://mgba.io/downloads.html)
- [Building dependencies](#Building)

1. One-time setup
    1. Install .NET Core 2.1, PowerShell Core, and GNU Arm Embedded Toolchain. Make sure the Arm toolchain's `bin` folder is in your `PATH`.
    2. Create a `bin` folder in the root of the repo.
    3. Copy MOTHER 1+2 ROM to `bin/m12fresh.gba`.
    4. Copy EarthBound ROM to `bin/eb.smc`.
    5. Run `build-tools.ps1`.
        - Windows: `.\build-tools.ps1` in a PowerShell prompt
        - Linux and MacOS: `pwsh build-tools.ps1`
    6. Copy/build `armips` to `bin`.
        - Windows: grab the latest release [here](https://github.com/Kingcom/armips/releases) and copy the executable to `bin/armips.exe`.
        - Linux: follow the [README](https://github.com/Kingcom/armips/blob/master/Readme.md) to build `armips` and copy the executable to `bin/armips`.
        - MacOS: grab the latest release [here](https://github.com/Emory-M/armips/releases) and copy the executable to `bin/armips`.
    7. Copy/build `mgba-sdl` to `bin`.
        - You can also use mgba-QT (which is normally named mgba), but you will need to change the name of the executed program in `test.ps1`.
2. Running the tests
    1. Run `test.ps1`.
    2. The default compiled ROM is copied to `bin/m12test.gba`.
    3. The tests' log will be in `bin/test.log`.
    4. The output will also be visible in the console.
