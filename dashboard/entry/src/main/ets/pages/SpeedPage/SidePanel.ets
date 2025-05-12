import { MenuItem } from "../../model/MenuItem"
import { ThemeManager } from '../../model/ThemeManager';

@Component
export struct SidePanel {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @Link menu: MenuItem[]
  @State temperature: number = 20

  build() {
    Column({ space: 60 }) {
      ForEach(this.menu, (item: MenuItem, index: number) => {
        if (item.img) {
          Image(item.img)
            .fillColor(item.active ? Color.Red : Color.Gray)
            .width(35)
        } else {
          Column() {
            Text('▲')
              .fontSize(18)
              .fontColor(this.themeManager.getCurrentTheme().textColor)
              .onClick(() => {
                if (this.temperature < 32) {
                  this.temperature--
                }
              })
            Text(`${this.temperature}°`)
              .fontSize(30)
              .fontColor(this.themeManager.getCurrentTheme().textColor)
            Text('▼')
              .fontSize(18)
              .fontColor(this.themeManager.getCurrentTheme().textColor)
              .onClick(() => {
                if (this.temperature > 16) {
                  this.temperature++
                }
              })
          }
        }
      })
    }
    .padding(10)
    .justifyContent(FlexAlign.Center)
    .width(80)
    .height('100%')
    .backgroundColor(this.themeManager.getCurrentTheme().theme)
  }
}