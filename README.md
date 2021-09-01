# Touhou Labyrinth 2 Save Editor

This repository provides a save editor for Touhou Labyrinth 2, capable of editing many of the event flags and character stats in your save file, among other things. Unlike editing a raw hex file, which would require computing the correct offsets and hexadecimal convertions, this program aims to provide an intuitive interface for each piece of data in the save file:

TODO: Insert some pictures here?

The editor is compatible with both the legacy save format from the Comiket version, available through DLSite, and with the Steam save format version. You can also choose which format to export your edited save to, so this tool also works as a converter between formats. *Keep in mind dungeon map progress cannot be carried over between format changes!*

![](img/demo2.png)

## Build Instructions

The application was developed in Python, using Qt for the GUI. You can either download these tools for your PC or download the 7zip file provided in the Releases tab. The zip file is 100MB after extracted, since it is just a packed installation of these tools, and is only provided for convenience. Installing and running Python is the ideal option, and is easy even in Windows:

* Head over to https://www.python.org/downloads/ and download Python 3.9 (or any 3.x release)
* Make sure you install the "pip" module when installing Python
* Make sure you also click the option to add Python to your system's PATH
* Optionally, install the "py launcher" module to easily run python scripts
* Open a CMD and type in "pip install pyside6"
  * You can open a CMD by pressing the windows key then typing "cmd"
* Download this repository's source code through Github
* If you installed the py launcher, simply double click "main.py"
  * You can also open a CMD and type "python main.py" from the directory you downloaded to

If you're running Linux, please refer to your distribution's Python and Qt installation instructions. Chances are you already have Python and pip installed by default!