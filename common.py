from PySide6 import QtCore, QtWidgets, QtGui

def askForDir():
  dialog = QtWidgets.QFileDialog()
  dialog.setFileMode(QtWidgets.QFileDialog.Directory)
  dialog.setOption(QtWidgets.QFileDialog.ShowDirsOnly, True)
  dialog.exec()
  return dialog.directory().absolutePath()

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
