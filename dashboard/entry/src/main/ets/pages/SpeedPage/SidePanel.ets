import { MenuItem } from "../../model/MenuItem"
import { ThemeManager } from '../../model/ThemeManager';

@Component
export struct SidePanel {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @Prop menu: MenuItem[]

  build() {
    Column({ space: 60 }) {
      ForEach(this.menu, (item: MenuItem) => {
        if (item.img) {
          Image(item.img)
            .fillColor(Color.Gray)
            .width(35)
        } else {
          Column() {
            Text('▲')
              .fontSize(18)
              .fontColor(this.themeManager.getCurrentTheme().textColor)
            Text(`${item.text}°`)
              .fontSize(30)
              .fontColor(this.themeManager.getCurrentTheme().textColor)
            Text('▼')
              .fontSize(18)
              .fontColor(this.themeManager.getCurrentTheme().textColor)
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