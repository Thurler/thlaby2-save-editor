from common import *

libraryOrder = [
  "HP", "ATK", "DEF", "MAG", "MND", "SPD",
  "FIR", "CLD", "WND", "NTR", "MYS", "SPI", "DRK", "PHY"
]
skillOrder = [
  "HP", "MP", "TP", "ATK", "DEF", "MAG", "MND", "SPD",
  "EVA", "ACC", "AFF", "RES"
]

class GameInfo():
  def __init__(self, data, endian):
    self.allEXP = int.from_bytes(data[0x00:0x08], endian)
    self.allMoney = int.from_bytes(data[0x08:0x10], endian)
    self.money = int.from_bytes(data[0x10:0x18], endian)
    self.battles = int.from_bytes(data[0x18:0x20], endian)
    self.gameovers = int.from_bytes(data[0x20:0x24], endian)
    self.playtime = int.from_bytes(data[0x24:0x28], endian)
    self.treasures = int.from_bytes(data[0x28:0x2c], endian)
    self.crafts = int.from_bytes(data[0x2c:0x30], endian)
    self.unusedA = int.from_bytes(data[0x30:0x34], endian)
    self.highestFloor = data[0x34]
    self.treasuresLock = int.from_bytes(data[0x35:0x39], endian)
    self.escapes = int.from_bytes(data[0x39:0x3d], endian)
    self.entrances = int.from_bytes(data[0x3d:0x41], endian)
    self.drops = int.from_bytes(data[0x41:0x45], endian)
    self.foes = int.from_bytes(data[0x45:0x49], endian)
    self.steps = int.from_bytes(data[0x49:0x51], endian)
    self.shopBuy = int.from_bytes(data[0x51:0x59], endian)
    self.shopSell = int.from_bytes(data[0x59:0x61], endian)
    self.expStreak = int.from_bytes(data[0x61:0x69], endian)
    self.moneyStreak = int.from_bytes(data[0x69:0x71], endian)
    self.dropStreak = int.from_bytes(data[0x71:0x75], endian)
    self.unusedB = data[0x75]
    self.library = int.from_bytes(data[0x76:0x7e], endian)
    self.battleStreak = int.from_bytes(data[0x7e:0x82], endian)
    self.escapeStreak = int.from_bytes(data[0x82:0x86], endian)
    self.hardmode = data[0x86]
    self.icenable = data[0x87]
    self.unusedC = data[0x88:0xae]
    self.icfloor = int.from_bytes(data[0xae:0xb2], endian)
    self.akyuuTrades = int.from_bytes(data[0xb2:0xb6], endian)
    self.unusedD = data[0xb6:0xba]

  def export(self, endian):
    result = [0]*0xba
    result[0x00:0x08] = self.allEXP.to_bytes(8, endian)
    result[0x08:0x10] = self.allMoney.to_bytes(8, endian)
    result[0x10:0x18] = self.money.to_bytes(8, endian)
    result[0x18:0x20] = self.battles.to_bytes(8, endian)
    result[0x20:0x24] = self.gameovers.to_bytes(4, endian)
    result[0x24:0x28] = self.playtime.to_bytes(4, endian)
    result[0x28:0x2c] = self.treasures.to_bytes(4, endian)
    result[0x2c:0x30] = self.crafts.to_bytes(4, endian)
    result[0x30:0x34] = self.unusedA.to_bytes(4, endian)
    result[0x34] = self.highestFloor
    result[0x35:0x39] = self.treasuresLock.to_bytes(4, endian)
    result[0x39:0x3d] = self.escapes.to_bytes(4, endian)
    result[0x3d:0x41] = self.entrances.to_bytes(4, endian)
    result[0x41:0x45] = self.drops.to_bytes(4, endian)
    result[0x45:0x49] = self.foes.to_bytes(4, endian)
    result[0x49:0x51] = self.steps.to_bytes(8, endian)
    result[0x51:0x59] = self.shopBuy.to_bytes(8, endian)
    result[0x59:0x61] = self.shopSell.to_bytes(8, endian)
    result[0x61:0x69] = self.expStreak.to_bytes(8, endian)
    result[0x69:0x71] = self.moneyStreak.to_bytes(8, endian)
    result[0x71:0x75] = self.dropStreak.to_bytes(4, endian)
    result[0x75] = self.unusedB
    result[0x76:0x7e] = self.library.to_bytes(8, endian)
    result[0x7e:0x82] = self.battleStreak.to_bytes(4, endian)
    result[0x82:0x86] = self.escapeStreak.to_bytes(4, endian)
    result[0x86] = self.hardmode
    result[0x87] = self.icenable
    result[0x88:0xae] = self.unusedC
    result[0xae:0xb2] = self.icfloor.to_bytes(4, endian)
    result[0xb2:0xb6] = self.akyuuTrades.to_bytes(4, endian)
    result[0xb6:0xba] = self.unusedD
    return result

class EventFlags():
  def __init__(self, data):
    self.data = data

class Character():
  def __init__(self, data, legacy):
    endian = "big" if legacy else "little"
    self.level = int.from_bytes(data[0x000:0x004], endian)
    self.exp = int.from_bytes(data[0x004:0x00c], endian)
    self.library = {}
    for i, stat in enumerate(libraryOrder):
      start = 0xc + (i*4)
      self.library[stat] = int.from_bytes(data[start:start+4], endian)
    self.levelups = {}
    for i, stat in enumerate(libraryOrder[:6]):
      start = 0x44 + (i*4)
      self.levelups[stat] = int.from_bytes(data[start:start+4], endian)
    self.subclass = int.from_bytes(data[0x05c:0x060], endian)
    self.skills = []
    for i in range(40): # 12 boost, 6 empty, 2 exp, 10 personal, 10 spells
      start = 0x60 + (i*2)
      self.skills += [int.from_bytes(data[start:start+2], endian)]
    self.skillsSubclass = []
    for i in range(20): # (subclass) 10 passives, 10 spells
      start = 0xb0 + (i*2)
      self.skillsSubclass += [int.from_bytes(data[start:start+2], endian)]
    self.tomes = {}
    for i, stat in enumerate(skillOrder):
      start = 0xd8 + (i*1)
      self.tomes[stat] = data[start]
    self.tomeLevels = {}
    for i, stat in enumerate(skillOrder[:8]):
      start = 0xe4 + (i*1)
      self.tomeLevels[stat] = data[start]
    self.skillPoints = int.from_bytes(data[0x0ec:0x0ee], endian)
    self.unusedLevelups = int.from_bytes(data[0x0ee:0x0f2], endian)
    self.gems = {}
    for i, stat in enumerate(skillOrder[:8]):
      start = 0xf2 + (i*2)
      self.gems[stat] = int.from_bytes(data[start:start+2], endian)
    self.manuals = data[0x102]
    self.bp = int.from_bytes(data[0x103:0x107], endian)
    self.equips = []
    for i in range(4):
      start = 0x107 + (i*2)
      self.equips += [int.from_bytes(data[start:start+2], endian)]

  def export(self, legacy):
    result = [0]*271
    endian = "big" if legacy else "little"
    result[0x000:0x004] = self.level.to_bytes(4, endian)
    result[0x004:0x00c] = self.exp.to_bytes(8, endian)
    for i, stat in enumerate(libraryOrder):
      start = 0xc + (i*4)
      result[start:start+4] = self.library[stat].to_bytes(4, endian)
    for i, stat in enumerate(libraryOrder[:6]):
      start = 0x44 + (i*4)
      result[start:start+4] = self.levelups[stat].to_bytes(4, endian)
    result[0x05c:0x060] = self.subclass.to_bytes(4, endian)
    for i in range(40): # 12 boost, 6 empty, 2 exp, 10 personal, 10 spells
      start = 0x60 + (i*2)
      result[start:start+2] = self.skills[i].to_bytes(2, endian)
    for i in range(20): # (subclass) 10 passives, 10 spells
      start = 0xb0 + (i*2)
      result[start:start+2] = self.skillsSubclass[i].to_bytes(2, endian)
    for i, stat in enumerate(skillOrder):
      start = 0xd8 + (i*1)
      result[start] = self.tomes[stat]
    for i, stat in enumerate(skillOrder[:8]):
      start = 0xe4 + (i*1)
      result[start] = self.tomeLevels[stat]
    result[0x0ec:0x0ee] = self.skillPoints.to_bytes(2, endian)
    result[0x0ee:0x0f2] = self.unusedLevelups.to_bytes(4, endian)
    for i, stat in enumerate(skillOrder[:8]):
      start = 0xf2 + (i*2)
      result[start:start+2] = self.gems[stat].to_bytes(2, endian)
    result[0x102] = self.manuals
    result[0x103:0x107] = self.bp.to_bytes(4, endian)
    for i in range(4):
      start = 0x107 + (i*2)
      result[start:start+2] = self.equips[i].to_bytes(2, endian)
    return result

class Map():
  def __init__(self, data):
    self.data = data

class SaveFile():
  def loadLegacy(self, path):
    raise Exception("Not implemented")

  def loadSteam(self, path):
    self.path = path
    data = None
    with open(path, 'rb') as f:
      data = f.read()
      data = [((i & 0xff) ^ c) for i, c in enumerate(data)]
    if len(data) != 257678:
      raise Exception("ERROR: File is not the correct length")
    if (data[:4] != [0x42, 0x4c, 0x48, 0x54] or data[0x67] != 0x01):
      raise Exception("ERROR: File is not the correct format")
    self.charsUnlock = data[0x5:0x3d]
    self.achievements = data[0x68:0x0d0]
    self.achievementsPlus = data[0xd6:0x10a]
    self.achievementNotification = data[0x130:0x198]
    self.achievementNotificationPlus = data[0x19e:0x1d2]
    self.bestiary = convert2Bytes(data[0x2c2:0x4c22])
    self.party = data[0x5018:0x5024]
    self.info = GameInfo(data[0x540c:0x54c6], "little")
    self.events = EventFlags(data[0x54c6:0x68b2])
    self.inventoryFlags = {
      "main": data[0x7bd7:0x7c13],
      "sub": data[0x7c9f:0x7d8f],
      "materials": data[0x7dcb:0x7e2f],
      "special": data[0x7ef7:0x7fab]
    }
    self.inventory = {
      "main": convert2Bytes(data[0x83a8:0x8420]),
      "sub": convert2Bytes(data[0x8538:0x8718]),
      "materials": convert2Bytes(data[0x8790:0x8858]),
      "special": convert2Bytes(data[0x89e8:0x8b50])
    }
    self.characters = [
      Character(data[0x9346+(i*271):0x9346+((i+1)*271)], False)
      for i in range(56)
    ]
    self.maps = [
      Map(data[0xce8e+(i*0x1000):0xce8e+((i+1)*0x1000)]) for i in range(30)
    ]
    self.undergroundMaps = [
      Map(data[0x33e8e+(i*0x1000):0x33e8e+((i+1)*0x1000)]) for i in range(11)
    ]

  def exportLegacy(self, path):
    raise Exception("Not implemented")

  def exportSteam(self, path):
    saveFile = [0]*257678
    saveFile[:4] = [0x42, 0x4c, 0x48, 0x54]
    saveFile[0x67] = 0x01
    saveFile[0x5:0x3d] = self.charsUnlock
    saveFile[0x68:0x0d0] = self.achievements
    saveFile[0xd6:0x10a] = self.achievementsPlus
    saveFile[0x130:0x198] = self.achievementNotification
    saveFile[0x19e:0x1d2] = self.achievementNotificationPlus
    saveFile[0x2c2:0x4c22] = convertTo2Bytes(self.bestiary)
    saveFile[0x5018:0x5024] = self.party
    saveFile[0x540c:0x54c6] = self.info.export("little")
    saveFile[0x54c6:0x68b2] = self.events.data
    saveFile[0x7bd7:0x7c13] = self.inventoryFlags["main"]
    saveFile[0x7c9f:0x7d8f] = self.inventoryFlags["sub"]
    saveFile[0x7dcb:0x7e2f] = self.inventoryFlags["materials"]
    saveFile[0x7ef7:0x7fab] = self.inventoryFlags["special"]
    saveFile[0x83a8:0x8420] = convertTo2Bytes(self.inventory["main"])
    saveFile[0x8538:0x8718] = convertTo2Bytes(self.inventory["sub"])
    saveFile[0x8790:0x8858] = convertTo2Bytes(self.inventory["materials"])
    saveFile[0x89e8:0x8b50] = convertTo2Bytes(self.inventory["special"])
    for i, c in enumerate(self.characters):
      saveFile[0x9346+(i*271):0x9346+((i+1)*271)] = c.export(False)
    for i, m in enumerate(self.maps):
      saveFile[0xce8e+(i*0x1000):0xce8e+((i+1)*0x1000)] = m.data
    for i, m in enumerate(self.undergroundMaps):
      saveFile[0x33e8e+(i*0x1000):0x33e8e+((i+1)*0x1000)] = m.data
    if (len(saveFile) != 257678):
      raise Exception("ERROR: File is not the correct length")
    for i, c in enumerate(saveFile):
      if isinstance(c, float):
        print(hex(i))
        print(c)
    saveFile = [((i & 0xff) ^ c) for i, c in enumerate(saveFile)]
    if (path[-4:] != ".dat"):
      path += ".dat"
    with open(path, 'wb') as f:
      f.write(bytes(saveFile))
