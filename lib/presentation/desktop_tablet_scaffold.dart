import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiori/application/bloc.dart';
import 'package:shiori/generated/l10n.dart';
import 'package:shiori/presentation/artifacts/artifacts_page.dart';
import 'package:shiori/presentation/characters/characters_page.dart';
import 'package:shiori/presentation/home/home_page.dart';
import 'package:shiori/presentation/map/map_page.dart';
import 'package:shiori/presentation/settings/settings_page.dart';
import 'package:shiori/presentation/shared/extensions/focus_scope_node_extensions.dart';
import 'package:shiori/presentation/shared/shiori_icons.dart';
import 'package:shiori/presentation/weapons/weapons_page.dart';

typedef OnWillPop = Future<bool> Function();

class DesktopTabletScaffold extends StatelessWidget {
  final int defaultIndex;
  final TabController tabController;

  const DesktopTabletScaffold({
    super.key,
    required this.defaultIndex,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final extended = MediaQuery.of(context).orientation != Orientation.portrait;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            _NavigationRail(defaultIndex: defaultIndex + 1, extended: extended, tabController: tabController),
            const VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const CharactersPage(),
                  const WeaponsPage(),
                  HomePage(),
                  const ArtifactsPage(),
                  MapPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationRail extends StatefulWidget {
  final int defaultIndex;
  final bool extended;
  final TabController tabController;

  const _NavigationRail({
    required this.defaultIndex,
    required this.extended,
    required this.tabController,
  });

  @override
  State<_NavigationRail> createState() => _NavigationRailState();
}

class _NavigationRailState extends State<_NavigationRail> {
  late int _index;
  late bool _extended;

  @override
  void initState() {
    _index = widget.defaultIndex;
    _extended = widget.extended;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<MainTabBloc, MainTabState>(
      listener: (ctx, state) async {
        state.maybeMap(
          initial: (s) => _changeCurrentTab(s.currentSelectedTab),
          orElse: () => {},
        );
      },
      child: NavigationRail(
        selectedIndex: _index,
        onDestinationSelected: (index) => _gotoTab(index),
        labelType: _extended ? null : NavigationRailLabelType.selected,
        extended: _extended,
        destinations: <NavigationRailDestination>[
          NavigationRailDestination(
            icon: const Icon(Icons.menu),
            selectedIcon: const Icon(Icons.menu),
            label: Text(s.collapse),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.people),
            selectedIcon: const Icon(Icons.people),
            label: Text(s.characters),
          ),
          NavigationRailDestination(
            icon: const Icon(Shiori.crossed_swords),
            selectedIcon: const Icon(Shiori.crossed_swords),
            label: Text(s.weapons),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.home),
            selectedIcon: const Icon(Icons.home),
            label: Text(s.home),
          ),
          NavigationRailDestination(
            icon: const Icon(Shiori.overmind),
            selectedIcon: const Icon(Shiori.overmind),
            label: Text(s.artifacts),
          ),
          if (!Platform.isMacOS)
            NavigationRailDestination(
              icon: const Icon(Icons.map),
              selectedIcon: const Icon(Icons.map),
              label: Text(s.map),
            ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings),
            selectedIcon: const Icon(Icons.settings),
            label: Text(s.settings),
          ),
        ],
      ),
    );
  }

  void _changeCurrentTab(int index) {
    FocusScope.of(context).removeFocus();
    widget.tabController.index = index;

    setState(() {
      _index = index + 1;
    });
  }

  Future<void> _gotoTab(int newIndex) async {
    if (newIndex == 0) {
      setState(() {
        _extended = !_extended;
      });
      return;
    }
    final realIndex = newIndex - 1;
    if (realIndex == 5 || (realIndex == 4 && Platform.isMacOS)) {
      await _gotoSettingsPage();
      return;
    }
    context.read<MainTabBloc>().add(MainTabEvent.goToTab(index: realIndex));
  }

  Future<void> _gotoSettingsPage() async {
    final route = MaterialPageRoute(builder: (c) => SettingsPage());
    await Navigator.push(context, route);
  }
}
