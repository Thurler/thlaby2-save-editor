from common import *

class FileForm(QtWidgets.QWidget):
  def cleanChosen(self):
    self.chosenFull = ""
    self.chosen.setText("")

  def updateChosen(self):
    if (self.isFolder):
      self.chosenFull = askForDir()
    else:
      self.chosenFull = askForDatFile()
    # Show only last 39 characters if more than 42 characters
    if (len(self.chosenFull) > 42):
      self.chosen.setText("..." + self.chosenFull[-39:])
    else:
      self.chosen.setText(self.chosenFull)
    if (self.changeCallback is not None):
      self.changeCallback()

  def __init__(self, headerText, buttonText, isFolder, changeCallback=None):
    super().__init__()
    self.changeCallback = changeCallback
    self.isFolder = isFolder
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
