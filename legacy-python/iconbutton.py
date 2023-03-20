from common import *

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
