import { Header } from '../component/Header';
import { Bottom } from '../component/Bottom';
import router from '@ohos.router';
import { ThemeManager } from '../model/ThemeManager';
import { themeConfig, ThemeConfig,ThemeKey} from '../model/ThemeConfig';
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
  @StorageProp('fontSize') fontSize: number = 18;
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()
  @State currentThemeKey: ThemeKey = this.themeManager.getCurrentThemeKey();
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
    this.selectedDrivingMode = PreferencesUtil.get('selectedMode', 0) as number

    const savedTheme = PreferencesUtil.get('userSelectedTheme', '') as ThemeKey;
    if (savedTheme && Object.keys(themeConfig).includes(savedTheme)) {
      this.currentThemeKey = savedTheme;
      this.currentTheme = themeConfig[savedTheme];
    }

    // 添加主题变化监听
    this.themeManager.addThemeChangeListener(() => {
      this.currentTheme = this.themeManager.getCurrentTheme();
    });
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

  build() {
    Column() {
      Header({currentTheme: this.currentTheme})

      List({ space: 20 }) {
        ListItem() {
          Column() {
            Text('当前位置')
              .fontColor(this.currentTheme.textColor)
              .fontSize(this.fontSize)
              .fontWeight(FontWeight.Bold)
              .align(Alignment.Start)
              .width('100%')
              .margin({ top: 8 })

            Stack() {
              Image($r('app.media.road'))
                .width("100%")

              Image($r('app.media.car2'))
                .width("50%")
            }
            .width('90%')
            .height("50%")
            .borderRadius(10)

            Column({ space: 10 }) {
              Text(this.location)
                .fontColor(this.currentTheme.textColor)
                .fontSize(this.fontSize)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .align(Alignment.Start)
                .width('100%');

              Text('距离目标位置')
                .fontColor(this.currentTheme.textColor)
                .fontSize(this.fontSize-2)

              Text(this.distance)
                .fontColor(this.currentTheme.textColor)
                .fontSize(this.fontSize+5)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .align(Alignment.Start)
                .width('100%');
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
                Column({ space: 15 }) {
                  Image($r('app.media.fuel'))
                    .width("30%")

                  Text(this.CirclePanel)
                    .fontColor(this.currentTheme.textColor)
                    .fontSize(this.fontSize)
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Center)
                }
              })

            }
            .CardStyle()
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              this.navigateToDashboard();
            })

            Column({ space: 15 }) {
              Row() {
                Text('车辆控制')
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize+2)
                  .fontWeight(FontWeight.Bold)
                  .layoutWeight(1)

                Text('驾驶模式切换')
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize)
              }
              .justifyContent(FlexAlign.SpaceBetween)

              Column() {

                  TextPicker({ range: this.drivingModes, selected: this.selectedDrivingMode })
                  .selectedTextStyle({
                    font: { size: this.fontSize+2, weight: FontWeight.Bold },
                    color: '#007DFF'
                  })
                  .textStyle({
                    font: { size: this.fontSize-2 },
                    color: '#666666'
                  })
                  .onChange(async(value: string | string[], index: number | number[]) => {
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
                  .fontColor(this.currentTheme.textColor)
                Text(`${this.temperature}℃`)
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize+15)
                  .fontWeight(FontWeight.Bold)
                Text(this.weather)
                  .fontColor(this.currentTheme.textColor)
              }
              Image($r('app.media.sun_left'))
                .fillColor(this.currentTheme.iconColor)
                .width("35%")
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
                .fontColor(this.currentTheme.textColor)
                .fontSize(this.fontSize+2)
                .fontWeight(FontWeight.Bold)
                .align(Alignment.Start)
                .width('100%');

              Row() {
                Text('机油')
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize-2)
                  .layoutWeight(1)
                  .align(Alignment.Start)
                Text(this.vehicleStatus.oil)
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize-2)
                  .fontWeight(FontWeight.Bold)
                  .align(Alignment.End)
              }
              .width('100%')

              Row() {
                Text('燃油')
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize-2)
                  .layoutWeight(1)
                  .align(Alignment.Start)
                Text(this.vehicleStatus.fuel)
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize-2)
                  .fontWeight(FontWeight.Bold)
                  .align(Alignment.End)
              }
              .width('100%')

              Row() {
                Text('电池电压')
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize-2)
                  .layoutWeight(1)
                  .align(Alignment.Start)
                Text(this.vehicleStatus.batteryVoltage)
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize-2)
                  .fontWeight(FontWeight.Bold)
                  .align(Alignment.End)
              }
              .width('100%')

              Row() {
                Text('冷却液温度')
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize-2)
                  .layoutWeight(1)
                  .align(Alignment.Start)
                Text(this.vehicleStatus.coolantTemp)
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize-2)
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
                    .fillColor(this.currentTheme.iconColor)
                    .width("30%")
                    .margin({ bottom: 10 })
                  Text("主题")
                    .fontColor(this.currentTheme.textColor)
                    .fontSize(this.fontSize-2)
                    .textAlign(TextAlign.Center)
                }
                .borderRadius(10)
                .layoutWeight(1)
                .height("20%")
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)

                Column(){
                  Image($r('app.media.sun_left'))
                    .fillColor(this.currentTheme.iconColor)
                    .width("30%")
                    .margin({ bottom: 10 })
                  Text("亮度")
                    .fontColor(this.currentTheme.textColor)
                    .fontSize(this.fontSize-2)
                    .textAlign(TextAlign.Center)
                }
                .layoutWeight(1)
                .borderRadius(10)
                .height("20%")
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)


                Column(){
                  Image($r('app.media.like'))
                    .fillColor(this.currentTheme.iconColor)
                    .width("30%")
                    .margin({ bottom: 10 })
                  Text("偏好")
                    .fontColor(this.currentTheme.textColor)
                    .fontSize(this.fontSize-2)
                    .textAlign(TextAlign.Center)
                }.layoutWeight(1)
                .height("20%")
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .borderRadius(10)
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
      .padding(5)

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
    .backgroundColor(this.currentTheme.mask)
    .borderRadius(10)
  }
}