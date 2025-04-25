import { preferences, ValueType } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';


/*
  第一步
  aboutToAppear() {
    // 初始化时根据里程计算进度
    PreferencesUtil.Load()
    // 读取总里程
    this.activeTab = PreferencesUtil.get('drivingMode', 'D') as string

  }
  *
  *
  更改数据时,使用put方法
  PreferencesUtil.put('drivingMode', tabName)
 */





class PreferencesUtil {

  // 初始化的标识
  public state:boolean = false;
  // 首选项的名称
  public name:string = "myStore"
  // 使用之前必须初始化
  public pref:preferences.Preferences = {} as preferences.Preferences;

  private uiAbilityContext: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  private applicationContext = this.uiAbilityContext.getApplicationContext(); // 获取应用级上下文

  // 加载实例(初始化)
  Load(){
    if (this.state) {
      return
    }
    let options:preferences.Options = {name : this.name}
    this.pref = preferences.getPreferencesSync(this.applicationContext, options)
    this.state = true
  }


  // 修改键值对,若键不存在则创建
  put(key:string,value:ValueType){
    try {
      this.pref.putSync(key,value)
      console.log('put ok')
      this.pref.flushSync()
      console.log('flush ok')
    }catch (err) {
      console.log(err)
    }

  }

  // 获取键值对,若键不存在则返回默认值,第一个参数为键,第二个参数为默认值
  get(key:string,defaultValue:ValueType) : ValueType{
    // return new Promise((resolve, reject) => {
    //   let promise = this.pref.get(key, defaultValue);
    //   promise.then((data: preferences.ValueType) => {
    //     resolve(data as Promise<ValueType>)
    //     console.info("Succeeded in getting value of "+key+". Data: " + data);
    //   }).catch((err: BusinessError) => {
    //     reject(err)
    //     console.error("Failed to get value of "+key+". code =" + err.code + ", message =" + err.message);
    //   })
    // })
    try {
      return this.pref.getSync(key, defaultValue) as ValueType
    }
    catch (err) {
      console.log(err)
      return defaultValue

    }
  }

}
// 导出单例
export default new PreferencesUtil();