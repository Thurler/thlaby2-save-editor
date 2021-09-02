from PySide6 import QtCore, QtWidgets, QtGui

def convert2Bytes(data, little=True):
  raw = iter(data)
  if little:
    return [x + 256*next(raw) for x in raw]
  else:
    return [256*x + next(raw) for x in raw]

def askForDir():
  dialog = QtWidgets.QFileDialog()
  dialog.setFileMode(QtWidgets.QFileDialog.Directory)
  dialog.setOption(QtWidgets.QFileDialog.ShowDirsOnly, True)
  dialog.exec()
  return dialog.directory().absolutePath()

def askForDatFile():
  dialog = QtWidgets.QFileDialog()
  dialog.setFileMode(QtWidgets.QFileDialog.ExistingFile)
  dialog.setNameFilters(["Steam save files (*.dat)"])
  dialog.exec()
  return dialog.selectedFiles()[0]

def imgWidget(filename, height):
  image = QtGui.QPixmap("img/" + filename)
  label = QtWidgets.QLabel()
  label.setPixmap(image.scaledToHeight(height))
  label.setAlignment(QtCore.Qt.AlignCenter)
  return label

def iconWidget(filename):
  image = QtGui.QPixmap("img/" + filename)
  return QtGui.QIcon(image)

def textWidget(text, pt, bold):
  label = QtWidgets.QLabel()
  label.setText(text)
  label.setAlignment(QtCore.Qt.AlignCenter)
  font = label.font()
  font.setPointSize(pt)
  font.setBold(bold)
  label.setFont(font)
  return label

def buttonWidget(text, func, pt=0):
  button = QtWidgets.QPushButton(text)
  button.setDefault(True)
  button.clicked.connect(func)
  if (pt > 0):
    font = button.font()
    font.setPointSize(pt)
    button.setFont(font)
  return button

class IconButton(QtWidgets.QWidget):
  def __init__(self, left, text, filename, height, func, pt=0):
    super().__init__()
    layout = QtWidgets.QGridLayout()

    self.icon = imgWidget(filename, height)
    self.button = buttonWidget(text, func, pt)

    if (left):
      layout.addWidget(self.icon, 0, 0, 1, 1)
      layout.addWidget(self.button, 0, 1, 1, 2)
    else:
      layout.addWidget(self.button, 0, 0, 1, 2)
      layout.addWidget(self.icon, 0, 2, 1, 1)

    for i in range(1):
      layout.setRowStretch(i, 1)
    for i in range(3):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
