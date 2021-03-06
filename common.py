from PySide6 import QtCore, QtWidgets, QtGui

characterFilenames = [
  "Reimu", "Marisa", "Kourin", "Keine",
  "Momiji", "Youmu", "Kogasa", "Rumia",
  "Cirno", "Minoriko", "Komachi", "Chen",
  "Nitori", "Parsee", "Wriggle", "Kaguya",
  "Mokou", "Aya", "Mystia", "Kasen",
  "Nazrin", "Hina", "Rin", "Utsuho",
  "Satori", "Yuugi", "Meirin", "Alice",
  "Patchouli", "Eirin", "Reisen", "Sanae",
  "Iku", "Suika", "Ran", "Remilia",
  "Sakuya", "Kanako", "Suwako", "Tensi",
  "Flandre", "Yuyuko", "Yuuka", "Yukari",
  "Hijiri", "Eiki", "Renko", "Maribel",
  "Toramaru", "Mamizou", "Futo", "Miko",
  "Kokoro", "Tokiko", "Koisi", "Akyuu"
]

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

def iconWidget(filename, disabled=False):
  image = QtGui.QPixmap("img/" + filename)
  icon = QtGui.QIcon(image)
  if (disabled):
    gray = icon.pixmap(image.rect().size(), QtGui.QIcon.Disabled)
    icon.addPixmap(gray, QtGui.QIcon.Normal)
  return [icon, image.rect().size()]

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

def imgButtonWidget(filename, func, grayscale=False):
  button = QtWidgets.QPushButton()
  icon, size = iconWidget(filename, grayscale)
  button.setIcon(icon)
  button.setIconSize(size)
  button.clicked.connect(func)
  return button

class SaveWidget(QtWidgets.QWidget):
  def updateSave(self, save):
    self.save = save

  def __init__(self, save):
    super().__init__()
    self.save = save

class EditWidget(SaveWidget):
  def __init__(self, save):
    super().__init__(save)
    self.commitButton = buttonWidget("Commit Changes", self.commit, 12)
    self.commitButton.setEnabled(False)
    self.revertButton = buttonWidget("Revert Changes", self.revert, 12)
    self.revertButton.setEnabled(False)
    self.errorMsg = ("WARNING! You have uncommited changes. Discard changes " +
      "and go back anyway?")
    self.error = textWidget("", 12, False)
    self.error.setStyleSheet("QLabel { color: red; }")

  def updateSave(self, save):
    super().updateSave(save)
    self.commit()
    self.revert()

  def revert(self):
    self.commitButton.setEnabled(False)
    self.revertButton.setEnabled(False)
    self.error.setText("")

  def commit(self):
    self.commitButton.setEnabled(False)
    self.revertButton.setEnabled(False)
    self.error.setText("")

  def hasChanges(self):
    raise NotImplementedError()

  def checkChanges(self):
    if (self.hasChanges()):
      self.commitButton.setEnabled(True)
      self.revertButton.setEnabled(True)
    else:
      self.commitButton.setEnabled(False)
      self.revertButton.setEnabled(False)

  def checkChangesToBack(self):
    if (self.error.text() == "" and self.hasChanges()):
      self.error.setText(self.errorMsg)
      return False
    return True
