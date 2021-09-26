from common import *

import copy

class CharacterUnlock(EditWidget):
  def revert(self):
    super().revert()
    self.save.charsUnlock = copy.deepcopy(self.revertUnlock)
    for i in range(56):
      filename = "character/" + characterFilenames[i] + "_SS.png"
      icon, size = iconWidget(filename, self.save.charsUnlock[i]==0)
      button = self.characters[i]
      button.setIcon(icon)
      button.setIconSize(size)

  def commit(self):
    super().commit()
    self.revertUnlock = copy.deepcopy(self.save.charsUnlock)

  def hasChanges(self):
    return 56 != sum(
      [a == b for a, b in zip(self.save.charsUnlock, self.revertUnlock)]
    )

  def checkChangesToBack(self):
    if (super().checkChangesToBack()):
      self.save.charsUnlock = copy.deepcopy(self.revertUnlock)
      self.changeCallback("main")

  def changeToParty(self):
    if (super().checkChangesToBack()):
      self.save.charsUnlock = copy.deepcopy(self.revertUnlock)
      self.changeCallback("party")

  def updateSave(self, save):
    super().updateSave(save)
    self.commit()
    self.revert()

  def toggleCharacter(self, i):
    if (i < 4):
      self.error.setText("WARNING: The starting characters cannot be locked!")
      return
    if (i+1 in self.save.party):
      self.error.setText("WARNING: This character is in your party!")
      return
    self.error.setText("")
    filename = "character/" + characterFilenames[i] + "_SS.png"
    target = 1 if self.save.charsUnlock[i] == 0 else 0
    self.save.charsUnlock[i] = target
    button = self.characters[i]
    icon, size = iconWidget(filename, target==0)
    button.setIcon(icon)
    button.setIconSize(size)
    self.checkChanges()

  def __init__(self, save, changeCallback):
    super().__init__(save)
    self.revertUnlock = copy.deepcopy(self.save.charsUnlock)
    self.changeCallback = changeCallback
    layout = QtWidgets.QGridLayout()

    self.title = textWidget("Edit Recruitment Flags", 14, True)
    self.party = buttonWidget("Edit the Party", self.changeToParty, 12)
    self.characters = []
    for i in range(56):
      ccback = lambda x=False, c=i: self.toggleCharacter(c)
      self.characters += [
        imgButtonWidget(
          "character/" + characterFilenames[i] + "_SS.png",
          ccback,
          (self.save.charsUnlock[i] == 0)
        )
      ]
    self.back = buttonWidget("Back to Main Menu", self.checkChangesToBack, 12)

    layout.addWidget(self.party, 0, 2, 1, 5)
    layout.addWidget(self.title, 0, 10, 1, 5)
    for i in range(56):
      layout.addWidget(self.characters[i], 1 + (i//4), 1 + (4*(i%4)), 1, 3)
    layout.addWidget(self.back, 15, 1, 1, 4)
    layout.addWidget(self.commitButton, 15, 6, 1, 5)
    layout.addWidget(self.revertButton, 15, 12, 1, 4)
    layout.addWidget(self.error, 16, 0, 1, 17)

    for i in range(17):
      layout.setRowStretch(i, 1)
    for i in range(17):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
