from common import *
from functools import reduce

import copy

class PartyEdit(EditWidget):
  slotOrder = [8, 9, 10, 11, 4, 5, 6, 7, 0, 1, 2, 3]

  def revert(self):
    super().revert()
    self.save.party = copy.deepcopy(self.revertParty)
    for index, i in enumerate(self.slotOrder):
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
    if (sum(self.save.party[:4]) == 0):
      self.error.setText("WARNING! The front row cannot be empty")
      return
    super().commit()
    self.revertParty = copy.deepcopy(self.save.party)

  def hasChanges(self):
    return 12 != sum(
      [a == b for a, b in zip(self.save.party, self.revertParty)]
    )

  def checkChangesToBack(self):
    if (super().checkChangesToBack()):
      self.save.party = copy.deepcopy(self.revertParty)
      self.changeCallback("main")

  def changeToRecruit(self):
    if (super().checkChangesToBack()):
      self.save.party = copy.deepcopy(self.revertParty)
      self.changeCallback("recruit")

  def changeSlot(self, slot, character):
    character = 0 if character == 99 else character+1
    self.save.party[slot] = character
    index = self.slotOrder.index(slot)
    button = self.characters[index]
    if (character == 0):
      filename = "character/Empty_S.png"
    else:
      filename = "character/" + characterFilenames[character-1] + "_S.png"
    icon, size = iconWidget(filename)
    button.setIcon(icon)
    button.setIconSize(size)
    self.error.setText("")
    self.checkChanges()

  def checkValidSwap(self, slot):
    totalChars = sum(self.save.charsUnlock)
    partyChars = sum([1 if x > 0 else 0 for x in self.save.party])
    reserve = totalChars - partyChars
    if (self.save.party[int(slot)] == 0 and reserve == 0):
      self.error.setText("WARNING! There are no reserve characters")
    else:
      self.changeCallback("party-"+slot)

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
    for i in self.slotOrder:
      charId = self.save.party[i] - 1
      ccback = lambda x=False, c=str(i): self.checkValidSwap(c)
      if (charId == -1):
        self.characters += [imgButtonWidget("character/Empty_S.png", ccback)]
      else:
        self.characters += [
          imgButtonWidget(
            "character/" + characterFilenames[charId] + "_S.png", ccback
          )
        ]
    self.back = buttonWidget("Back to Main Menu", self.checkChangesToBack, 12)

    layout.addWidget(self.title, 1, 1, 1, 6)
    layout.addWidget(self.recruit, 1, 7, 1, 6)
    for i in range(12):
      layout.addWidget(self.characters[i], 3 + 2*(i//4), 1 + (3*(i%4)), 2, 3)
    layout.addWidget(self.back, 10, 1, 1, 3)
    layout.addWidget(self.commitButton, 10, 5, 1, 4)
    layout.addWidget(self.revertButton, 10, 10, 1, 3)
    layout.addWidget(self.error, 11, 0, 1, 14)

    for i in range(12):
      layout.setRowStretch(i, 1)
    for i in range(14):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
