/*车辆状态监控界面，主要分为两大功能区域：
 *左侧：方向盘角度反馈区（实时显示方向盘转向角度）
 * 右侧：车辆自检功能区（展示自检进度、自检动画和各项子系统状态）
 * 自检动画：通过旋转圆圈和进度条展示自检进度
 * */

import { Header } from '../../component/Header'
import { SteeringWheelAngleFeedback } from './SteeringWheelAngleFeedback'
import { ThemeManager } from '../../model/ThemeManager'
import { ThemeConfig } from '../../model/ThemeConfig'
import IotDataTool from '../../utils/IotDataTool'
import { router } from '@kit.ArkUI'




@Entry
@Component
export struct VehicleStatusPage {
  //主题
  private themeManager: ThemeManager = ThemeManager.getInstance();
  @State currentTheme: ThemeConfig = this.themeManager.getCurrentTheme()

  @State rotateAngle: number = 0
  @State rotateAngle1: number = 0  //外层进度条旋转角度
  @State rotateAngle2: number = 0  //中层进度条旋转角度
  @State rotateAngle3: number = 0  //最内层圆圈
  @State progress: number = 0      //自检进度 (从0开始)
  @State currentAngle: number = 0  //动画当前角度
  @State @Watch("onTargetAngleChange") targetAngle: number = 0;  // 目标角度

  //定时器ID
  private timerId: number = -1;    // 角度动画定时器
  private dataPollTimer: number = -1; // 数据轮询定时器
  @Prop reverse: boolean = false  // 旋转方向控制

  //动画定时器
  private innerIntervalId: number = 0    // 内层圆圈动画
  private progressIntervalId: number = 0 // 进度条动画

  aboutToDisappear() {
    IotDataTool.login()
    this.stopAngleAnimation(); // 页面销毁时停止计时器
    clearInterval(this.dataPollTimer); //清除轮询定时器
    clearInterval(this.innerIntervalId);  //清除内层圆圈动画
    clearInterval(this.progressIntervalId);   //清除进度动画
  }

  onTargetAngleChange() {
    if (Math.abs(this.currentAngle - this.targetAngle) > 0.1) {
      this.startAngleAnimation();
    }
    console.log("角度变化了")
  }

  startAngleAnimation() {
    this.stopAngleAnimation();

    const startAngle = this.currentAngle;
    const angleDiff = this.targetAngle - startAngle;
    //角度归一化处理（处理360度边界情况）
    const normalizedDiff = ((angleDiff + 180) % 360) - 180;

    //角度变化过小则不执行动画
    if (Math.abs(normalizedDiff) < 0.1) {
      return;
    }

    //根据角度差计算动画持续时间
    const duration = Math.min(1500, Math.abs(normalizedDiff) * 20);
    const startTime = Date.now();
    const frameRate = 16;

    // 启动动画定时器
    this.timerId = setInterval(() => {
      try {
        const elapsed = Date.now() - startTime;
        const progress = Math.min(elapsed / duration, 1);
        // 使用缓动函数使动画更平滑
        const easedProgress = this.easeInOutQuad(progress);

        // 更新当前角度
        this.currentAngle = startAngle + (normalizedDiff * easedProgress);

        // 动画完成时清理
        if (progress >= 1) {
          this.currentAngle = this.targetAngle;
          this.stopAngleAnimation();
        }
      } catch (error) {
        this.stopAngleAnimation();
      }
    }, frameRate);
  }
  //缓动函数 (二次缓动)
  private easeInOutQuad(t: number): number {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }

  stopAngleAnimation() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  aboutToAppear() {
    IotDataTool.login()

    //内层圆圈独立动画
    this.innerIntervalId = setInterval(() => {
      this.rotateAngle3 += 2
      if (this.rotateAngle3 >= 360) {
        this.rotateAngle3 = 0
      }
    }, 10) // 约60fps

    //自检进度动画 (每100ms增加2%)
    /* 动画参数：
     * 进度速度：2%/100ms → 20%/秒 → 5秒完成100%
     * 角度计算：360°/100% → 每1%对应3.6°
     * 外层：顺时针旋转 + 长度增长
     * 中层：逆时针旋转 + 长度增长
    */
    this.progressIntervalId = setInterval(() => {
      if (this.progress < 100) {
        this.progress += 2
        this.targetAngle = this.progress * 3.6 //更新目标角度

        //更新进度条长度
        this.rotateAngle1 = this.progress * 3.6 //外层进度条
        this.rotateAngle2 = -this.progress * 3.6 //中层进度条 (反向)
      } else {
        this.progress = 100
        this.rotateAngle1 = 360
        this.rotateAngle2 = -360
        clearInterval(this.progressIntervalId)
      }
    },100)
  }

  navigateToDashboard() {
    router.pushUrl({ url: 'pages/SpeedPage/Index' });
  }

  build() {
    Column(){
      Header({ currentTheme: this.currentTheme })

      Column(){
        Row() {
          Image($r("app.media.back"))
            .width(40)
            .fillColor(this.currentTheme.iconColor)
            .onClick(() => {
              this.navigateToDashboard()
            })
            .margin({ left: 32 })
        }
        .width('100%')
        .height(30)
        .justifyContent(FlexAlign.Start)

        Row({space: 100}){

          Column(){
            Column(){
              Row() {
                Text("方向盘角度反馈")
                  .fontSize(20)
                  .fontColor(this.currentTheme.textColor)
                  .margin({ bottom: 5 })
              }
              .width('50%')
              .height(50)

              Column(){
                SteeringWheelAngleFeedback()
                  .height("90%")
              }
              .width('100%')
            }
            .width('100%')
            .height('88%')
            .borderRadius(25)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.currentTheme.mask)
            .padding(10)
          }
          .width("32%")
          .height("100%")
          .justifyContent(FlexAlign.Center)

          Column() {
            Text('自检功能')
              .height(50)
              .fontSize(20)
              .fontColor(this.currentTheme.textColor)

            Stack() {
              //外层进度条
              Circle()
                .width(200)
                .height(200)
                .fill(Color.Transparent)
                .stroke($r('app.color.circle_one'))
                .strokeWidth(22)
                .strokeDashArray([this.progress * 6.8, 680]) // 动态进度条
                .strokeLineCap(LineCapStyle.Round)
                .rotate({ angle: this.currentAngle })

              //中层进度条
              Circle()
                .width(160)
                .height(160)
                .fill(Color.Transparent)
                .stroke($r('app.color.circle_two'))
                .strokeWidth(18)
                .strokeDashArray([this.progress * 6.8, 680])
                .strokeLineCap(LineCapStyle.Round)
                .rotate({ angle: -this.currentAngle }) // 反向旋转

              //内层旋转圆圈
              Circle()
                .width(145)
                .height(145)
                .fill($r('app.color.circle_three'))
                .rotate({ angle: this.rotateAngle3 }) // 持续旋转

              //中心圆
              Circle()
                .width(100)
                .height(100)
                .fill(this.currentTheme.theme)

              //显示数值和单位
              Column() {
                Text(this.progress < 100 ? "自检中" : "自检完成")
                  .fontSize(22)
                  .fontWeight(600)
                  .fontColor(this.currentTheme.textColor)
                  .margin({ bottom: 5 })

                Text(`${this.progress}%`)
                  .fontSize(26)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(this.currentTheme.iconColor)
              }
            }
            .layoutWeight(1)

            /* 车胎自检：>30%时显示完成
             * 水压自检：>60%时显示完成
             * 机油压力：>90%时显示完成
             * */
            Column({ space: 10 }) {
              Text(this.progress < 30?'车胎自检中...':'车胎自检完成')
                .fontSize(15)
                .fontColor(this.progress > 30 ? this.currentTheme.textColor : Color.Gray)
              Text(this.progress < 60 ?'水压自检中...': '水压自检完成')
                .fontSize(15)
                .fontColor(this.progress > 60 ? this.currentTheme.textColor : Color.Gray)
              Text(this.progress < 90 ?'机油压力自检中...': '机油压力自检完成')
                .fontSize(15)
                .fontColor(this.progress > 90 ? this.currentTheme.textColor : Color.Gray)
            }
            .height(100)
          }
          .width('35%')
          .height('88%')
          .backgroundColor(this.currentTheme.mask)
          .borderRadius(25)
        }
        .width("100%")
        .height("85%")
        .justifyContent(FlexAlign.Center)
      }
    }
    .backgroundColor(this.currentTheme.theme)
    .width("100%")
    .height("100%")
  }
}