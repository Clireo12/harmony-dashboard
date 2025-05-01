import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { abilityAccessCtrl, Context, PermissionRequestResult, common } from '@kit.AbilityKit';
import { http } from '@kit.NetworkKit';
import connection from '@ohos.net.connection';
class PositionTool{

  // 经度
  public longitude:number = 0;
  // 纬度
  public latitude:number = 0;
  // 所在地城市
  public city:string = "北京";


  // 获取系统当前所在经纬度
  public getPositionByWLAN(){

    //
    // let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    // let context: Context = getContext(this) as common.UIAbilityContext;
    // atManager.requestPermissionsFromUser(context, ['ohos.permission.LOCATION','ohos.permission.APPROXIMATELY_LOCATION'], (err: BusinessError, data: PermissionRequestResult) => {
    //   if (err) {
    //     console.error(`requestPermissionsFromUser fail, err->${JSON.stringify(err)}`);
    //   } else {
    //     console.info('data:' + JSON.stringify(data));
    //     console.info('data permissions:' + data.permissions);
    //     console.info('data authResults:' + data.authResults);
    //     console.info('data dialogShownResults:' + data.dialogShownResults);
    //   }
    // });
    //
    // let request: geoLocationManager.SingleLocationRequest = {
    //   locatingPriority: geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
    //   locatingTimeoutMs: 10000
    // };
    //
    // geoLocationManager.getCurrentLocation(request).then((location: geoLocationManager.Location) => {
    //   // Receive the reported location through the promise.
    //   hilog.info(0x0000, "PositionTool", `getCurrentLocationPosition success, latitude: ${location.latitude}, longitude: ${location.longitude}`)
    // }).catch((err: BusinessError) => {
    //   hilog.error(0x0000, "PositionTool", `getCurrentLocationPosition failed, code: ${err.code}, message: ${err.message}`);
    //   // ...
    // });
    let url = "https://apis.map.qq.com/ws/location/v1/ip"
    let ip = ""
    // 获取所有网络接口信息
    connection.getAddressesByName

    const httpRequest =http.createHttp();
    let promise = httpRequest.request(url,{

    })
  }

}
export default new PositionTool();