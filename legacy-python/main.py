from common import *

from charaselect import CharacterSelect
from charaunlock import CharacterUnlock
from fileselect import FileSelect
from partyedit import PartyEdit
from mainmenu import MainMenu
from savefile import SaveFile

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
    arguments = target[1:]
    if (command == "load"):
      self.loadSelectScreen()
    elif (command == "main"):
      self.loadMainMenu()
    elif (command == "characters"):
      self.loadCharacterSelectScreen()
    elif (command == "party"):
      if (len(arguments) > 0):
        self.loadPartySelectScreen()
        self.partyChange = int(arguments[0])
      else:
        self.loadPartyScreen()
    elif (command == "recruit"):
      self.loadRecruitScreen()
    elif (command == "character"):
      if (self.partyChange >= 0):
        self.partyMenu.changeSlot(self.partyChange, int(arguments[0]))
        self.loadPartyScreen()
        self.partyChange = -1
      else:
        print(arguments[0])
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

  def loadPartyScreen(self):
    if (self.partyMenu is not None):
      self.layout.setCurrentWidget(self.partyMenu)
      if (self.partyChange == -1):
        self.partyMenu.updateSave(self.save)
      return
    self.partyMenu = PartyEdit(self.save, self.changeCallback)
    self.layout.addWidget(self.partyMenu)
    self.layout.setCurrentWidget(self.partyMenu)

  def loadRecruitScreen(self):
    if (self.recruitMenu is not None):
      self.layout.setCurrentWidget(self.recruitMenu)
      self.recruitMenu.updateSave(self.save)
      return
    self.recruitMenu = CharacterUnlock(self.save, self.changeCallback)
    self.layout.addWidget(self.recruitMenu)
    self.layout.setCurrentWidget(self.recruitMenu)

  def loadCharacterSelectScreen(self):
    if (self.charaSelect is not None):
      self.layout.setCurrentWidget(self.charaSelect)
      self.charaSelect.updateSave(self.save)
      return
    self.charaSelect = CharacterSelect(self.save, self.changeCallback)
    self.layout.addWidget(self.charaSelect)
    self.layout.setCurrentWidget(self.charaSelect)

  def loadPartySelectScreen(self):
    if (self.partySelect is not None):
      self.layout.setCurrentWidget(self.partySelect)
      self.partySelect.updateSave(self.save)
      return
    self.partySelect = CharacterSelect(self.save, self.changeCallback, True)
    self.layout.addWidget(self.partySelect)
    self.layout.setCurrentWidget(self.partySelect)

  def __init__(self):
    super().__init__()
    self.setFixedSize(960, 540)
    self.layout = QtWidgets.QStackedLayout()

    self.fileSelect = None
    self.mainMenu = None
    self.partyMenu = None
    self.recruitMenu = None
    self.charaSelect = None
    self.partySelect = None

    self.partyChange = -1

    self.loadSelectScreen()
    self.setLayout(self.layout)

if __name__ == "__main__":
  app = QtWidgets.QApplication([])
  widget = MainWidget()
  widget.show()
  sys.exit(app.exec_())
