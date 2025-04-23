import { Header } from '../../component/Header'
import { Bottom } from '../../component/Bottom'
import { MainPanel } from './MainPanel'
import { ThemeManager } from '../../model/ThemeManager';

@Entry
@Component
export struct VehicleControlPage {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  // 提供默认的BuilderParam
  @BuilderParam content: () => void = this.defaultContent;

  // 默认内容构建器
  @Builder
  defaultContent() {
    Column() {
      // 可以留空或添加默认占位内容
    }
  }

  build() {
    Column(){
      this.content
      Header()
      Row() {
        MainPanel()
      }
      .layoutWeight(1)

      Bottom()
    }
    .backgroundColor(this.themeManager.getCurrentTheme().theme)
  }
}