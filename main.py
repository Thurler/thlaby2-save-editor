from PySide6 import QtWidgets

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

  def mainMenuChange(self, target):
    if (target == "back"):
      self.loadSelectScreen()
    elif (target == "exLegacy"):
      target = askForDir()
      self.save.exportLegacy(target)
    elif (target == "exSteam"):
      target = askForDatFile(False)
      if (target != ""):
        self.save.exportSteam(target)
        self.mainMenu.exportSteam.setError("Export success!")

  def loadSelectScreen(self):
    if (self.fileSelect is not None):
      self.layout.setCurrentIndex(0)
      return
    self.fileSelect = FileSelect(self.loadLegacySave, self.loadSteamSave)
    self.layout.addWidget(self.fileSelect)

  def loadMainMenu(self):
    if (self.mainMenu is not None):
      self.layout.setCurrentIndex(1)
      self.mainMenu.updateSave(self.save)
      return
    self.mainMenu = MainMenu(self.save, self.mainMenuChange)
    self.layout.addWidget(self.mainMenu)
    self.layout.setCurrentIndex(1)

  def __init__(self):
    super().__init__()
    self.setFixedSize(960, 540)
    self.layout = QtWidgets.QStackedLayout()

    self.fileSelect = None
    self.mainMenu = None

    self.loadSelectScreen()
    self.setLayout(self.layout)

if __name__ == "__main__":
  app = QtWidgets.QApplication([])
  widget = MainWidget()
  widget.show()
  sys.exit(app.exec_())
