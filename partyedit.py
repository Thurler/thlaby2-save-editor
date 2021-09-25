from common import *
from functools import reduce

import copy

class PartyEdit(EditWidget):
  def revert(self):
    super().revert()
    self.save.party = copy.deepcopy(self.revertParty)
    for index, i in enumerate([8, 9, 10, 11, 4, 5, 6, 7, 0, 1, 2, 3]):
      button = self.characters[index]
      charId = self.save.party[i] - 1
      if (charId == -1):
        filename = "character/Empty_S.png"
      else:
        filename = "character/" + characterFilenames[charId] + "_S.png"
      icon, size = iconWidget(filename)
      button.setIcon(icon)
      button.setIconSize(size)

  def commit(self):
    super().commit()
    self.revertParty = copy.deepcopy(self.save.party)

  def hasChanges(self):
    return 12 != sum(
      [a == b for a, b in zip(self.save.party, self.revertParty)]
    )

  def checkChangesToBack(self):
    self.save.party = copy.deepcopy(self.revertParty)
    if (super().checkChangesToBack()):
      self.changeCallback("main")

  def changeToRecruit(self):
    self.save.party = copy.deepcopy(self.revertParty)
    if (super().checkChangesToBack()):
      self.changeCallback("recruit")

  def updateSave(self, save):
    super().updateSave(save)
    self.commit()
    self.revert()

  def __init__(self, save, changeCallback):
    super().__init__(save)
    self.revertParty = copy.deepcopy(self.save.party)
    self.changeCallback = changeCallback
    layout = QtWidgets.QGridLayout()

    self.title = textWidget("Edit the Party", 22, True)
    self.recruit = buttonWidget(
      "Edit Recruitment Flags", self.changeToRecruit, 18
    )
    self.characters = []
    for i in [8, 9, 10, 11, 4, 5, 6, 7, 0, 1, 2, 3]:
      charId = self.save.party[i] - 1
      ccback = lambda x=False, c=str(i): self.changeCallback("party-"+c)
      if (charId == -1):
        self.characters += [imgButtonWidget("character/Empty_S.png", ccback)]
      else:
        self.characters += [
          imgButtonWidget(
            "character/" + characterFilenames[charId] + "_S.png", ccback
          )
        ]
    self.back = buttonWidget("Back to Main Menu", self.checkChangesToBack, 12)

    layout.addWidget(self.title, 1, 1, 1, 7)
    layout.addWidget(self.recruit, 1, 9, 1, 7)
    for i in range(12):
      layout.addWidget(self.characters[i], 3 + 2*(i//4), 1 + (4*(i%4)), 2, 3)
    layout.addWidget(self.back, 10, 1, 1, 4)
    layout.addWidget(self.commitButton, 10, 6, 1, 5)
    layout.addWidget(self.revertButton, 10, 12, 1, 4)
    layout.addWidget(self.error, 11, 0, 1, 17)

    for i in range(12):
      layout.setRowStretch(i, 1)
    for i in range(17):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
