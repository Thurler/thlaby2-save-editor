from PySide6 import QtCore, QtWidgets, QtGui

def convert2Bytes(data, little=True):
  raw = iter(data)
  if little:
    return [x + 256*next(raw) for x in raw]
  else:
    return [256*x + next(raw) for x in raw]

def convertTo2Bytes(data, little=True):
  result = []
  for d in data:
    if little:
      result += [d%256, d//256]
    else:
      result += [d//256, d%256]
  return result

def askForDir():
  dialog = QtWidgets.QFileDialog()
  dialog.setFileMode(QtWidgets.QFileDialog.Directory)
  dialog.setOption(QtWidgets.QFileDialog.ShowDirsOnly, True)
  dialog.exec()
  return dialog.directory().absolutePath()

def askForDatFile(exists=True):
  dialog = QtWidgets.QFileDialog()
  if (exists):
    dialog.setFileMode(QtWidgets.QFileDialog.ExistingFile)
  else:
    dialog.setFileMode(QtWidgets.QFileDialog.AnyFile)
  dialog.setNameFilters(["Steam save files (*.dat)"])
  dialog.exec()
  files = dialog.selectedFiles()
  if (len(files) > 0):
    return files[0]
  else:
    return ""

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
