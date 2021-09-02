from buttonerror import ButtonError
from fileform import FileForm

from common import *

class ButtonGrid(QtWidgets.QWidget):
  def __init__(self, changeCallback):
    super().__init__()
    self.changeCallback = changeCallback
    layout = QtWidgets.QGridLayout()

    self.character = IconButton(
      True, "Character Stats", "chara.png", 50, None, 16
    )
    self.inventory = IconButton(
      False, "Inventory Info", "inventory.png", 50, None, 16
    )
    self.achievement = IconButton(
      True, "Achievement Info", "achievement.png", 50, None, 16
    )
    self.map = IconButton(
      False, "Map Progress", "map.png", 50, None, 16
    )
    self.party = IconButton(
      True, "Party Info", "party.png", 50, None, 16
    )
    self.bestiary = IconButton(
      False, "Bestiary Info", "bestiary.png", 50, None, 16
    )
    self.general = IconButton(
      True, "General Info", "general.png", 50, None, 16
    )
    self.eventFlags = IconButton(
      False, "Event Flags", "event.png", 50, None, 16
    )

    self.character.setEnabled(False)
    self.inventory.setEnabled(False)
    self.achievement.setEnabled(False)
    self.map.setEnabled(False)
    self.party.setEnabled(False)
    self.bestiary.setEnabled(False)
    self.general.setEnabled(False)
    self.eventFlags.setEnabled(False)

    layout.addWidget(self.character, 0, 1, 1, 5)
    layout.addWidget(self.inventory, 0, 7, 1, 5)
    layout.addWidget(self.achievement, 1, 1, 1, 5)
    layout.addWidget(self.map, 1, 7, 1, 5)
    layout.addWidget(self.party, 2, 1, 1, 5)
    layout.addWidget(self.bestiary, 2, 7, 1, 5)
    layout.addWidget(self.general, 3, 1, 1, 5)
    layout.addWidget(self.eventFlags, 3, 7, 1, 5)

    for i in range(4):
      layout.setRowStretch(i, 1)
    for i in range(13):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)

class MainMenu(QtWidgets.QWidget):
  def updateSave(self, save):
    self.save = save
    self.path.setText("Loaded Save: "+save.path)

  def __init__(self, save, changeCallback):
    super().__init__()
    self.save = save
    self.changeCallback = changeCallback
    layout = QtWidgets.QGridLayout()

    cback = lambda: self.changeCallback("back")

    self.path = textWidget("Loaded Save: "+save.path, 12, False)
    self.back = buttonWidget("Back to File Select", cback, 12)
    self.options = ButtonGrid(self.changeCallback)
    self.exportLegacy = buttonWidget("Export as Legacy Files", None, 12)
    self.exportSteam = buttonWidget("Export as Steam File", None, 12)

    self.exportLegacy.setEnabled(False)
    self.exportSteam.setEnabled(False)

    layout.addWidget(self.path, 0, 0, 1, 13)
    layout.addWidget(self.options, 1, 0, 12, 13)
    layout.addWidget(self.back, 13, 1, 1, 3)
    layout.addWidget(self.exportLegacy, 13, 5, 1, 3)
    layout.addWidget(self.exportSteam, 13, 9, 1, 3)

    for i in range(15):
      layout.setRowStretch(i, 1)
    for i in range(13):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
