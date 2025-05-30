import { Bottom } from '../../component/Bottom';
import { Header } from '../../component/Header';
import { CarPanel } from './CarPanel';
import { MenuItem } from '../../model/MenuItem';
import { SidePanel } from './SidePanel';
import { SignalLight } from './SignalLight';
import { themeConfig, ThemeConfig } from '../../model/ThemeConfig';
import PreferencesUtil from '../../utils/PreferencesUtil';
import { router } from '@kit.ArkUI';

@Entry
@Component
export struct DashboardPage {
  @State currentTheme: ThemeConfig = this.getTimeBasedTheme();

  @State speed: number = 30 // 车速
  @State distance: number = 212 // 里程数
  @State trafficLight: number = 0 // 0红1绿2黄灯  转向灯0左2右
  @State leftMenu: MenuItem[] = [
    { img: $r('app.media.warning'), active: false },
    { img: $r('app.media.charge'), active: false },
    { img: $r('app.media.cardoor'), active: false }
  ]
  @State rightMenu: MenuItem[] = [
    { img: null, active: true },
    { img: null, active: true }
  ]
  @State @Watch('updateSpeedAndDistance') activeTab: string = 'P'

  aboutToAppear() {
    this.activeTab = PreferencesUtil.get('drivingMode', 'P') as string
    this.updateSpeedAndDistance()
    let speedTimer = setInterval(() => {
      if (this.speed < 45) {
        this.speed++
      } else {
        clearInterval(speedTimer)
        speedTimer = setInterval(() => {
          this.speed += Math.floor(Math.random() * 5 - 2)
        }, 800)
      }
    }, 30)
    const distanceTimer = setInterval(() => {
      if (this.distance < 20) {
        this.distance++
      } else {
        clearInterval(distanceTimer)
      }
    }, 8000)
  }

  // 根据时间获取主题
  private getTimeBasedTheme(): ThemeConfig {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; //6:00-18:00为白天
    return isDayTime ? themeConfig['classic-blackRed'] : themeConfig['minimal-white'];
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
          menu: this.leftMenu,
          isLeftPanel: true
        })

        Column() {
          SignalLight({
            activeLight: this.trafficLight,
          })
            .height('10%')
            .margin({ top: 20 ,right: 20})

          CarPanel({
            speed: this.speed,
            distance: this.distance,
            activeLight: this.trafficLight
          })
            .height('60%')

          SidePanel({
            menu: this.rightMenu,
            isLeftPanel: false
          })
            .height('15%')
            .margin({ top: 10 })
        }
        .layoutWeight(1)

      }
      .width('100%')

      // Bottom({
      //   currentTheme: this.currentTheme,
      //   activeTab: this.activeTab
      // })
    }
    .height('100%')
    .width('100%')
    .backgroundColor(this.currentTheme.theme)
  }
}