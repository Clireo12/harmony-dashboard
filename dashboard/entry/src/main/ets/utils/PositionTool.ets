import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { abilityAccessCtrl, Context, PermissionRequestResult, common } from '@kit.AbilityKit';
import { http } from '@kit.NetworkKit';
import connection from '@ohos.net.connection';


interface ReverseGeoCodeRequest {
  locale?: string;  // 指定位置描述信息的语言，“zh”代表中文，“en”代表英文。默认值从设置中的“语言和地区”获取。
  country?:string;  // 限制查询结果在指定的国家内，采用ISO 3166-1 alpha-2 。“CN”代表中国。默认值从设置中的“语言和地区”获取。
  maxItems: number; // 指定返回位置信息的最大个数。取值范围为大于等于0，推荐该值小于10。
  longitude:number  // 表示经度信息，正值表示东经，负值表示西经。取值范围为-180到180。仅支持WGS84坐标系
  latitude:number   // 表示纬度信息，正值表示北纬，负值表示南纬。取值范围为-90到90。仅支持WGS84坐标系
}


class PositionTool{

  // 经度
  public longitude:number = 116.5;
  // 纬度
  public latitude:number = 39.0;
  // 所在地城市
  public city:string = "北京";

  // 获取系统当前所在经纬度
  public setPositionByWLAN(){

    // 动态权限申请
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let context: Context = getContext(this) as common.UIAbilityContext;
    atManager.requestPermissionsFromUser(context, ['ohos.permission.LOCATION','ohos.permission.APPROXIMATELY_LOCATION'], (err: BusinessError, data: PermissionRequestResult) => {
      if (err) {
        console.error(`requestPermissionsFromUser fail, err->${JSON.stringify(err)}`);
      } else {
        console.info('data:' + JSON.stringify(data));
        console.info('data permissions:' + data.permissions);
        console.info('data authResults:' + data.authResults);
        console.info('data dialogShownResults:' + data.dialogShownResults);
      }
    });

    let request: geoLocationManager.SingleLocationRequest = {
      locatingPriority: geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED, // 优先定位速度
      locatingTimeoutMs: 10000  // 设置超时时间
    };
    // 获取的结果是WGS84坐标系经纬度
    geoLocationManager.getCurrentLocation(request).then((location: geoLocationManager.Location) => {
      // Receive the reported location through the promise.
      hilog.info(0x0000, "PositionTool", `getCurrentLocationPosition success, latitude: ${location.latitude}, longitude: ${location.longitude}`)
      this.latitude = location.latitude;
      this.longitude = location.longitude;
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, "PositionTool", `getCurrentLocationPosition failed, code: ${err.code}, message: ${err.message}`);
    });
  }
  public getPosition():number[]{
    // 获取系统当前所在经纬度
    this.setPositionByWLAN();
    return [this.longitude,this.latitude];
  }

  getCity():string{
    hilog.info(0x0000, "PositionTool", `getCity start`)
    try {
      //判断地理编码与逆地理编码服务状态
      let Result = geoLocationManager.isGeocoderAvailable()
      if (!Result) {
        hilog.info(0x0000, "PositionTool", `getCity error: 地理编码与逆地理编码服务不可用!`)
        return "地理编码与逆地理编码服务不可用!"
      }
    }catch (err) {
      console.error("errCode:" + JSON.stringify(err));
      hilog.error(0x0000, "PositionTool", `isGeocoderAvailable error: ${err}`)
    }


    let request: ReverseGeoCodeRequest = {
      maxItems: 10,
      longitude: this.longitude,
      latitude: this.latitude
    }
    try {
      geoLocationManager.getAddressesFromLocation(request, (err, data) => {
        if (err) {
          console.log('getAddressesFromLocation err: ' + JSON.stringify(err));
          hilog.error(0x0000, "PositionTool", `getAddressesFromLocation error: ${err}`)
        } else {
          console.log('getAddressesFromLocation data: ' + JSON.stringify(data));
          hilog.info(0x0000, "PositionTool", `getAddressesFromLocation data: ${data}`)
        }
      });
    } catch (err) {
      console.error("errCode:" + JSON.stringify(err));
      hilog.error(0x0000, "PositionTool", `getAddressesFromLocation error: ${err}`)
    }

    return "";
  }

}
export default new PositionTool();