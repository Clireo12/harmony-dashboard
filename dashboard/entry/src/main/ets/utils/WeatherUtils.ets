// 引入
import { weatherService } from '@kit.WeatherServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';

@Entry
struct WeatherUtils {
  build() {
    Button('click')
      .onClick(() => {
        getData()
      })
  }
}

async function getData() {
  let httpRequest = http.createHttp();
  httpRequest.request(
    'https://www.apiopen.top/weatherApi?city=shenzhen',
    {
      method:http.RequestMethod.GET,
    }
  )
    .then(resp=>{
      console.log("resp=>",JSON.stringify(resp))
      if(resp.responseCode === 200){
        console.log(resp.result.toString())
      }
    })
}