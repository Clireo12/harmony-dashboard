import { Header } from '../../component/Header'
import { Bottom } from '../../component/Bottom'
import { MainPanel } from './MainPanel'
import { ThemeManager } from '../../model/ThemeManager';
import { ThemeConfig } from '../../model/ThemeConfig';

@Entry
@Component
export struct VehicleControlPage {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()

  build() {
    Column(){
      Header({ currentTheme: this.currentTheme })
      Row() {
        MainPanel()
      }
      .layoutWeight(1)

      Bottom({ currentTheme: this.currentTheme })
    }
    .backgroundColor(this.currentTheme.theme)
  }
}