// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsDataGen {
  const $AssetsDataGen();

  /// File path: assets/data/quran.json
  String get quran => 'assets/data/quran.json';

  /// List of all assets
  List<String> get values => [quran];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/logo luqman al hakim.png
  AssetGenImage get logoLuqmanAlHakim =>
      const AssetGenImage('assets/images/logo luqman al hakim.png');

  /// File path: assets/images/my_halaqoh_icon_padded.png
  AssetGenImage get myHalaqohIconPadded =>
      const AssetGenImage('assets/images/my_halaqoh_icon_padded.png');

  /// File path: assets/images/my_halaqoh_logo.png
  AssetGenImage get myHalaqohLogo =>
      const AssetGenImage('assets/images/my_halaqoh_logo.png');

  /// File path: assets/images/my_halaqoh_logo_launcher.png
  AssetGenImage get myHalaqohLogoLauncher =>
      const AssetGenImage('assets/images/my_halaqoh_logo_launcher.png');

  /// File path: assets/images/my_halaqoh_logo_new.png
  AssetGenImage get myHalaqohLogoNew =>
      const AssetGenImage('assets/images/my_halaqoh_logo_new.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    logoLuqmanAlHakim,
    myHalaqohIconPadded,
    myHalaqohLogo,
    myHalaqohLogoLauncher,
    myHalaqohLogoNew,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsDataGen data = $AssetsDataGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
