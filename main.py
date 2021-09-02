from PySide6 import QtWidgets

from charaselect import CharacterSelect
from fileselect import FileSelect
from mainmenu import MainMenu
from savefile import SaveFile
from common import *

import sys
import copy

class MainWidget(QtWidgets.QWidget):
  def loadLegacySave(self, path):
    self.save = SaveFile()
    self.save.loadLegacy(path)
    self.original = copy.deepcopy(self.save)
    self.loadMainMenu()

  def loadSteamSave(self, path):
    self.save = SaveFile()
    self.save.loadSteam(path)
    self.original = copy.deepcopy(self.save)
    self.loadMainMenu()

  def changeCallback(self, target):
    target = target.split('-')
    command = target[0]
    if (command == "load"):
      self.loadSelectScreen()
    elif (command == "main"):
      self.loadMainMenu()
    elif (command == "characters"):
      self.loadCharacterSelectScreen()
    elif (command == "character"):
      print(target[1])
    elif (command == "exLegacy"):
      command = askForDir()
      self.save.exportLegacy(command)
    elif (command == "exSteam"):
      command = askForDatFile(False)
      if (command != ""):
        self.save.exportSteam(command)
        self.mainMenu.exportSteam.setError("Export success!")

  def loadSelectScreen(self):
    if (self.fileSelect is not None):
      self.layout.setCurrentWidget(self.fileSelect)
      return
    self.fileSelect = FileSelect(self.loadLegacySave, self.loadSteamSave)
    self.layout.addWidget(self.fileSelect)

  def loadMainMenu(self):
    if (self.mainMenu is not None):
      self.layout.setCurrentWidget(self.mainMenu)
      self.mainMenu.updateSave(self.save)
      return
    self.mainMenu = MainMenu(self.save, self.changeCallback)
    self.layout.addWidget(self.mainMenu)
    self.layout.setCurrentWidget(self.mainMenu)

  def loadCharacterSelectScreen(self):
    if (self.charaSelect is not None):
      self.layout.setCurrentWidget(self.charaSelect)
      self.charaSelect.updateSave(self.save)
      return
    self.charaSelect = CharacterSelect(self.save, self.changeCallback)
    self.layout.addWidget(self.charaSelect)
    self.layout.setCurrentWidget(self.charaSelect)

  def __init__(self):
    super().__init__()
    self.setFixedSize(960, 540)
    self.layout = QtWidgets.QStackedLayout()

    self.fileSelect = None
    self.mainMenu = None
    self.charaSelect = None

    self.loadSelectScreen()
    self.setLayout(self.layout)

if __name__ == "__main__":
  app = QtWidgets.QApplication([])
  widget = MainWidget()
  widget.show()
  sys.exit(app.exec_())
