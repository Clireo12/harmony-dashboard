import { Header } from '../component/Header';
import { Bottom } from '../component/Bottom';
import router from '@ohos.router';

interface VehicleStatus {
  oil: string;
  fuel: string;
  batteryVoltage: string;
  coolantTemp: string;
}

interface PreferenceItem {
  name: string;
  enabled: boolean;
}

@Entry
@Component
struct Main {
  @State location: string = '北京市朝阳区建国路88号';
  @State distance: string = '距离目的地还有3.2公里';
  @State vehicleStatus: VehicleStatus = {
    oil: '正常',
    fuel: '充足',
    batteryVoltage: '12.6V',
    coolantTemp: '90°C'
  };
  @State steeringWheelAngle: string = '-270°';
  @State throttleBrakeStatus: string = '减速中...';
  @State drivingModes: string[] = ['经济模式', '运动模式', '雪地模式', '标准模式'];
  @State selectedDrivingMode: number = 3;

  @State preferences: PreferenceItem[] = [
    { name: '转向灯提示音', enabled: false },
    { name: '驾驶模式切换音效', enabled: true },
    { name: '故障报警语音播报', enabled: false },
    { name: '仪表盘动画速度', enabled: true },
    { name: '方言识别模式', enabled: false },
    { name: '盲区监测提示', enabled: true },
    { name: '语音反馈模式', enabled: false }
  ];

  build() {
    Column() {
      Header()

      Row() {

        Column() {
          Text('当前位置')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ top:8, bottom: 8 })
            .align(Alignment.Start)
            .width('100%');

          Image("")
            .width(310)
            .height(150)
            .backgroundColor(Color.Pink)
            .borderRadius(10)
            .margin({ bottom: 12});

          Text(this.location)
            .fontSize(18)
            .margin({ bottom: 16 })
            .align(Alignment.Start)
            .width('100%');

          Text(this.distance)
            .fontSize(16)
            .margin({ bottom: 16 })
            .align(Alignment.Start)
            .width('100%');

          Row() {
            Blank()
            Button("导航")
              .width(70)
              .height(40)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .align(Alignment.End);
          }
          .width('100%')
        }
        .width("35%")
        .height('90%')
        .borderRadius(10)
        .padding(10)
        .margin({left:15})
        .backgroundColor('#FFFFFF')


        Column() {

          Column() {
            Text("这里是主仪表盘页面")
              .width('100%')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .layoutWeight(1)
          .padding(10)
          .backgroundColor('#FFFFFF')
          .borderRadius(10)
          .margin({ bottom: 10 })


          Column() {
            Text('设置与个性化')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({top:8, bottom: 12 })
              .align(Alignment.Start)
              .width('100%');

            Scroll() {
              Column() {
                ForEach(this.preferences, (item: PreferenceItem) => {
                  Row() {
                    Text(item.name)
                      .fontSize(16)
                      .layoutWeight(1)
                      .align(Alignment.Start)

                    Toggle({ type: ToggleType.Switch, isOn: item.enabled })
                      .width(45)
                      .height(27)
                      .onChange((isOn: boolean) => {
                        item.enabled = isOn;
                      })
                  }
                  .width('100%')
                  .height(30)
                  .margin({ bottom: 8 })
                })
              }
              .width('100%')
            }
            .height(130)
            .margin({ bottom: 10 })
          }
          .width('100%')
          .layoutWeight(1)
          .padding(10)
          .backgroundColor('#FFFFFF')
          .borderRadius(10)
        }
        .width("30%")
        .height('90%')
        .margin({ left: 10 })


        Column() {

          Column() {
            Text('车辆状态')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({top:8, bottom: 12 })
              .align(Alignment.Start)
              .width('100%');

            Row() {
              Text('机油')
                .fontSize(16)
                .layoutWeight(1)
                .align(Alignment.Start)
              Text(this.vehicleStatus.oil)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .align(Alignment.End)
                .margin({ right: 10 })
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text('燃油')
                .fontSize(16)
                .layoutWeight(1)
                .align(Alignment.Start)
              Text(this.vehicleStatus.fuel)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .align(Alignment.End)
                .margin({ right: 10 })
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text('电池电压')
                .fontSize(16)
                .layoutWeight(1)
                .align(Alignment.Start)
              Text(this.vehicleStatus.batteryVoltage)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .align(Alignment.End)
                .margin({ right: 10 })
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text('冷却液温度')
                .fontSize(16)
                .layoutWeight(1)
                .align(Alignment.Start)
              Text(this.vehicleStatus.coolantTemp)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .align(Alignment.End)
                .margin({ right: 10 })
            }
            .width('100%')
            .margin({ bottom: 12 })

          }
          .width('100%')
          .padding(10)
          .backgroundColor('#FFFFFF')
          .borderRadius(10)
          .margin({ bottom: 10 })


          Column() {
            Text('车辆控制')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ top:8, bottom: 12 })
              .align(Alignment.Start)
              .width('100%');

            Column() {
              Text('驾驶模式切换')
                .fontSize(16)
                .margin({ bottom: 8 })
                .align(Alignment.Start)
                .width('100%');

              TextPicker({ range: this.drivingModes, selected: this.selectedDrivingMode })
                .selectedTextStyle({
                  font: { size: 20, weight: FontWeight.Bold },
                  color: '#007DFF'
                })
                .textStyle({
                  font: { size: 16 },
                  color: '#666666'
                })
                .onChange((value: string | string[], index: number | number[]) => {
                  if (typeof value === 'string') {
                    this.selectedDrivingMode = index as number;
                    console.log('Selected driving mode:', value);
                  }
                })
                .width('100%')
                .height(110)
            }
            .width('100%')
            .margin({ bottom: 10 })
          }
          .width('100%')
          .layoutWeight(1)
          .padding(10)
          .backgroundColor('#FFFFFF')
          .borderRadius(10)
        }
        .width("30%")
        .height('90%')
        .margin({left:10,right:15})
      }
      .layoutWeight(1)
      .height('100%')

      Bottom()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f0f0f0')
  }
}