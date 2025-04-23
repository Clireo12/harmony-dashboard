import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { weatherService } from '@kit.WeatherServiceKit';

@Component
export struct Header {
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

    let request: weatherService.WeatherRequest = {
      location: {
        latitude: this.latitude, // 使用实际获取的纬度
        longitude: this.longitude // 使用实际获取的经度
      },
      limitedDatasets: [weatherService.Dataset.CURRENT, weatherService.Dataset.ALERTS]
    };
    let weather = await weatherService.getWeather(request);
    if (weather.current) {
      console.info('getWeather current temperature: ' + weather.current.temperature);
      this.temperature = weather.current.temperature
    }
    if (weather.alerts?.length) {
      console.info('getWeather alert: ' + weather.alerts[0].title);
    }

  }

  /**
   * 组件生命周期 - 即将退出时调用
   */
  aboutToDisappear() {
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
            .fontColor(this.textColor)
          Text(this.time)
            .fontSize(20)
            .fontColor(this.textColor)
        }

        Row({ space: 10 }) {
          Image($r('app.media.sun_right'))
            .width(22)
          Text(`${this.temperature}℃`)
            .fontSize(20)
            .fontColor(this.textColor)
        }
      }
      .width(200)

      Row({ space: 10 }){
        Button(){
          Text('<')
            .fontColor(this.textColor)
        }
        .backgroundColor($r("app.color.start_window_background"))

        Image($r('app.media.leaf'))
          .width(25)
        Text('ECO')
          .fontColor(this.textColor)
        Button(){
          Text(">")
            .fontColor(this.textColor)
        }
        .backgroundColor(Color.Transparent)
        .margin({
          right:20
        })

        Image(this.timeState == '下午' ? $r('app.media.daohang_white') : $r('app.media.daohang_black'))
          .width(30)
          .offset({ y: -5 })

        Text("东南")
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      Row({ space: 10 }){
        Text('总里程')
          .fontSize(20)
          .fontColor(this.textColor)
        Text(`${this.TotalMileage} km`)
          .fontSize(20)
          .fontColor(this.textColor)
      }
      .width(200)
      .justifyContent(FlexAlign.End)
    }
    .padding({ left: 50, right: 50 })
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor($r("app.color.start_window_background")) // 后期需要根据时间,修改黑夜或白天模式
  }
}
