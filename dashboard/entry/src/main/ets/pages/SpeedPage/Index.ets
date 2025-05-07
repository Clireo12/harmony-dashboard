import { Bottom } from '../../component/Bottom';
import { Header } from '../../component/Header';
import { CarPanel } from './CarPanel';
import { MenuItem } from '../../model/MenuItem';
import { SidePanel } from './SidePanel';
import { ThemeManager } from '../../model/ThemeManager';
import { SignalLight } from './SignalLight';
import { ThemeConfig } from '../../model/ThemeConfig';
import PreferencesUtil from '../../utils/PreferencesUtil';

@Entry
@Component
export struct DashboardPage {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()

  @Prop speed: number // 车速
  @Prop distance: number  // 里程数
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
  @State activeTab: string = 'P'

  aboutToAppear() {
    this.activeTab = PreferencesUtil.get('drivingMode', 'P') as string
    this.updateSpeedAndDistance()
  }

  updateSpeedAndDistance() {
    const totalMileage = PreferencesUtil.get('TotalMileage', 0) as number
    this.distance = totalMileage

    switch (this.activeTab) {
      case 'P': //停车模式
      case 'N': //空档模式
        this.speed = 0
        break
      case 'R': //倒车模式
        this.speed = 20
        break
      case 'D': //驾驶模式
      case 'S': //运动模式
        this.speed = 80
        break
    }
  }

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