from common import *

class CharacterSelect(SaveWidget):
  def updateSave(self, save):
    super().updateSave(save)
    for i in range(56):
      if (self.save.charsUnlock[i] == 0):
        self.characters[i].setEnabled(False)
      elif (self.editParty and i+1 in self.save.party):
        self.characters[i].setEnabled(False)
      else:
        self.characters[i].setEnabled(True)

  def __init__(self, save, changeCallback, editParty=False):
    super().__init__(save)
    self.changeCallback = changeCallback
    self.editParty = editParty
    layout = QtWidgets.QGridLayout()

    cback = lambda: self.changeCallback("main")
    cparty = lambda: self.changeCallback("party")
    cremove = lambda: self.changeCallback("character-99")

    self.title = textWidget("Select Character", 22, True)
    self.characters = []
    for i in range(56):
      ccback = lambda x=False, c=str(i): self.changeCallback("character-"+c)
      self.characters += [
        imgButtonWidget(
          "character/" + characterFilenames[i] + "_SS.png", ccback
        )
      ]
    if (self.editParty):
      self.back = buttonWidget("Back to Party Edit", cparty, 12)
      self.remove = buttonWidget("Remove from Party", cremove, 12)
    else:
      self.back = buttonWidget("Back to Main Menu", cback, 12)

    layout.addWidget(self.title, 0, 0, 1, 17)
    for i in range(56):
      if (self.save.charsUnlock[i] == 0):
        self.characters[i].setEnabled(False)
      if (self.editParty and i+1 in self.save.party):
        self.characters[i].setEnabled(False)
      layout.addWidget(self.characters[i], 1 + (i//4), 1 + (4*(i%4)), 1, 3)
    if (self.editParty):
      layout.addWidget(self.back, 15, 2, 1, 5)
      layout.addWidget(self.remove, 15, 10, 1, 5)
    else:
      layout.addWidget(self.back, 15, 5, 1, 7)

    for i in range(16):
      layout.setRowStretch(i, 1)
    for i in range(17):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
