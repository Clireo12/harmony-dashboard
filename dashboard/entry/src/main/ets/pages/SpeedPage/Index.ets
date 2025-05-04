import { Bottom } from '../../component/Bottom';
import { Header } from '../../component/Header';
import { CarPanel } from './CarPanel';
import { MenuItem } from '../../model/MenuItem';
import { SidePanel } from './SidePanel';
import { ThemeManager } from '../../model/ThemeManager';
import { SignalLight } from './SignalLight';
import { ThemeConfig } from '../../model/ThemeConfig';

@Entry
@Component
export struct DashboardPage {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()

  @State speed: number = 80 // 车速
  @State distance: number = 50 // 里程数
  @State leftMenu: MenuItem[] = [
    { img: $r('app.media.warning'), text: '', active: true },
    { img: $r('app.media.charge'), text: '', active: true },
    { img: $r('app.media.cardoor'), text: '', active: true }
  ]
  @State rightMenu: MenuItem[] = [
    { img: null, text: `${20}`, active: true },
    { img: $r('app.media.fan'), text: ``, active: true },
    { img: null, text: `${20}`, active: true }
  ]

  build() {
    Column() {

      Header({ currentTheme: this.currentTheme })

      Row({ space: 5 }) {
        SidePanel({ menu: this.leftMenu })

        Column() {
          SignalLight({ activeLight: 0 })

          CarPanel({
            speed: this.speed,
            distance: this.distance
          })
        }
        .layoutWeight(1)

        SidePanel({ menu: this.rightMenu })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Bottom({ currentTheme: this.currentTheme })
    }
    .height('100%')
    .width('100%')
    .backgroundColor(this.currentTheme.theme)
  }
}