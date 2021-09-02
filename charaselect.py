from common import *

class CharacterSelect(SaveWidget):
  def __init__(self, save, changeCallback):
    super().__init__(save)
    self.changeCallback = changeCallback
    layout = QtWidgets.QGridLayout()

    cback = lambda: self.changeCallback("main")

    self.title = textWidget("Select Character", 22, True)
    self.characters = []
    self.callbacks = []
    for i in range(56):
      ccback = lambda x=False, c=str(i): self.changeCallback("character-"+c)
      self.characters += [
        imgButtonWidget(
          "character/" + characterFilenames[i] + "_SS.png", ccback
        )
      ]
    self.back = buttonWidget("Back to Main Menu", cback, 12)

    layout.addWidget(self.title, 0, 0, 1, 17)
    for i in range(56):
      if (self.save.charsUnlock[i] == 0):
        self.characters[i].setEnabled(False)
      layout.addWidget(self.characters[i], 1 + (i//4), 1 + (4*(i%4)), 1, 1)
    layout.addWidget(self.back, 15, 5, 1, 7)

    for i in range(16):
      layout.setRowStretch(i, 1)
    for i in range(17):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
