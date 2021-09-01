from PySide6 import QtWidgets

from fileselect import FileSelect

import sys

class MainWidget(QtWidgets.QWidget):
  def loadLegacySave(self, path):
    print(path)
    raise Exception()

  def loadSteamSave(self, path):
    print(path)
    raise Exception()

  def loadSelectScreen(self):
    self.fileSelect = FileSelect(self.loadLegacySave, self.loadSteamSave)
    self.layout.addWidget(self.fileSelect)

  def __init__(self):
    super().__init__()
    self.setFixedSize(960, 540)
    self.layout = QtWidgets.QStackedLayout()

    self.fileSelect = None
    self.loadSelectScreen()

    self.setLayout(self.layout)

if __name__ == "__main__":
  app = QtWidgets.QApplication([])
  widget = MainWidget()
  widget.show()
  sys.exit(app.exec_())
