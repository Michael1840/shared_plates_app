import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/palette.dart';

@immutable
class SpColors extends ThemeExtension<SpColors> {
  const new({
    required this.background,
    required this.dotGrid,
    required this.card,
    required this.raised,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.line,
    required this.primary,
    required this.onPrimary,
    required this.primaryDeep,
    required this.accentText,
    required this.blush,
    required this.header,
    required this.headerFriends,
    required this.onHeader,
    required this.onHeaderFriends,
    required this.noteOnLight,
    required this.noteOnHeader,
    required this.herb,
    required this.honey,
    required this.honeySoft,
    required this.honeyInk,
    required this.honeyDot,
    required this.tape,
    required this.chipFill,
    required this.chipSelectedFill,
    required this.chipSelectedRing,
    required this.chipSelectedText,
    required this.searchFill,
    required this.filterFill,
    required this.filterIcon,
    required this.tabBarFill,
    required this.tabActive,
    required this.tabInactive,
    required this.tabActivePill,
    required this.skeleton,
    required this.handle,
    required this.chevron,
    required this.shadow,
    required this.printShadow,
  });

  static const light = SpColors(
    background: Palette.oat,
    dotGrid: Palette.oatDot,
    card: Palette.card,
    raised: Palette.oat,
    textPrimary: Palette.ink,
    textSecondary: Palette.cocoa,
    textMuted: Palette.muted,
    line: Palette.line,
    primary: Palette.paprika,
    onPrimary: Palette.card,
    primaryDeep: Palette.paprikaDeep,
    accentText: Palette.paprikaDeep,
    blush: Palette.blush,
    header: Palette.paprika,
    headerFriends: Palette.herb,
    onHeader: Palette.cream,
    onHeaderFriends: Palette.herbCream,
    noteOnLight: Palette.paprikaDeep,
    noteOnHeader: Palette.noteOnHeader,
    herb: Palette.herb,
    honey: Palette.honey,
    honeySoft: Palette.honeySoft,
    honeyInk: Palette.honeyInk,
    honeyDot: Palette.honeyDot,
    tape: Color(0x8CE9A23B),
    chipFill: Palette.card,
    chipSelectedFill: Palette.blush,
    chipSelectedRing: Palette.paprika,
    chipSelectedText: Palette.chipSelectedText,
    searchFill: Palette.card,
    filterFill: Palette.blush,
    filterIcon: Palette.paprikaDeep,
    tabBarFill: Color(0xE0FFFFFF),
    tabActive: Palette.paprikaActive,
    tabInactive: Palette.muted,
    tabActivePill: Palette.blush,
    skeleton: Palette.skeleton,
    handle: Palette.handle,
    chevron: Palette.chevron,
    shadow: Color(0x293C2314),
    printShadow: Color(0x243C2314),
  );

  static const dark = SpColors(
    background: Palette.nightBackground,
    dotGrid: Palette.nightDot,
    card: Palette.nightCard,
    raised: Palette.nightRaised,
    textPrimary: Palette.nightText,
    textSecondary: Palette.nightSecondary,
    textMuted: Palette.nightMuted,
    line: Palette.nightLine,
    primary: Palette.paprika,
    onPrimary: Palette.card,
    primaryDeep: Palette.nightAccentText,
    accentText: Palette.nightAccentText,
    blush: Palette.nightChipFill,
    header: Palette.nightHeader,
    headerFriends: Palette.nightHerbHeader,
    onHeader: Palette.cream,
    onHeaderFriends: Palette.herbCream,
    noteOnLight: Palette.nightAccentText,
    noteOnHeader: Palette.noteOnHeader,
    herb: Palette.herb,
    honey: Palette.honey,
    honeySoft: Palette.honeySoft,
    honeyInk: Palette.honeyInk,
    honeyDot: Palette.honeyDot,
    tape: Color(0x8CE9A23B),
    chipFill: Palette.nightCard,
    chipSelectedFill: Palette.nightChipFill,
    chipSelectedRing: Palette.nightChipRing,
    chipSelectedText: Palette.nightAccentText,
    searchFill: Palette.nightCard,
    filterFill: Palette.nightChipFill,
    filterIcon: Palette.nightAccentText,
    tabBarFill: Color(0xE0342A23),
    tabActive: Palette.nightAccentText,
    tabInactive: Palette.nightMuted,
    tabActivePill: Palette.nightChipFill,
    skeleton: Palette.nightSkeleton,
    handle: Palette.nightHandle,
    chevron: Palette.nightMuted,
    shadow: Color(0x4D000000),
    printShadow: Color(0x59000000),
  );

  final Color background;
  final Color dotGrid;
  final Color card;
  final Color raised;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color line;
  final Color primary;
  final Color onPrimary;
  final Color primaryDeep;
  final Color accentText;
  final Color blush;
  final Color header;
  final Color headerFriends;
  final Color onHeader;
  final Color onHeaderFriends;
  final Color noteOnLight;
  final Color noteOnHeader;
  final Color herb;
  final Color honey;
  final Color honeySoft;
  final Color honeyInk;
  final Color honeyDot;
  final Color tape;
  final Color chipFill;
  final Color chipSelectedFill;
  final Color chipSelectedRing;
  final Color chipSelectedText;
  final Color searchFill;
  final Color filterFill;
  final Color filterIcon;
  final Color tabBarFill;
  final Color tabActive;
  final Color tabInactive;
  final Color tabActivePill;
  final Color skeleton;
  final Color handle;
  final Color chevron;
  final Color shadow;
  final Color printShadow;

  @override
  SpColors copyWith() => this;

  @override
  SpColors lerp(ThemeExtension<SpColors>? other, double t) {
    if (other is! SpColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return SpColors(
      background: l(background, other.background),
      dotGrid: l(dotGrid, other.dotGrid),
      card: l(card, other.card),
      raised: l(raised, other.raised),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textMuted: l(textMuted, other.textMuted),
      line: l(line, other.line),
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      primaryDeep: l(primaryDeep, other.primaryDeep),
      accentText: l(accentText, other.accentText),
      blush: l(blush, other.blush),
      header: l(header, other.header),
      headerFriends: l(headerFriends, other.headerFriends),
      onHeader: l(onHeader, other.onHeader),
      onHeaderFriends: l(onHeaderFriends, other.onHeaderFriends),
      noteOnLight: l(noteOnLight, other.noteOnLight),
      noteOnHeader: l(noteOnHeader, other.noteOnHeader),
      herb: l(herb, other.herb),
      honey: l(honey, other.honey),
      honeySoft: l(honeySoft, other.honeySoft),
      honeyInk: l(honeyInk, other.honeyInk),
      honeyDot: l(honeyDot, other.honeyDot),
      tape: l(tape, other.tape),
      chipFill: l(chipFill, other.chipFill),
      chipSelectedFill: l(chipSelectedFill, other.chipSelectedFill),
      chipSelectedRing: l(chipSelectedRing, other.chipSelectedRing),
      chipSelectedText: l(chipSelectedText, other.chipSelectedText),
      searchFill: l(searchFill, other.searchFill),
      filterFill: l(filterFill, other.filterFill),
      filterIcon: l(filterIcon, other.filterIcon),
      tabBarFill: l(tabBarFill, other.tabBarFill),
      tabActive: l(tabActive, other.tabActive),
      tabInactive: l(tabInactive, other.tabInactive),
      tabActivePill: l(tabActivePill, other.tabActivePill),
      skeleton: l(skeleton, other.skeleton),
      handle: l(handle, other.handle),
      chevron: l(chevron, other.chevron),
      shadow: l(shadow, other.shadow),
      printShadow: l(printShadow, other.printShadow),
    );
  }
}
