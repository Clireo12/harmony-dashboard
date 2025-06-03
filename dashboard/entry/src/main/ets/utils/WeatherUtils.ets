// // 引入
// import { weatherService } from '@kit.WeatherServiceKit';
// import { BusinessError } from '@kit.BasicServicesKit';
// import { http } from '@kit.NetworkKit';
//
// @Entry
// struct WeatherUtils {
//   build() {
//     Button('click')
//       .onClick(() => {
//         getData()
//       })
//   }
// }
//
// async function getData() {
//   let httpRequest = http.createHttp();
//   httpRequest.request(
//     'https://www.apiopen.top/weatherApi?city=shenzhen',
//     {
//       method:http.RequestMethod.GET,
//     }
//   )
//     .then(resp=>{
//       console.log("resp=>",JSON.stringify(resp))
//       if(resp.responseCode === 200){
//         console.log(resp.result.toString())
//       }
//     })
// }

import IoTDataTool from '../utils/IotDataTool'
import { http } from '@kit.NetworkKit';
import { ValueType } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 高德地图API的密钥和URL
 */
const KEY = "f58b11539684019487562a7c44abbe0f"
const BASEURL = "https://restapi.amap.com/v3/geocode/regeo?"


/**
 * 高德地图逆地理编码API返回的数据结构
 */
export interface AMapRegeocodeResponse {
  status: string;           // 状态码，"1"表示成功
  regeocode: Regeocode;     // 逆地理编码结果
  info: string;             // 状态信息
  infocode: string;         // 状态码详情
}

/**
 * 逆地理编码结果
 */
interface Regeocode {
  addressComponent: AddressComponent;  // 地址组件
  formatted_address: string;           // 格式化的完整地址
}

/**
 * 地址组件
 */
interface AddressComponent {
  city: string;               // 城市名称
  province: string;             // 省份名称
  adcode: string;               // 行政区划代码
  district: string;             // 区县名称
  towncode: string;             // 乡镇街道代码
  streetNumber: StreetNumber;   // 街道和门牌号信息
  country: string;              // 国家
  township: string;             // 乡镇街道名称
  businessAreas?: BusinessArea[][] | null; // 商圈信息
  building: Building;           // 建筑信息
  neighborhood: Neighborhood;   // 社区信息
  citycode: string;             // 城市编码
}

/**
 * 街道和门牌号信息
 */
interface StreetNumber {
  number: string;       // 门牌号
  location: string;     // 经纬度坐标
  direction: string;    // 方向
  distance: string;     // 距离
  street: string;       // 街道名称
}

/**
 * 商圈信息
 */
interface BusinessArea {
  location?: string;     // 经纬度坐标
  name?: string;         // 商圈名称
  id?: string;           // 商圈ID
}

/**
 * 建筑信息
 */
interface Building {
  name: ValueType[];          // 建筑名称
  type: ValueType[];          // 建筑类型
}

/**
 * 社区信息
 */
interface Neighborhood {
  name: ValueType[];          // 社区名称
  type: ValueType[];          // 社区类型
}

// 天气信息接口定义
/** 实时天气信息 */
interface RealtimeWeather {
  temperature: string; // 温度
  humidity: string;    // 湿度
  info: string;        // 天气状况描述
  wid: string;         // 天气状况代码
  direct: string;      // 风向
  power: string;       // 风力
  aqi: string;         // 空气质量指数
}

/** 每日天气预报中的天气代码（白天/夜间） */
interface WeatherId {
  day: string;   // 白天天气代码
  night: string; // 夜间天气代码
}

/** 未来天气预报项 */
interface ForecastItem {
  date: string;       // 日期 (YYYY-MM-DD)
  temperature: string; // 温度范围
  weather: string;    // 天气状况描述
  wid: WeatherId;     // 天气状况代码
  direct: string;     // 风向
}

/** 天气数据结果 */
interface WeatherResult {
  city: string;        // 城市名称
  realtime: RealtimeWeather; // 实时天气
  future: ForecastItem[];    // 未来天气预报列表
}

/** API 响应结构 */
interface WeatherResponse {
  reason: string;      // 请求结果描述
  result: WeatherResult; // 天气数据
  error_code: number;  // 错误码 (0表示成功)
}

class WeatherUtils {
  public latitude:string = "23.5";
  public longitude:string = "114.0579";

  public wea_api:string = "http://apis.juhe.cn/simpleWeather/query"
  public wea_key:string = "14c9e39412a214e7bf69faf49eadb235"


  // 天气数据
  public temperature:string = ""    // 温度

  // 城市数据
  public city:string = "深圳"
  public district:string = ""       // 区县名称
  public township:string = ""       // 路

  async getCity(): Promise<ValueType> {
    let httpRequest = http.createHttp();
    this.latitude = IoTDataTool.latitude
    this.longitude = IoTDataTool.longitude
    const url = BASEURL + "location=" + this.longitude + "," + this.latitude + "&key=" + KEY;
    console.log("location:",this.latitude)
    console.log("location:",this.longitude)
    return new Promise((resolve, reject) => {
      httpRequest.request(url, {
        method: http.RequestMethod.GET,
      })
        .then(resp => {
          if (resp.responseCode === 200) {
            try {
              // **关键修复：将JSON字符串解析为对象**
              const result = JSON.parse(resp.result.toString()) as AMapRegeocodeResponse;


              // 提取城市名称（从 addressComponent.city 中获取）
              const cityName = result.regeocode.addressComponent.city || "广州";
              const district = result.regeocode.addressComponent.district || "白云区";
              const township = result.regeocode.addressComponent.township || "太和兴太三路";
              AppStorage.setOrCreate("city", cityName)
              AppStorage.setOrCreate("district", district)
              AppStorage.setOrCreate("township", township)
              console.log("提取的城市名称:", cityName); // 应输出 "深圳市"
              // 更新系统所在城市
              this.city = cityName;

              console.log("更新系统所在城市:", this.city)
              resolve(cityName); // 返回城市名称
            } catch (e) {
              console.error("JSON解析失败:", e);
              reject(e);
            }
          } else {
            console.error("HTTP请求失败，状态码:", resp.responseCode);
            reject(new Error(`HTTP状态码：${resp.responseCode}`));
          }
        })
        .catch((e:BusinessError) => {
          console.error("HTTP请求失败:", e);
          reject(e);
        })
        .finally(() => {
          httpRequest.destroy();
        })
    });
  }

  async getTemperature(): Promise<ValueType>{
    return new Promise(async (resolve, reject) => {
      let httpRequest = http.createHttp();
      httpRequest.request(this.wea_api,  {
        method: http.RequestMethod.GET,
        extraData:{
          "key": this.wea_key,
          "city": this.city
        }
      })
        .then(resp => {
          console.log("resp=>",JSON.parse(JSON.stringify(resp.result)).toString())
          if (resp.responseCode == 200) {
            let weather = JSON.parse(resp.result.toString()) as WeatherResponse;

            this.temperature = weather?.result?.realtime?.temperature;
            AppStorage.setOrCreate("temperature", this.temperature || "26")
            console.log("temperature",this.temperature)
          }
        })
        .catch((e:BusinessError) => {
          console.log("error=>",e)
        })
        .finally(() => {
          httpRequest.destroy();
        })
    });
  }


}
export default new WeatherUtils()