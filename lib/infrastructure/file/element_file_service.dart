import 'package:shiori/domain/models/models.dart';
import 'package:shiori/domain/services/file/element_file_service.dart';
import 'package:shiori/domain/services/file/translation_file_service.dart';
import 'package:shiori/domain/services/resources_service.dart';

class ElementFileServiceImpl extends ElementFileService {
  final TranslationFileService _translations;

  late ElementsFile _elementsFile;

  @override
  ResourceService get resources => throw UnimplementedError('Resource service is not required in this file');

  @override
  TranslationFileService get translations => _translations;

  ElementFileServiceImpl(this._translations);

  @override
  Future<void> init(String assetPath) async {
    final json = await readJson(assetPath);
    _elementsFile = ElementsFile.fromJson(json);
  }

  @override
  List<ElementCardModel> getElementDebuffs() {
    return _elementsFile.debuffs.map(
      (e) {
        final translation = _translations.getDebuffTranslation(e.key);
        final reaction = ElementCardModel(name: translation.name, effect: translation.effect, image: e.fullImagePath);
        return reaction;
      },
    ).toList()
      ..sort((x, y) => x.name.compareTo(y.name));
  }

  @override
  List<ElementReactionCardModel> getElementReactions() {
    return _elementsFile.reactions.map(
      (e) {
        final translation = _translations.getReactionTranslation(e.key);
        final reaction = ElementReactionCardModel.withImages(
          name: translation.name,
          effect: translation.effect,
          principal: e.principalImages,
          secondary: e.secondaryImages,
        );
        return reaction;
      },
    ).toList()
      ..sort((x, y) => x.name.compareTo(y.name));
  }

  @override
  List<ElementReactionCardModel> getElementResonances() {
    return _elementsFile.resonance.map(
      (e) {
        final translation = _translations.getResonanceTranslation(e.key);
        final reaction = e.hasImages
            ? ElementReactionCardModel.withImages(
                name: translation.name,
                effect: translation.effect,
                principal: e.principalImages,
                secondary: e.secondaryImages,
              )
            : ElementReactionCardModel.withoutImages(
                name: translation.name,
                effect: translation.effect,
                description: translation.description,
              );
        return reaction;
      },
    ).toList();
  }
}
