import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { weatherService } from '@kit.WeatherServiceKit';
import { ThemeConfig } from '../model/ThemeConfig';
import PreferencesUtil from '../utils/PreferencesUtil';
import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';


@Component
export struct Header {
  @Link currentTheme: ThemeConfig
  @State date: Date = new Date()
  @State time: string = ''
  @State timeState: string = ''
  @Prop temperature: number = 23.5
  @Prop TotalMileage: number = 2800
  @State timer: number = -1
  @State textColor:Resource = $r("app.color.text_color")
  private  latitude:number = 0;   // 经度
  private  longitude:number = 0;  // 纬度

  /**
   * 组件生命周期 - 即将出现时调用
   */
  async aboutToAppear() {
    const timeDesc: string[] = ['上午', '中午', '下午']

    // 加载用户首选项实例

    console.log('Load ok')
    this.TotalMileage = PreferencesUtil.get('TotalMileage', 0) as number

    // 初始化变量
    this.timer = setInterval(() => {
      this.date = new Date()
      this.time = this.date.toTimeString().split(' ')[0]
      this.timeState = timeDesc[Math.floor(parseInt(this.time.split(':')[0]) / 8)]
    }, 1000)


    // 初始化经纬度
    geoLocationManager.getCurrentLocation().then((result) => {
      console.info('current location latitude: ' + result.latitude);
      console.info('current location longitude: ' + result.longitude);
      this.latitude = result.latitude
      this.longitude = result.longitude
    }).catch((err: BusinessError ) => {
      console.error(`getCurrentLocation failed. Code: ${err.code}, message: ${err.message}`);
    });
  }

  /**
   * 组件生命周期 - 即将退出时调用
   */
  aboutToDisappear() {
    console.log('aboutToDisappear')
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  build() {
    Row(){
      Row({ space: 40 }){
        Row({ space: 10 }) {
          Text(this.timeState)
            .fontSize(20)
            .fontColor(this.currentTheme.textColor)
          Text(this.time)
            .fontSize(20)
            .fontColor(this.currentTheme.textColor)
        }

        Row({ space: 10 }) {
          Image($r('app.media.sun_right'))
            .fillColor(this.currentTheme.textColor)
            .width(22)
          Text(`${this.temperature}℃`)
            .fontSize(20)
            .fontColor(this.currentTheme.textColor)
        }
      }
      .width(200)

      Row({ space: 10 }){
        Button(){
          Text('<')
            .fontColor(this.currentTheme.textColor)
        }
        .backgroundColor(this.currentTheme.theme)

        Image($r('app.media.leaf'))
          .fillColor(this.currentTheme.textColor)
          .width(25)
        Text('ECO')
          .fontColor(this.currentTheme.textColor)
        Button(){
          Text(">")
            .fontColor(this.currentTheme.textColor)
        }
        .backgroundColor(Color.Transparent)
        .margin({
          right:20
        })

        Image(this.timeState == '下午' ? $r('app.media.daohang_black'):$r('app.media.daohang_white'))
          .width(30)
          .offset({ y: -5 })

        Text("东南")
          .fontColor(this.currentTheme.textColor)
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      Row({ space: 10 }){
        Text('总里程')
          .fontSize(20)
          .fontColor(this.currentTheme.textColor)
        Text(`${this.TotalMileage} km`)
          .fontSize(20)
          .fontColor(this.currentTheme.textColor)

      }
      .width(200)
      .justifyContent(FlexAlign.End)
    }
    .padding({ left: 50, right: 50 })
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(this.currentTheme.theme)
  }
}
