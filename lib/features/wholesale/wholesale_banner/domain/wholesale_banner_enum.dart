enum WholesaleBannerTypeEnum {
  main,
  mainSection,
  popup;

  String get value {
    switch (this) {
      case WholesaleBannerTypeEnum.main:
        return 'Main Banner';
      case WholesaleBannerTypeEnum.mainSection:
        return 'Main Section Banner';
      case WholesaleBannerTypeEnum.popup:
        return 'Popup Banner';
    }
  }
}
