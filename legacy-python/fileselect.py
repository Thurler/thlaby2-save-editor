from buttonerror import ButtonError
from fileform import FileForm

from common import *

class FileSelect(QtWidgets.QWidget):
  def changedDirectory(self, target):
    self.target = target
    if (target == "legacy"):
      self.steamFile.cleanChosen()
    elif (target == "steam"):
      self.legacyFile.cleanChosen()
    self.start.setEnabled(True)
    self.start.setError("")

  def loadSaveFile(self):
    try:
      if (self.target == "legacy"):
        self.legacyFunc(self.legacyFile.chosenFull)
      elif (self.target == "steam"):
        self.steamFunc(self.steamFile.chosenFull)
    except Exception as e:
      print(e)
      self.start.setError("Error loading save. Did you pick a valid save file?")

  def __init__(self, legacyCallback, steamCallback):
    super().__init__()
    self.legacyFunc = legacyCallback
    self.steamFunc = steamCallback
    layout = QtWidgets.QGridLayout()

    lf = lambda: self.changedDirectory("legacy")
    ls = lambda: self.changedDirectory("steam")

    self.title = imgWidget("title.png", 240)
    self.version = textWidget("Save Editor v0.0.1", 14, True)
    self.legacyFile = FileForm(
      "Use Legacy Save Format", "Choose directory", True, lf
    )
    self.steamFile = FileForm(
      "Use Steam Save Format", "Choose file", False, ls
    )
    self.start = ButtonError("Load Save File", self.loadSaveFile, 14, False)

    self.legacyFile.setEnabled(False)

    layout.addWidget(self.title, 0, 0, 8, 11)
    layout.addWidget(self.version, 8, 0, 1, 11)
    layout.addWidget(self.legacyFile, 9, 1, 3, 4)
    layout.addWidget(self.steamFile, 9, 6, 3, 4)
    layout.addWidget(self.start, 12, 3, 2, 5)

    for i in range(14):
      layout.setRowStretch(i, 1)
    for i in range(11):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
