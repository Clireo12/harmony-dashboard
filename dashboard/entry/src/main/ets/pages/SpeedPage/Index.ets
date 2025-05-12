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

  @State speed: number = 30 // 车速
  @State distance: number = 212 // 里程数
  @State trafficLight: number = 0 // 红绿灯
  @State leftMenu: MenuItem[] = [
    { img: $r('app.media.warning'), active: false },
    { img: $r('app.media.charge'), active: false },
    { img: $r('app.media.cardoor'), active: false }
  ]
  @State rightMenu: MenuItem[] = [
    { img: null, active: true },
    { img: $r('app.media.fan'), active: true },
    { img: null, active: true }
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
        SidePanel({
          menu: this.leftMenu
        })

        Column() {
          SignalLight({ activeLight: this.trafficLight })

          CarPanel({
            speed: this.speed,
            distance: this.distance
          })
        }
        .layoutWeight(1)

        SidePanel({
          menu: this.rightMenu
        })
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