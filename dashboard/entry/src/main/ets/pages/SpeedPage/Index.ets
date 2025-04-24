import { Bottom } from '../../component/Bottom';
import { Header } from '../../component/Header';
import { CarPanel } from './CarPanel';
import { CirclePanel } from './CirclePanel';
import { MenuItem } from '../../model/MenuItem';
import { SidePanel } from './SidePanel';
import { ThemeManager } from '../../model/ThemeManager';

@Entry
@Component
export struct DashboardPage {
  private themeManager: ThemeManager = ThemeManager.getInstance();

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

      Header()

      Row({ space: 5 }) {
        SidePanel({ menu: this.leftMenu })

        CirclePanel({
          num: 80,
          unit: 'km/h',
          current: 100
        })

        CarPanel({ activeLight: 2 })

        CirclePanel({
          num: 50,
          unit: 'km',
          current: 100,
          reverse: true
        })

        SidePanel({ menu: this.rightMenu })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Bottom()
    }
    .height('100%')
    .width('100%')
    .backgroundColor(this.themeManager.getCurrentTheme().theme)
  }
}