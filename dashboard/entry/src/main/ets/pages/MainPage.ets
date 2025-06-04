import { Header } from '../component/Header';
import { Bottom } from '../component/Bottom';
import router from '@ohos.router';
import { ThemeManager } from '../model/ThemeManager';
import { themeConfig, ThemeConfig,ThemeKey} from '../model/ThemeConfig';
import PreferencesUtil from '../utils/PreferencesUtil';
import IotDataTool, { CommandFactory, ON_OFF } from '../utils/IotDataTool';
import { Snow } from './WeatherDisplay/Snow';
import { Rain } from './WeatherDisplay/Rain';
import { playerManager } from './MusicPage/PlayerManager';
import { SongInfo } from '../model/SongModel';
import WeatherUtils from '../utils/WeatherUtils';

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
  //主题管理
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()
  @State currentThemeKey: ThemeKey = this.themeManager.getCurrentThemeKey();
  // 导航
  @State location: string = `${WeatherUtils.city} ${WeatherUtils.district} ${WeatherUtils.township}`;
  // @State distance: string = '3.2公里';
  // 仪表盘
  @State speed: number = 0 // 车速
  @State milometer: number =212 // 里程
  @State maxSpeed: number = 125 // 最高时速
  // 天气
  @State area: string = `${WeatherUtils.city} ${WeatherUtils.district}`
  @State temperature: string = WeatherUtils.temperature
  @State weather: string = '多云'   //需要获取
  // 车辆控制
  @State DrivingMode: string[] = ['标准模式','经济模式','运动模式','雪地模式']
  @State selectedDrivingMode: number = 3;
  @State temp:string=''
  // 车辆状态
  @State vehicleStatus: VehicleStatus = {
    oil: '正常', // 机油状态
    fuel: '充足', // 燃油状态
    batteryVoltage: '12.6V', // 电池电压
    coolantTemp: `${this.temp}°C` // 冷却液温度
  };
  @State steeringWheelAngle: string = '-270°';
  @State throttleBrakeStatus: string = '减速中...';
  //音乐播放
  @StorageLink('isPlay') isPlaying: boolean = false;  //播放状态
  @StorageLink('currentSong') currentSong: SongInfo = playerManager.currentSong
  @StorageLink("illumination") illumination:string = IotDataTool.illumination
  @StorageLink("body_state")@Watch("isBeep") body_state:string = IotDataTool.body_state
  @StorageLink("temperature") IOT_temperature:string = IotDataTool.temperature
  @StorageLink("smoke") smoke:string = IotDataTool.smoke
  isBeep(){
    // 有人表示手放在了方向盘,则不鸣笛
    if (this.body_state != "无人" || parseFloat(this.IOT_temperature.replace("℃","")) > 100 || parseFloat(this.smoke.replace("ppm","")) > 100) {
      let cmmon = CommandFactory.createBeepCommand(ON_OFF.on)
      IotDataTool.controlDevice(cmmon)
    }else {
      let cmmon = CommandFactory.createBeepCommand(ON_OFF.off)
      IotDataTool.controlDevice(cmmon)
    }
  }
  //时间转换
  number2time(number: number) {
    return number > 60 * 1000 ? Math.floor(number/1000/60).toString().padStart(2, '0') + ':' + Math.floor(number/1000%60).toString().padStart(2, '0') : '00:' + Math.floor(number/1000%60).toString().padStart(2, '0')
  }

  aboutToAppear(): void {
    const totalMileage = PreferencesUtil.get('TotalMileage', 0) as number
    this.milometer = totalMileage
    this.selectedDrivingMode = PreferencesUtil.get('selectedMode', 0) as number
    IotDataTool.login()
    IotDataTool.setLatestData()
    this.temp=IotDataTool.responseData?.shadow?.[0]?.reported?.properties?.temp

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

  navigateToMusic() {
    router.pushUrl({ url: 'pages/MusicPage/pages/Index' });
  }

  navigateToSettings() {
    router.pushUrl({ url: 'pages/SettingPage/PersonalizationSettings' });
  }
  // navigateToMap(){
  //   router.pushUrl({ url: 'pages/MapPage/Map' });
  // }

  private getWeatherIcon(): ResourceStr {
    //根据天气类型返回不同的图标
    if (this.weather.includes('雪')) {
      return $r('app.media.snow');
    } else if (this.weather.includes('晴')) {
      return $r('app.media.sunny');
    } else if (this.weather.includes('阴')) {
      return $r('app.media.overcast');
    } else if (this.weather.includes('多云')) {
      return $r('app.media.cloudy');
    } else if (this.weather.includes('雨')) {
      return $r('app.media.rainy');
    }
    return $r('app.media.weather'); //默认天气图标
  }
  build() {
    Column() {
      Header({currentTheme: this.currentTheme})

      List({ space: 20 }) {

        ListItem() {

          Column({ space: 20 }) {

            Column({ space: 10 }){
              Text('车机状态')
                .fontColor(this.currentTheme.textColor)
                .fontSize(this.fontSize+2)
                .fontWeight(FontWeight.Bold)
                .align(Alignment.Start)
                .width('100%')
                .margin({ top: 8 })

              Column({space:30}){
                Text("车辆附件监测:"+this.body_state)
                Text("车内光照强度:"+this.illumination)
                Text("车厢电机温度:"+this.IOT_temperature)
                Text("车内烟雾浓度:"+this.smoke)
              }.width('100%').height('50%')
              .margin({
                left:"8%"
              })
              .justifyContent(FlexAlign.Start)
              .alignItems(HorizontalAlign.Start)

              Column({ space: 10 }) {
                Text(this.location)
                  .fontColor(this.currentTheme.textColor)
                  .fontSize(this.fontSize)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .align(Alignment.Start)
                  .width('100%');

                // Text('距离目标位置')
                //   .fontColor(this.currentTheme.textColor)
                //   .fontSize(this.fontSize-2)

                // Text(this.distance)
                //   .fontColor(this.currentTheme.textColor)
                //   .fontSize(this.fontSize+5)
                //   .fontWeight(FontWeight.Bold)
                //   .textAlign(TextAlign.Center)
                //   .align(Alignment.Start)
                //   .width('100%');
              }
            }
            // .onClick(() => {
            //   this.navigateToMap()
            // })
            .CardStyle()
            .justifyContent(FlexAlign.SpaceBetween)
            .layoutWeight(1)
            .padding(10)

          }
          .width("31%")
          .height('90%')
          .margin({ left:12 })
        }

        ListItem() {
          Column({ space: 20 }) {
            //仪表盘数据展示
            Column({ space: 10 }) {
              Text('仪表盘')
                .fontColor(this.currentTheme.textColor)
                .fontSize(this.fontSize+2)
                .fontWeight(FontWeight.Bold)
                .align(Alignment.Start)
                .width('100%')
                .margin({ top: 8 })

              Stack() {
                Image($r('app.media.road'))
                  .width("100%")
                  .height( "55%")

                Image($r('app.media.car2'))
                  .width("78%")
                  .offset({ y: -15 })
              }
              .width('100%')
              .height("80%")
              .borderRadius(10)
            }
            .CardStyle()
            .justifyContent(FlexAlign.SpaceBetween)
            .layoutWeight(1)
            .onClick(() => {
              this.navigateToDashboard();
            })

          }
          .width("31%")
          .height('90%')
        }

        ListItem() {

          Column() {

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
                .height("25%")
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
                .height("16%")
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
                .height("16%")
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .borderRadius(10)
              }
              .width("100%")
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .CardStyle()
            .padding(10)
            .margin({ bottom: 10 })
            .onClick(() => {
              this.navigateToSettings();
            })

            //天气信息
            Column() {
              Stack() {

                if (this.weather.includes('雪')) {
                  //循环创建30个雪花
                  ForEach(Array.from({length: 30}), (item: undefined, index: number) => {
                    Snow()
                      .position({
                        x: Math.random() * 100 + '%', //水平随机位置（容器宽度的0%-100%）
                        y: Math.random() * 100 + '%'   //垂直随机位置（容器高度的0%-100%
                      })
                  })
                } else if (this.weather.includes('雨')) {
                  //循环创建50个雨滴
                  ForEach(Array.from({length: 50}), (item: undefined, index: number) => {
                    Rain()
                      .position({
                        x: Math.random() * 100 + '%',
                        y: Math.random() * 100 + '%'
                      })
                  })
                }

                Row({ space: 8 }) {
                  Column({ space: 8 }) {
                    Text(this.area)
                      .fontColor(this.currentTheme.textColor)
                      .fontSize(this.fontSize+2)
                    Text(`${this.temperature}℃`)
                      .fontColor(this.currentTheme.textColor)
                      .fontSize(this.fontSize+12)
                      .fontWeight(FontWeight.Bold)
                    Text(this.weather)
                      .fontColor(this.currentTheme.textColor)
                      .fontSize(this.fontSize+2)
                  }
                  Image(this.getWeatherIcon())
                    .fillColor(this.currentTheme.iconColor)
                    .width("40%")
                }
                .width('100%')
                .height('100%')
              }
              .width('100%')
              .height('100%')
            }
            .CardStyle()
            .justifyContent(FlexAlign.SpaceAround)
            .layoutWeight(1)
            .clip(true)
          }
          .width("31%")
          .height('90%')
        }

      }
      .listDirection(Axis.Horizontal)
      .layoutWeight(1)
      .alignListItem(ListItemAlign.Center)
      .width('100%')
      .height('100%')
      .padding(5)

      Row(){
        Row() {

          Column() {
            Row({space:4}) {
              Text(this.currentSong.title)
                .fontSize(this.fontSize)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.currentTheme.textColor)
              Text('-')
                .fontSize(this.fontSize)
                .fontColor(this.currentTheme.textColor)
              Text(this.currentSong.singer)
                .fontSize(this.fontSize)
                .fontColor(this.currentTheme.textColor)
            }
            .width('100%')
            .height('100%')
          }
          .width('20%')
          .height('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems( HorizontalAlign.Center)
          .onClick(() => {
            this.navigateToMusic();
          })

          Column() {
            Row({space:20}) {
              Row({space: 50}){
                Image($r('app.media.ic_prev'))
                  .width(30)
                  .height(30)
                  .fillColor(this.currentTheme.iconColor)
                  .onClick(() => {
                    playerManager.prev()
                  })

                Image(this.isPlaying ? $r('app.media.ic_play') : $r('app.media.ic_pause'))
                  .width(30)
                  .height(30)
                  .onClick(() => {
                    this.isPlaying = !this.isPlaying;
                    if (this.isPlaying) {
                      playerManager.play()
                    } else {
                      playerManager.paused()
                    }
                  });

                Image($r('app.media.ic_next'))
                  .width(30)
                  .height(30)
                  .fillColor(this.currentTheme.iconColor)
                  .onClick(() => {
                    playerManager.next()
                  })
              }

              Blank()

              Text(`${this.number2time(this.currentSong.time)} / ${this.number2time(this.currentSong.duration)}`)
                .fontColor(this.currentTheme.textColor)
            }
            .padding({ left: 155, right: 50 })
            .width('100%')
            .justifyContent(FlexAlign.Center)

            Slider({
              value: this.currentSong.time,
              min: 0,
              max: this.currentSong.duration,
              style: SliderStyle.OutSet
            })
              .blockColor('#ff1948')
              .selectedColor('#ff1948')
              .trackThickness(6)
              .width('90%')
              .onChange((value) => {
                playerManager.skip(value)
              })
          }
          .width('70%')
          .height('100%')
          .justifyContent(FlexAlign.Center);

        }
        .width('100%')
      }
      .CardStyle()
      .margin({bottom:10})
      .width('97%')
      .height('15%')

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
    .borderRadius(25)
  }
}
