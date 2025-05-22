import { http } from "@kit.NetworkKit"
import { CommonConstant } from "../component/canshu"
import { hilog } from "@kit.PerformanceAnalysisKit"
import { BusinessError } from "@kit.BasicServicesKit"

const TAG = "HTTP"


export interface notify_data {
  device_id: string;
  shadow: shadow[]; // 直接使用数组类型
}

interface reported {
  properties: properties;
  event_time: string;
}

interface desired {
  properties: properties | null;
  event_time: string | null;
}

export interface shadow {
  service_id: string;
  desired: desired;
  reported: reported;
  version: number;
}

// 若设备发生改动,此处需要同步修改
export interface properties {
  temp: string;                   // 温度
  smoke: string;                  // 烟雾
  body_state: string;             // 人体传感
  alarm_light_state: string;      // 报警灯
  beep_state: string;             // 蜂鸣器
  auto_state: string;
  illumination: string;
  temperature: string;
  humidity: string;
  motorStatus: string;            // 电机
  lightStatus: string;            // 灯光
  keyStatus:string;
  mpu_1:string;
  mpu_2:string;
  mpu_3:string;
  gear_state:string;              // 挡位
  color_theme_state:string;
}

export interface params{
  service_id: string;
  command_name: string;
  paras:paras;
}

export interface paras{
  alarm_light_state?:string;   // 报警灯on,off
  beep_state?:string;          // 蜂鸣器on,off
}

// 获取数据示例
// this.responseData?.shadow?.[0]?.reported?.properties?.smoke
// this.responseData?.shadow?.[0]?.reported?.properties?这段是固定的


@Observed
class IotDataTool{
  public token:string = ""
  public responseData:notify_data = {} as notify_data
  private timerId: number = -1; // 定时器ID
  public pollingInterval:number = 1500; // 轮询间隔，单位为毫秒

  // 设备数据
  public motorStatus:string  = "";  // 电机
  public lightStatus:string  = "";  // 灯光
  public mpu_1:string = "";
  public gear_state:string = "";    // 挡位

  // 登录方法,获取后续操作的token
  login(): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request("https://iam.cn-north-4.myhuaweicloud.com/v3/auth/tokens", {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: {
          "auth": {
            "identity": {
              "methods": [
                "password"
              ],
              "password": {
                "user": {
                  "name": CommonConstant.IAM_USERNAME,
                  "password": CommonConstant.IAM_PASSWORD,
                  "domain": {
                    "name": CommonConstant.DOMAIN_USERNAME
                  }
                }
              }

            },
            "scope": {
              "domain": {
                "name": CommonConstant.DOMAIN_USERNAME
              }
            }
          }
        }
      })
        .then((data: http.HttpResponse) => {
          if (data.responseCode === 201) {
            //拿到token，并保存起来
            this.token = data.header['x-subject-token']
            // console.info(TAG, "token=" + this.token)
            CommonConstant.token = this.token
            hilog.info(0x00, "test", "拿到token")
            resolve(this.token)
          } else {
            reject("请求失败")
          }
        })
        .catch((err: BusinessError) => {
          // 错误处理，通过catch块，捕获error，并对error进行处理，本示例中会将错误信息展现到打印台上。
          console.error(`Response err: Code is ${JSON.stringify(err.code)}, message is ${JSON.stringify(err)}`);
        })
        .finally(() => {
          httpRequest.destroy()
        })
    })
  }

  // 更新所有设备最新数据
  setLatestData(): Promise<string> {
    console.log("getLatestData")
    return new Promise<string>((resolve, reject) => {

      let httpRequest: http.HttpRequest = http.createHttp()

      let options: http.HttpRequestOptions = {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json',
          'X-Auth-Token': this.token == "" ? CommonConstant.token : this.token,
        },
        expectDataType: http.HttpDataType.OBJECT, //可选，指定返回数据的类型
      }
      console.log("发起请求")
      console.log(CommonConstant.token)
      httpRequest.request(`https://${CommonConstant.IAM_ENDPOINT}/v5/iot/${CommonConstant.project_id}/devices/${CommonConstant.device_id}/shadow`,
        options)
        .then((data) => {
          console.log("HTTP", "data=" + JSON.stringify(data))
          if (data.responseCode === 200) {

            let result = JSON.stringify(data.result)
            console.log("HTTP", "data=" + result)
            // console.log("正在解析中")

            this.responseData = data.result as notify_data // 直接类型断言
            this.motorStatus = this.responseData?.shadow?.[0]?.reported?.properties?.motorStatus
            this.lightStatus = this.responseData?.shadow?.[0]?.reported?.properties?.lightStatus
            this.mpu_1 = this.responseData?.shadow?.[0]?.reported?.properties?.mpu_1
            this.gear_state = this.responseData?.shadow?.[0]?.reported?.properties?.gear_state
            hilog.info(0x00, "DATA", `${this.mpu_1}`)

            // console.log("smoke = " + this.responseData?.shadow?.[0]?.reported?.properties?.smoke)
            //
            // console.info("HTTP", "设备最新数据=" + data.result)
            // resolve(result)
          } else {
            reject("请求失败")
          }
        }).catch((err: BusinessError) => {
        console.info(TAG, JSON.stringify(err))
        console.info("HTTP", "请求失败")
        reject("网络请求失败")
      }).finally(() => {
        console.info("HTTP", "请求结束")
        httpRequest.destroy()
      })
    })
  }

  // 控制设备
  controlDevice(params:params):Promise<string> {
    return new Promise<string>((resolve, reject) => {

      let httpRequest: http.HttpRequest = http.createHttp()
      let options: http.HttpRequestOptions = {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'X-Auth-Token': this.token == "" ? CommonConstant.token : this.token,
          'Instance-Id': CommonConstant.INSTANCE_ID
        },
        expectDataType: http.HttpDataType.OBJECT, //可选，指定返回数据的类型
        extraData:params
      }
      console.log("正在发送命令")
      httpRequest.request(`https://${CommonConstant.IAM_ENDPOINT}/v5/iot/${CommonConstant.project_id}/devices/${CommonConstant.device_id}/commands`,options)
        .then((data) => {
          console.log("HTTP", "data=" + JSON.stringify(data))
          if(data.responseCode===200&&data.result.toString().includes("command_id")) {
            console.info(TAG,"控制设备="+"控制成功")
            resolve("控制成功")
          }else{
            reject("操作失败")
          }
        })
        .catch((err: BusinessError) => {
          console.info(TAG,JSON.stringify(err))
          reject("网络请求失败")
        })
        .finally(() => {
          httpRequest.destroy()
        })
    })
  }


  // 启动轮询
  public startPolling(): void {
    // 若轮询已启动，则先停止它
    this.stopPolling();
    this.timerId = setInterval(() => {
      if (this.token == "") {
        this.login()
      }else {
        this.setLatestData()
      }
    },this.pollingInterval)

  }

  // 停止轮询
  public stopPolling(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

}

export default new IotDataTool();