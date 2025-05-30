import { MenuItem } from "../../model/MenuItem"
import { themeConfig, ThemeConfig } from "../../model/ThemeConfig";
import { router } from "@kit.ArkUI";

@Component
export struct SidePanel {
  @State currentTheme: ThemeConfig = this.getTimeBasedTheme();
  @Link menu: MenuItem[]
  @State temperature: number = 20 //温度
  @Prop isLeftPanel: boolean = false  //是否为左侧面板

  // 根据时间获取主题
  private getTimeBasedTheme(): ThemeConfig {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; //6:00-18:00为白天
    return isDayTime ? themeConfig['classic-blackRed'] : themeConfig['minimal-white'];
  }

  build() {

    if (this.isLeftPanel) {
      //左侧面板，垂直排列
      Column({ space: 80 }) {
        Image($r("app.media.back"))
          .width(40)
          .fillColor(this.currentTheme.iconColor)
          .onClick(() => {
            //跳转到主页
            router.back({
              url: 'pages/MainPage'
            })
          })
        Column({ space: 60 }) {
          ForEach(this.menu, (item: MenuItem) => {
            this.buildMenuItem(item)
          })
        }
      }
      .width(80)
      .height('90%')
      .padding(10)
    } else {
      //下面空调，水平排列
      Row({ space: 450 }) {
        ForEach(this.menu, (item: MenuItem) => {
          this.buildMenuItem(item)
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
  }

  @Builder
  buildMenuItem(item: MenuItem) {
    if (item.img) {
      //显示图标，并根据 item.active 状态设置颜色
      Image(item.img)
        .fillColor(item.active ? Color.Red : Color.Gray)
        .width(35)
    } else {
      //空调温度调节
      Row({ space: 10 }) {
        Image($r('app.media.fan'))
          .width(35)
          .fillColor(Color.Gray)
        Text('▲')
          .fontSize(25)
          .fontColor(this.currentTheme.textColor)
          .rotate({ angle: -90 })
          .onClick(() => this.temperature > 16 && this.temperature--) //降低
        Text(`${this.temperature}°`)
          .fontSize(30)
          .fontColor(this.currentTheme.textColor)
        Text('▼')
          .fontSize(25)
          .fontColor(this.currentTheme.textColor)
          .rotate({ angle: -90 })
          .onClick(() => this.temperature < 32 && this.temperature++) //提高
      }
    }
  }
}