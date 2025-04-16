import { MenuItem } from "../../model/MenuItem"

@Component
export struct SidePanel {
  @Prop menu: MenuItem[]

  build() {
    Column({ space: 60 }) {
      ForEach(this.menu, (item: MenuItem) => {
        if (item.img) {
          Image(item.img)
            .width(35)
        } else {
          Column() {
            Text('▲')
              .fontSize(18)
              .fontColor($r('app.color.text_color'))
            Text(`${item.text}°`)
              .fontSize(30)
              .fontColor($r('app.color.theme_blue'))
            Text('▼')
              .fontSize(18)
              .fontColor($r('app.color.text_color'))
          }
        }
      })
    }
    .padding(10)
    .justifyContent(FlexAlign.Center)
    .width(80)
    .height('100%')
  }
}