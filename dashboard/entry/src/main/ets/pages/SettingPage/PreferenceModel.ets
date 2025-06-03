import { ThemeManager } from '../../model/ThemeManager';
// import IotDataTool, { params, paras } from '../../utils/IotDataTool';
import PreferencesUtil from '../../utils/PreferencesUtil';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { ThemeConfig } from '../../model/ThemeConfig';

// 偏好设置组件
@Component
export struct PreferenceModel {
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()
  uiContext: UIContext | undefined = undefined;
  @State DrivingMode: string[] = ['转向灯提示音','驾驶模式切换音效','故障报警语音播报','仪表盘动画速度','方言识别模式','盲区监测提示','语音反馈模式']
  private selectedMode:number|number[] = 1

  private intervalId: number = 0
  aboutToAppear() {
    this.uiContext = this.getUIContext?.();

    //读取当前选中的模式
    this.selectedMode = PreferencesUtil.get('selectedMode', 0) as number
    console.log("selectedMode: " + this.selectedMode.toString())
  }
  aboutToDisappear(): void {
    clearInterval(this.intervalId)
  }

  build() {
    Row() {
      Column(){
        Text('偏好设置')
          .margin({ top: 20})
          .fontSize(20)
          .fontColor(this.currentTheme.textColor)
          .textAlign(TextAlign.Center)

        Row(){
          //空的占位
        }
        .margin(20)

        TextPicker({range:this.DrivingMode, selected:this.selectedMode})
          .width('100%')
          // 选中的选项的字体样式
          .selectedTextStyle({
            color: "#007CE6",
            font: {
              size: '16vp',
              weight: FontWeight.Bold
            }
          })
            // 未选中的选项的字体样式
          .textStyle({
            color: "#0E62AA",
            font: {
              size: '12vp',
              weight: FontWeight.Regular
            }
          })
            // 取消Picker的分割线
          .divider(null)
            // 滑动该组件后触发回调函数, 获取当前选中的偏好设置模式
          .onChange(async(value: string | string[], index: number | number[]) => {
            console.info('Picker item changed, value: ' + value + ', index: ' + index)
            this.selectedMode = index as number
            PreferencesUtil.put('selectedMode', this.selectedMode)
            console.info('selectedMode: ' + this.selectedMode)
            // IotDataTool.login()
            // IotDataTool.setLatestData()
            // let ml:paras = {
            //   beep_state:"off"
            // }
            // let com:params = {
            //   service_id: "test_1",
            //   command_name: "beep",
            //   paras: ml
            // }
            // IotDataTool.controlDevice(com)
            try {
            }catch (err) {
              hilog.error(0, '[Demo]', '[onClick]', 'getPositionByWLAN error: ' + err)
            }
          })
          .width("100%")
          .height("auto")
      }
    }
    .width("100%")
    .height("45%")
  }
}