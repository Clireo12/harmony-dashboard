import { Bottom } from '../../component/Bottom';
import { Header } from '../../component/Header';
import { CarPanel } from './CarPanel';
import { MenuItem } from '../../model/MenuItem';
import { SidePanel } from './SidePanel';
import { ThemeManager } from '../../model/ThemeManager';
import { SignalLight } from './SignalLight';
import { themeConfig, ThemeConfig } from '../../model/ThemeConfig';
import PreferencesUtil from '../../utils/PreferencesUtil';

@Entry
@Component
export struct DashboardPage {
  @State currentTheme: ThemeConfig = this.getTimeBasedTheme();

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
  private timeCheckTimer: number | null = null;//时间检查定时器

  aboutToAppear() {
    this.activeTab = PreferencesUtil.get('drivingMode', 'P') as string
    this.updateSpeedAndDistance()
  }

  //根据时间获取主题
  private getTimeBasedTheme(): ThemeConfig {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; //6:00-18:00为白天
    return isDayTime ? themeConfig['classic-blackRed'] : themeConfig['minimal-white'];
  }

  //启动时间检查器
  private startTimeChecker() {
    this.timeCheckTimer = setInterval(() => {
      this.currentTheme = this.getTimeBasedTheme();
    }, 60000); //每分钟检查一次
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