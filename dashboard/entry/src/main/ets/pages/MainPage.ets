import { Header } from '../component/Header';
import { Bottom } from '../component/Bottom';
import router from '@ohos.router';
import { ThemeManager } from '../model/ThemeManager';
import { ThemeConfig } from '../model/ThemeConfig';
import PreferencesUtil from '../utils/PreferencesUtil';

interface VehicleStatus {
  oil: string;
  fuel: string;
  batteryVoltage: string;
  coolantTemp: string;
}

@Entry
@Component
struct MainPage {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()
  @State location: string = '北京市 朝阳区 建国路88号';
  @State distance: string = '3.2公里';
  @State area: string = '深圳市 南山区'
  @State temperature: number = 29
  @State weather: string = '晴天'
  @State vehicleStatus: VehicleStatus = {
    oil: '正常',
    fuel: '充足',
    batteryVoltage: '12.6V',
    coolantTemp: '90°C'
  };
  @State steeringWheelAngle: string = '-270°';
  @State throttleBrakeStatus: string = '减速中...';
  @State drivingModes: string[] = ['经济模式','运动模式','雪地模式','城市模式'];
  @State selectedDrivingMode: number = 3;
  @State CirclePanel: string="80km/h"


  aboutToAppear(): void {
    PreferencesUtil.Load()
    this.selectedDrivingMode = PreferencesUtil.get('selectedMode', 0) as number
  }


  navigateToDashboard() {
    router.pushUrl({ url: 'pages/SpeedPage/Index' });
  }

  navigateToVehicleStatus() {
    router.pushUrl({ url: 'pages/StatusPage/Index' });
  }

  navigateToVehicleControl() {
    router.pushUrl({ url: 'pages/ControlPage/Index' });
  }

  navigateToSettings() {
    router.pushUrl({ url: 'pages/SettingPage/PersonalizationSettings' });
  }

  onPageShow() {
    const themeConfig = router.getParams() as ThemeConfig
    if (themeConfig) {
      this.currentTheme = themeConfig
    }
  }

  build() {
    Column() {
      Header({ currentTheme: this.currentTheme })

      List({ space: 30 }) {
        ListItem() {
          Column() {
            Text('当前位置')
              .fontColor(this.themeManager.getCurrentTheme().textColor)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .align(Alignment.Start)
              .width('100%')
              .margin({ top: 8 })

            Stack() {
              Image($r('app.media.road'))
                .width(250)
              Image($r('app.media.car2'))
                .width(100)
            }
            .width('90%')
            .height(150)
            .borderRadius(10)

            Column({ space: 15 }) {
              Text(this.location)
                .fontColor(this.themeManager.getCurrentTheme().textColor)
                .fontSize(18)
                .fontWeight(500)
                .textAlign(TextAlign.Center)
                .align(Alignment.Start)
                .width('100%');

              Text('距离目标位置')
                .fontColor(this.themeManager.getCurrentTheme().textColor)
                .fontSize(16)

              Text(this.distance)
                .fontColor(this.themeManager.getCurrentTheme().textColor)
                .fontSize(28)
                .fontWeight(600)
                .textAlign(TextAlign.Center)
                .align(Alignment.Start)
                .width('100%');

              Row() {

              }
              .width('100%')
            }

          }

          .CardStyle()
          .width("30%")
          .height('90%')
          .margin({ left:15 })
        }

        ListItem() {
          Column({ space: 20 }) {

            // 可以整几个仪表盘展示数据
            Row({ space: 20 }) {

              ForEach([1,2,3], () => {
                Column({ space: 8 }) {
                  Image($r('app.media.fuel'))
                    .width(55)

                  Text(this.CirclePanel)
                    .fontColor(this.themeManager.getCurrentTheme().textColor)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .margin({ bottom: 10 })
                    .textAlign(TextAlign.Center)
                }
              })

            }
            .CardStyle()
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              this.navigateToDashboard();
            })

            Column({ space: 20 }) {
              Row() {
                Text('车辆控制')
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .layoutWeight(1)

                Text('驾驶模式切换')
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(16)
              }
              .justifyContent(FlexAlign.SpaceBetween)

              Column() {

                TextPicker({ range: this.drivingModes, selected: this.selectedDrivingMode })
                  .selectedTextStyle({
                    font: { size: 20, weight: FontWeight.Bold },
                    color: '#007DFF'
                  })
                  .textStyle({
                    font: { size: 16 },
                    color: '#666666'
                  })
                  .onScrollStop((value: string | string[], index: number | number[]) => {
                    console.info('Picker item changed, value: ' + value + ', index: ' + index)
                    this.selectedDrivingMode = index as number
                    PreferencesUtil.put('selectedMode', this.selectedDrivingMode)
                    console.info('selectedMode: ' + this.selectedDrivingMode)
                  })
                  .width('100%')
                  .height(110)
              }
              .width('100%')
              .margin({ bottom: 10 })
            }
            .CardStyle()
            .layoutWeight(1)
            .clip(true) // 隐藏溢出的元素
            .onClick(() => {
              this.navigateToVehicleStatus();
            })

          }
          .width("30%")
          .height('90%')
        }

        ListItem() {

          Column() {
            Image($r('app.media.travel'))
              .height('50%')
              .offset({ y: 15 })

            Row({ space: 15 }) {
              Column({ space: 8 }) {
                Text(this.area)
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                Text(`${this.temperature}℃`)
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(36)
                  .fontWeight(500)
                Text(this.weather)
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
              }
              Image($r('app.media.sun_left'))
                .fillColor(this.themeManager.getCurrentTheme().textColor)
                .width(80)
            }
            .CardStyle()
            .justifyContent(FlexAlign.SpaceAround)
            .layoutWeight(1)

          }
          .width("28%")
          .height('90%')
        }

        ListItem() {
          Column({ space: 20 }) {

            Column({ space: 15 }) {
              Text('车辆状态')
                .fontColor(this.themeManager.getCurrentTheme().textColor)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .align(Alignment.Start)
                .width('100%');

              Row() {
                Text('机油')
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(16)
                  .layoutWeight(1)
                  .align(Alignment.Start)
                Text(this.vehicleStatus.oil)
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .align(Alignment.End)
              }
              .width('100%')

              Row() {
                Text('燃油')
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(16)
                  .layoutWeight(1)
                  .align(Alignment.Start)
                Text(this.vehicleStatus.fuel)
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .align(Alignment.End)
              }
              .width('100%')

              Row() {
                Text('电池电压')
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(16)
                  .layoutWeight(1)
                  .align(Alignment.Start)
                Text(this.vehicleStatus.batteryVoltage)
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .align(Alignment.End)
              }
              .width('100%')

              Row() {
                Text('冷却液温度')
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(16)
                  .layoutWeight(1)
                  .align(Alignment.Start)
                Text(this.vehicleStatus.coolantTemp)
                  .fontColor(this.themeManager.getCurrentTheme().textColor)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .align(Alignment.End)
              }
              .width('100%')

            }
            .CardStyle()
            .layoutWeight(1)
            .onClick(() => {
              this.navigateToVehicleControl();
            })

            Column() {
              Row({ space: 10 }) {
                Column(){
                  Image($r('app.media.theme'))
                    .fillColor(this.themeManager.getCurrentTheme().textColor)
                    .width(30)
                    .margin({ bottom: 10 })
                  Text("主题")
                    .fontColor(this.themeManager.getCurrentTheme().textColor)
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                }
                .borderRadius(10)
                .layoutWeight(1)
                .height(80)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor(this.themeManager.getCurrentTheme().mask)

                Column(){
                  Image($r('app.media.sun_left'))
                    .fillColor(this.themeManager.getCurrentTheme().textColor)
                    .width(30)
                    .margin({ bottom: 10 })
                  Text("亮度")
                    .fontColor(this.themeManager.getCurrentTheme().textColor)
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                }
                .layoutWeight(1)
                .borderRadius(10)
                .height(80)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor(this.themeManager.getCurrentTheme().mask)

                Column(){
                  Image($r('app.media.like'))
                    .fillColor(this.themeManager.getCurrentTheme().textColor)
                    .width(30)
                    .margin({ bottom: 10 })
                  Text("偏好")
                    .fontColor(this.themeManager.getCurrentTheme().textColor)
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                }.layoutWeight(1)
                .height(80)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .borderRadius(10)
                .backgroundColor(this.themeManager.getCurrentTheme().mask)
              }
              .width("100%")
              .justifyContent(FlexAlign.SpaceBetween)

            }
            .CardStyle()
            .padding(10)
            .onClick(() => {
              this.navigateToSettings();
            })

          }
          .width("30%")
          .height('90%')
        }
      }
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .alignListItem(ListItemAlign.Center)
      .width('100%')
      .height('100%')
      .padding(15)

      Bottom({ currentTheme: this.currentTheme })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.currentTheme.theme)
  }

  @Styles
  CardStyle() {
    .width('100%')
    .padding(15)
    .backgroundColor(this.themeManager.getCurrentTheme().mask)
    .borderRadius(10)
  }
}