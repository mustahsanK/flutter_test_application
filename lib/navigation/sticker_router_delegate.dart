import 'package:flutter/material.dart';
import 'package:flutter_test_application/model/sticker.dart';
import 'package:flutter_test_application/navigation/sticker_route_path.dart';

import '../model/tag.dart';
import '../views/screens/details_screen.dart';
import '../views/screens/list_screen.dart';
import '../views/screens/unknown_screen.dart';

class StickerRouterDelegate extends RouterDelegate<StickerRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<StickerRoutePath> {
  Sticker? _selectedSticker;
  bool show404 = false;

  final List<Sticker> stickers = [
    const Sticker('Dash', [Tag('Tech'), Tag('Coding'), Tag('Dev'), Tag('Flutter'), Tag('Cool')], 100, 'assets/images/img1.jpg'),
    const Sticker('Dash', [Tag('Tech'), Tag('Coding'), Tag('Dev'), Tag('Flutter'), Tag('Cool')], 100, 'assets/images/img1.jpg'),
    const Sticker('Dash', [Tag('Tech'), Tag('Coding'), Tag('Dev'), Tag('Flutter'), Tag('Cool')], 100, 'assets/images/img1.jpg'),
    const Sticker('Dash', [Tag('Tech'), Tag('Coding'), Tag('Dev'), Tag('Flutter'), Tag('Cool')], 100, 'assets/images/img1.jpg'),
    const Sticker('Dash', [Tag('Tech'), Tag('Coding'), Tag('Dev'), Tag('Flutter'), Tag('Cool')], 100, 'assets/images/img1.jpg'),
    const Sticker('Dash', [Tag('Tech'), Tag('Coding'), Tag('Dev'), Tag('Flutter'), Tag('Cool')], 100, 'assets/images/img1.jpg'),
    const Sticker('Dash', [Tag('Tech'), Tag('Coding'), Tag('Dev'), Tag('Flutter'), Tag('Cool')], 100, 'assets/images/img1.jpg'),
    const Sticker('Dash', [Tag('Tech'), Tag('Coding'), Tag('Dev'), Tag('Flutter'), Tag('Cool')], 100, 'assets/images/img1.jpg'),
    const Sticker('Dash', [Tag('Tech'), Tag('Coding'), Tag('Dev'), Tag('Flutter'), Tag('Cool')], 100, 'assets/images/img1.jpg'),
  ];

  @override
  GlobalKey<NavigatorState>? get navigatorKey => throw GlobalKey<NavigatorState>();

  @override
  StickerRoutePath get currentConfiguration {
    if (show404) {
      return StickerRoutePath.unknown();
    }
    return _selectedSticker == null ? StickerRoutePath.list() : StickerRoutePath.details(stickers.indexOf(_selectedSticker!));
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('StickerListPage'),
          child: StickerListScreen(stickers, _handleStickerTap),
        ),
        if (show404)
          const MaterialPage(
            key: ValueKey('Unknown Page'),
            child: UnknownScreen(),
          )
        else
          MaterialPage(
            key: const ValueKey('Details Page'),
            child: DetailsScreen(_selectedSticker!),
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _selectedSticker = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(StickerRoutePath configuration) async {
    if (configuration.isUnknown) {
      _selectedSticker = null;
      show404 = true;
      return;
    }
    if (configuration.isDetailsPage) {
      if (configuration.id < 0 || configuration.id >= stickers.length) {
        show404 = true;
        return;
      }
      _selectedSticker = stickers[configuration.id];
    }
    show404 = false;
  }

  void _handleStickerTap(Sticker sticker) {
    _selectedSticker = sticker;
    notifyListeners();
  }
}