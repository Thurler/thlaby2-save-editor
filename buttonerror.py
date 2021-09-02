from PySide6 import QtWidgets

from common import *

class ButtonError(QtWidgets.QWidget):
  def setEnabled(self, target):
    self.button.setEnabled(target)

  def setError(self, error):
    self.error.setText(error)

  def __init__(self, buttonText, buttonFunc, size, enabled=True):
    super().__init__()
    layout = QtWidgets.QGridLayout()
    
    self.button = buttonWidget(buttonText, buttonFunc, size)
    self.error = textWidget("", 12, False)

    self.button.setEnabled(enabled)
    self.error.setStyleSheet("QLabel { color: red; }")

    layout.addWidget(self.button, 0, 0)
    layout.addWidget(self.error, 1, 0)

    for i in range(2):
      layout.setRowStretch(i, 1)
    for i in range(1):
      layout.setColumnStretch(i, 1)
    self.setLayout(layout)
