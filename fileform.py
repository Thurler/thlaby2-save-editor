from PySide6 import QtWidgets

from common import *

class FileForm(QtWidgets.QWidget):
  def cleanChosen(self):
    self.chosenFull = ""
    self.chosen.setText("")

  def updateChosen(self):
    self.chosenFull = askForDir()
    # Show only last 39 characters if more than 42 characters
    if (len(self.chosenFull) > 42):
      self.chosen.setText("..." + self.chosenFull[-39:])
    else:
      self.chosen.setText(self.chosenFull)
    if (self.changeCallback is not None):
      self.changeCallback()

  def __init__(self, headerText, buttonText, changeCallback=None):
    super().__init__()
    self.changeCallback = changeCallback
    layout = QtWidgets.QGridLayout()
    
    self.title = textWidget(headerText, 16, True)
    self.button = buttonWidget(buttonText, self.updateChosen, 14)
    self.chosen = textWidget("", 12, False)

    layout.addWidget(self.title, 0, 0)
    layout.addWidget(self.button, 1, 0)
    layout.addWidget(self.chosen, 2, 0)

    for i in range(3):
      layout.setRowStretch(i, 1)
    for i in range(1):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
