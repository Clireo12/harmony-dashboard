import { Bottom } from '../../component/Bottom';
import { Header } from '../../component/Header';
import { CarPanel } from './CarPanel';
import { MenuItem } from '../../model/MenuItem';
import { SidePanel } from './SidePanel';
import { SignalLight } from './SignalLight';
import { themeConfig, ThemeConfig } from '../../model/ThemeConfig';
import PreferencesUtil from '../../utils/PreferencesUtil';
import { router } from '@kit.ArkUI';
import IotDataTool from '../../utils/IotDataTool';



@Entry
@Component
export struct DashboardPage {
  @State currentTheme: ThemeConfig = this.getTimeBasedTheme();

  @State speed: number = 0 // 车速
  @StorageLink("motor_speed") motor_speed:number = (IotDataTool.motor_speed)

  @StorageLink("motor_speed") RPM_value:number = IotDataTool.motor_speed * this.getRandomInt(15, 70)  // 转数
  @State trafficLight: number = 1 // 转向灯 0左 2右 1复原
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
  // 定时器
  speedTimer: number = -1
  turnTimer: number = -1

  aboutToAppear() {
    this.activeTab = PreferencesUtil.get('drivingMode', 'P') as string
    this.updateSpeedAndDistance()
    // 时速变化
    this.speedTimer = setInterval(() => {
      this.speed = (this.motor_speed - 1)
    }, 500)
    this.turnTimer = setInterval(() => {
      let keyStatus = AppStorage.get("keyStatus") as string
      if (keyStatus == "左") {
        this.trafficLight = 0
      } else if (keyStatus == "右"){
        this.trafficLight = 2
      }else {
        this.trafficLight = 1
      }
    }, 1000)
  }

  aboutToDisappear(): void {
    clearInterval(this.speedTimer)
    clearInterval(this.turnTimer)
  }

  // 根据时间获取主题
  private getTimeBasedTheme(): ThemeConfig {
    const hours = new Date().getHours();
    const isDayTime = hours >= 6 && hours < 18; //6:00-18:00为白天
    return isDayTime ? themeConfig['classic-blackRed'] : themeConfig['minimal-white'];
  }
  // 生成 [min, max] 范围内的随机整数
  getRandomInt(min: number, max: number): number {
  min = Math.ceil(min); // 向上取整确保最小值合法
  max = Math.floor(max); // 向下取整确保最大值合法
  return Math.floor(Math.random() * (max - min + 1)) + min;
  }
  updateSpeedAndDistance() {
    const totalMileage = PreferencesUtil.get('TotalMileage', 0) as number
    this.RPM_value = totalMileage

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
            RPM: this.RPM_value,
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