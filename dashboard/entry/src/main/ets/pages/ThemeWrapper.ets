import { ThemeManager } from '../model/ThemeManager';

@Component
export struct ThemeWrapper {
  @BuilderParam content: () => void;
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State private refreshFlag: boolean = false;

  build() {
    Column() {
      this.content()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.themeManager.getCurrentTheme().theme)
  }
}
