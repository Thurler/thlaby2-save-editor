from PySide6 import QtWidgets

from buttonerror import ButtonError
from iconbutton import IconButton
from fileform import FileForm

from common import *

class MainMenu(SaveWidget):
  def updateSave(self, save):
    super().updateSave(save)
    self.exportLegacy.setError("")
    self.exportSteam.setError("")
    self.path.setText("Loaded Save: "+self.save.path)

  def exportFunc(self, target, widget):
    try:
      widget.setError("")
      self.changeCallback(target)
    except Exception as e:
      print(e)
      widget.setError("Error exporting data!")

  def __init__(self, save, changeCallback):
    super().__init__(save)
    self.changeCallback = changeCallback
    layout = QtWidgets.QGridLayout()

    cchar = lambda: self.changeCallback("characters")
    cinventory = lambda: self.changeCallback("inventory")
    cachievement = lambda: self.changeCallback("achievement")
    cmap = lambda: self.changeCallback("map")
    cparty = lambda: self.changeCallback("party")
    cbestiary = lambda: self.changeCallback("bestiary")
    cgeneral = lambda: self.changeCallback("general")
    ceventFlags = lambda: self.changeCallback("eventFlags")
    cback = lambda: self.changeCallback("load")
    cexLegacy = lambda: self.exportFunc("exLegacy", self.exportLegacy)
    cexSteam = lambda: self.exportFunc("exSteam", self.exportSteam)

    self.path = textWidget("Loaded Save: "+save.path, 12, False)
    self.character = IconButton(
      True, "Character Stats", "chara.png", 50, cchar, 16
    )
    self.inventory = IconButton(
      False, "Inventory Info", "inventory.png", 50, cinventory, 16
    )
    self.achievement = IconButton(
      True, "Achievement Info", "achievement.png", 50, cachievement, 16
    )
    self.map = IconButton(
      False, "Map Progress", "map.png", 50, cmap, 16
    )
    self.party = IconButton(
      True, "Party Info", "party.png", 50, cparty, 16
    )
    self.bestiary = IconButton(
      False, "Bestiary Info", "bestiary.png", 50, cbestiary, 16
    )
    self.general = IconButton(
      True, "General Info", "general.png", 50, cgeneral, 16
    )
    self.eventFlags = IconButton(
      False, "Event Flags", "event.png", 50, ceventFlags, 16
    )
    self.back = ButtonError("Back to File Select", cback, 12)
    self.exportLegacy = ButtonError("Export as Legacy Files", cexLegacy, 12)
    self.exportSteam = ButtonError("Export as Steam File", cexSteam, 12)

    self.inventory.setEnabled(False)
    self.achievement.setEnabled(False)
    self.map.setEnabled(False)
    self.party.setEnabled(False)
    self.bestiary.setEnabled(False)
    self.general.setEnabled(False)
    self.eventFlags.setEnabled(False)
    self.exportLegacy.setEnabled(False)

    layout.addWidget(self.path, 0, 0, 1, 13)
    layout.addWidget(self.character, 1, 1, 3, 5)
    layout.addWidget(self.inventory, 1, 7, 3, 5)
    layout.addWidget(self.achievement, 4, 1, 3, 5)
    layout.addWidget(self.map, 4, 7, 3, 5)
    layout.addWidget(self.party, 7, 1, 3, 5)
    layout.addWidget(self.bestiary, 7, 7, 3, 5)
    layout.addWidget(self.general, 10, 1, 3, 5)
    layout.addWidget(self.eventFlags, 10, 7, 3, 5)
    layout.addWidget(self.back, 13, 1, 1, 3)
    layout.addWidget(self.exportLegacy, 13, 5, 1, 3)
    layout.addWidget(self.exportSteam, 13, 9, 1, 3)

    for i in range(14):
      layout.setRowStretch(i, 1)
    for i in range(13):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
