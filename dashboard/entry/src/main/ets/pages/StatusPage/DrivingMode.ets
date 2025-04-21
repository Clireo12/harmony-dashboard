import { theme } from '../../Singleton/singleton';
import { Constants } from './Constants'

// 驾驶状态组件
@Component
export struct DrivingMode {
  @State _width:number|string = 300
  @State _height:number|string = 350
  @State leftState:number = 1;
  @State left:string = "40%";
  uiContext: UIContext | undefined = undefined;
  @State DrivingMode: string[] = ['经济模式','运动模式','雪地模式','城市模式']
  private selectedMode:number|number[] = 1
  @State Theme:theme = theme.getInstance()
  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
  }

  build() {
    Column(){
      // 油门/刹车状态
      Column({space:30}){
        Text("油门/刹车状态")
          .fontColor(this.Theme.textColor[this.Theme.modeList[this.Theme.mode]])
          .backgroundColor(this.Theme.ComponentBGColor[this.Theme.modeList[this.Theme.mode]])
          .margin({
            top:3
          })
        Row(){
          // 状态切换显示按钮
          Row(){
            Row(){
              Text(this.leftState == 1 ? "刹车":"油门")
                .fontColor(this.Theme.textColor[this.Theme.modeList[this.Theme.mode]])
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
          .width(200)
          .height(50)
          .borderRadius(25)
          .backgroundColor("#0E62A9")


        }
        .justifyContent(FlexAlign.Center)
        .width(Constants.HEAD_WEIGHT)
      }
      .width("98%")
      .height("45%")
      .borderRadius(15)
      .backgroundColor(this.Theme.ComponentBGColor[this.Theme.modeList[this.Theme.mode]])




      // 驾驶模式
      Row(){
        Column(){
          Text("驾驶模式切换")
            .fontColor(this.Theme.textColor[this.Theme.modeList[this.Theme.mode]])
            .backgroundColor(this.Theme.ComponentBGColor[this.Theme.modeList[this.Theme.mode]])
            .margin({
              top:3
            })

          TextPicker({range:this.DrivingMode, selected:1})
            // 选中的选项的字体样式
            .selectedTextStyle({
              color: "#007CE6",
              font: {
                size: '28fp',
                weight: FontWeight.Regular
              }
            })
            // 未选中的选项的字体样式
            .textStyle({
              color: "#0E62AA",
              font: {
                size: '18fp',
                weight: FontWeight.Regular
              }
            })
            // 取消Picker的分割线
            .divider(null)
            // 滑动该组件后触发回调函数, 获取当前选中的驾驶模式
            .onChange((value: string | string[], index: number | number[]) => {
              console.info('Picker item changed, value: ' + value + ', index: ' + index)
              this.selectedMode = index
            })
            .width("100%")
            .height("100%")

        }
        .width("98%")
        // .height("50%")
        .borderRadius(15)
        .backgroundColor(this.Theme.ComponentBGColor[this.Theme.modeList[this.Theme.mode]])

      }
      .width(Constants.HEAD_WEIGHT)
      .height("50%")
      .justifyContent(FlexAlign.Center)
    }
    .width(this._width)
    .height(this._height)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}



