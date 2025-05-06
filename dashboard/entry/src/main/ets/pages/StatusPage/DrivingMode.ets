import { ThemeManager } from '../../model/ThemeManager';
import PositionTool from '../../utils/PositionTool';
import PreferencesUtil from '../../utils/PreferencesUtil';
import hilog from '@ohos.hilog';
import IotDataTool, { params, paras } from '../../utils/IotDataTool';

// 驾驶状态组件
@Component
export struct DrivingMode {
  private themeManager: ThemeManager = ThemeManager.getInstance();

  @State leftState:number = 1;
  @State left:string = "40%";
  uiContext: UIContext | undefined = undefined;
  @State DrivingMode: string[] = ['经济模式','运动模式','雪地模式','城市模式']
  private selectedMode:number|number[] = 1
  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
    // 初始化pref

    // 读取当前选中的模式
    this.selectedMode = PreferencesUtil.get('selectedMode', 0) as number
    console.log("selectedMode: " + this.selectedMode.toString())
  }

  build() {
    Column(){
      // 油门/刹车状态
      Column({ space:30 }){
        Text("油门/刹车状态")
          .fontSize(15)
          .fontColor(this.themeManager.getCurrentTheme().textColor)
          .backgroundColor(this.themeManager.getCurrentTheme().mask)
          .margin({
            top:10
          })
        Row(){
          // 状态切换显示按钮
          Row(){
            Row(){
              Text(this.leftState == 1 ? "刹车":"油门")
                .fontSize(18)
                .fontColor(this.themeManager.getCurrentTheme().textColor)
            }
            .shadow({ radius: 10, color: Color.Gray })
            .width("60%")
            .height("100%")
            .margin({
              left:this.left
            })
            .backgroundColor("#FF7500")
            .borderRadius(25)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              console.log("Clicked")

              try {
                // PositionTool.getPositionByWLAN()
              }catch (err) {
                hilog.error(0, '[Demo]', '[onClick]', 'getPositionByWLAN error: ' + err)
              }

              this.uiContext?.keyframeAnimateTo({ iterations: 1 }, [
                {
                  // 第一段关键帧动画时长为800ms，left属性做从0到40的动画
                  duration: 400,
                  event: () => {
                    if (this.leftState == 1) {
                      this.left = "0%"
                    }else {
                      this.left = "40%"
                    }
                    // console.log(this.left)
                  }
                },
              ]);
              this.leftState ^= 1
            })

          }
          .width("84%")
          .height("100%")
          .borderRadius(25)
          .backgroundColor("#0E62A9")
        }
        .justifyContent(FlexAlign.Center)
        .width("100%")
        .height("33%")
      }
      .width("100%")
      .height("45%")
      .borderRadius(15)
      .backgroundColor(this.themeManager.getCurrentTheme().mask)

      Row(){

      }
      .width("100%")
      .height("10%")

      // 驾驶模式
      Row(){
        Column(){
          Text("驾驶模式切换")
            .fontSize(15)
            .fontColor(this.themeManager.getCurrentTheme().textColor)
            .backgroundColor(this.themeManager.getCurrentTheme().mask)
            .margin({
              top: 10
            })

              TextPicker({range:this.DrivingMode, selected:this.selectedMode})
                // 选中的选项的字体样式
                .selectedTextStyle({
                  color: "#007CE6",
                  font: {
                    size: '28vp',
                    weight: FontWeight.Regular
                  }
                })
                // 未选中的选项的字体样式
                .textStyle({
                  color: "#0E62AA",
                  font: {
                    size: '18vp',
                    weight: FontWeight.Regular
                  }
                })
                // 取消Picker的分割线
                .divider(null)
                // 滑动该组件后触发回调函数, 获取当前选中的驾驶模式
                .onChange(async(value: string | string[], index: number | number[]) => {
                  console.info('Picker item changed, value: ' + value + ', index: ' + index)
                  this.selectedMode = index as number
                  PreferencesUtil.put('selectedMode', this.selectedMode)
                  console.info('selectedMode: ' + this.selectedMode)
                  // PositionTool.getCity()
                  IotDataTool.login()
                  let ml:paras = {
                    beep_state:"off"
                  }
                  let com:params = {
                    service_id: "test_1",
                    command_name: "beep",
                    paras: ml
                  }
                  IotDataTool.controlDevice(com)
                  try {
                    // PositionTool.getPositionByWLAN()

                  }catch (err) {
                    hilog.error(0, '[Demo]', '[onClick]', 'getPositionByWLAN error: ' + err)
                  }
                })
            .width("100%")
            .height("80%")

        }
        .width("100%")
        .height("100%")
        .borderRadius(15)
        .backgroundColor(this.themeManager.getCurrentTheme().mask)
      }
      .width("100%")
      .height("45%")
      .justifyContent(FlexAlign.Center)
    }
    .justifyContent(FlexAlign.SpaceBetween)
  }

}



