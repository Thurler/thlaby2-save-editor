import 'dart:typed_data';

import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';

class GeneralData {
  late BigInt totalExpAcquired;
  late BigInt totalMoneyAcquired;
  late BigInt currentMoney;
  late BigInt battleCount;
  late int gameoverCount;
  late Duration playTime;
  late int openedChests;
  late int craftedCount;
  late List<int> unusedDataBlock1;
  late int highestFloor;
  late int openedLockedChests;
  late int battleEscapeCount;
  late int dungeonEnterCount;
  late int enemyDropCount;
  late int foeKills;
  late BigInt stepsCount;
  late BigInt moneySpentShop;
  late BigInt moneySoldShop;
  late BigInt highestExpStreak;
  late BigInt highestMoneyStreak;
  late int highestDropsStreak;
  late List<int> unusedDataBlock2;
  late BigInt libraryInvestmentCount;
  late int battleCountStreak;
  late int battleEscapeCountStreak;
  late bool hardMode;
  late bool icUnlocked;
  late List<int> unusedDataBlock3;
  late int icFloor;
  late int akyuuTradeCount;
  late List<int> unusedDataBlock4;

  GeneralData.fromBytes({
    required Endian endianness,
    required List<int> bytes,
  }) {
    totalExpAcquired = bytes.getU64(endianness);
    totalMoneyAcquired = bytes.getU64(endianness, offset: 0x8);
    currentMoney = bytes.getU64(endianness, offset: 0x10);
    battleCount = bytes.getU64(endianness, offset: 0x18);
    gameoverCount = bytes.getU32(endianness, offset: 0x20);
    playTime = Duration(seconds: bytes.getU32(endianness, offset: 0x24));
    openedChests = bytes.getU32(endianness, offset: 0x28);
    craftedCount = bytes.getU32(endianness, offset: 0x2c);
    unusedDataBlock1 = bytes.sublist(0x30, 0x34);
    highestFloor = bytes[0x34];
    openedLockedChests = bytes.getU32(endianness, offset: 0x35);
    battleEscapeCount = bytes.getU32(endianness, offset: 0x39);
    dungeonEnterCount = bytes.getU32(endianness, offset: 0x3d);
    enemyDropCount = bytes.getU32(endianness, offset: 0x41);
    foeKills = bytes.getU32(endianness, offset: 0x45);
    stepsCount = bytes.getU64(endianness, offset: 0x49);
    moneySpentShop = bytes.getU64(endianness, offset: 0x51);
    moneySoldShop = bytes.getU64(endianness, offset: 0x59);
    highestExpStreak = bytes.getU64(endianness, offset: 0x61);
    highestMoneyStreak = bytes.getU64(endianness, offset: 0x69);
    highestDropsStreak = bytes.getU32(endianness, offset: 0x71);
    unusedDataBlock2 = bytes.sublist(0x75, 0x76);
    libraryInvestmentCount = bytes.getU64(endianness, offset: 0x76);
    battleCountStreak = bytes.getU32(endianness, offset: 0x7e);
    battleEscapeCountStreak = bytes.getU32(endianness, offset: 0x82);
    hardMode = bytes[0x86] > 0;
    icUnlocked = bytes[0x87] > 0;
    unusedDataBlock3 = bytes.sublist(0x88, 0xae);
    icFloor = bytes.getU32(endianness, offset: 0xae);
    akyuuTradeCount = bytes.getU32(endianness, offset: 0xb2);
    unusedDataBlock4 = bytes.sublist(0xb6, 0xba);
  }

  GeneralData.from(GeneralData other) {
    totalExpAcquired = other.totalExpAcquired;
    totalMoneyAcquired = other.totalMoneyAcquired;
    currentMoney = other.currentMoney;
    battleCount = other.battleCount;
    gameoverCount = other.gameoverCount;
    playTime = other.playTime;
    openedChests = other.openedChests;
    craftedCount = other.craftedCount;
    unusedDataBlock1 = List<int>.from(other.unusedDataBlock1);
    highestFloor = other.highestFloor;
    openedLockedChests = other.openedLockedChests;
    battleEscapeCount = other.battleEscapeCount;
    dungeonEnterCount = other.dungeonEnterCount;
    enemyDropCount = other.enemyDropCount;
    foeKills = other.foeKills;
    stepsCount = other.stepsCount;
    moneySpentShop = other.moneySpentShop;
    moneySoldShop = other.moneySoldShop;
    highestExpStreak = other.highestExpStreak;
    highestMoneyStreak = other.highestMoneyStreak;
    highestDropsStreak = other.highestDropsStreak;
    unusedDataBlock2 = List<int>.from(other.unusedDataBlock2);
    libraryInvestmentCount = other.libraryInvestmentCount;
    battleCountStreak = other.battleCountStreak;
    battleEscapeCountStreak = other.battleEscapeCountStreak;
    hardMode = other.hardMode;
    icUnlocked = other.icUnlocked;
    unusedDataBlock3 = List<int>.from(other.unusedDataBlock3);
    icFloor = other.icFloor;
    akyuuTradeCount = other.akyuuTradeCount;
    unusedDataBlock4 = List<int>.from(other.unusedDataBlock4);
  }

  Iterable<int> toBytes(Endian endianness) {
    Iterable<int> bytes = <int>[];
    bytes = bytes.followedBy(totalExpAcquired.toU64(endianness));
    bytes = bytes.followedBy(totalMoneyAcquired.toU64(endianness));
    bytes = bytes.followedBy(currentMoney.toU64(endianness));
    bytes = bytes.followedBy(battleCount.toU64(endianness));
    bytes = bytes.followedBy(gameoverCount.toU32(endianness));
    bytes = bytes.followedBy(playTime.inSeconds.toU32(endianness));
    bytes = bytes.followedBy(openedChests.toU32(endianness));
    bytes = bytes.followedBy(craftedCount.toU32(endianness));
    bytes = bytes.followedBy(unusedDataBlock1);
    bytes = bytes.followedBy(<int>[highestFloor]);
    bytes = bytes.followedBy(openedLockedChests.toU32(endianness));
    bytes = bytes.followedBy(battleEscapeCount.toU32(endianness));
    bytes = bytes.followedBy(dungeonEnterCount.toU32(endianness));
    bytes = bytes.followedBy(enemyDropCount.toU32(endianness));
    bytes = bytes.followedBy(foeKills.toU32(endianness));
    bytes = bytes.followedBy(stepsCount.toU64(endianness));
    bytes = bytes.followedBy(moneySpentShop.toU64(endianness));
    bytes = bytes.followedBy(moneySoldShop.toU64(endianness));
    bytes = bytes.followedBy(highestExpStreak.toU64(endianness));
    bytes = bytes.followedBy(highestMoneyStreak.toU64(endianness));
    bytes = bytes.followedBy(highestDropsStreak.toU32(endianness));
    bytes = bytes.followedBy(unusedDataBlock2);
    bytes = bytes.followedBy(libraryInvestmentCount.toU64(endianness));
    bytes = bytes.followedBy(battleCountStreak.toU32(endianness));
    bytes = bytes.followedBy(battleEscapeCountStreak.toU32(endianness));
    bytes = bytes.followedBy(<int>[hardMode ? 1 : 0]);
    bytes = bytes.followedBy(<int>[icUnlocked ? 1 : 0]);
    bytes = bytes.followedBy(unusedDataBlock3);
    bytes = bytes.followedBy(icFloor.toU32(endianness));
    bytes = bytes.followedBy(akyuuTradeCount.toU32(endianness));
    bytes = bytes.followedBy(unusedDataBlock4);
    return bytes;
  }
}
