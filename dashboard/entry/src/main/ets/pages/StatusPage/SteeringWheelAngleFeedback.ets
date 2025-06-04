import { ThemeManager } from '../../model/ThemeManager';
import IotDataTool from '../../utils/IotDataTool'
import hilog from '@ohos.hilog';


// 方向盘角度反馈组件
@Component
export struct SteeringWheelAngleFeedback {
  private themeManager: ThemeManager = ThemeManager.getInstance();

  @State bgkColor: Color | string = "#2B323A"
  @State currentAngle: number = 0  // 动画当前角度
  @State @Watch("onTargetAngleChange") targetAngle: number =  0;  // 目标角度
  @State angleColor: Color | string = Color.Red
  private timerId: number = -1; // 定时器ID
  private dataPollTimer: number = -1;
  aboutToAppear() {
    // // 延迟初始化，确保数据已准备好
    // setTimeout(() => {
    //   const initialAngle = parseFloat(IotDataTool.responseData.shadow?.[0]?.reported?.properties?.mpu_1) || 0;
    //   this.targetAngle = initialAngle;
    //   this.currentAngle = initialAngle;
    // }, 100);
    // 先设置默认值，避免UI闪烁
    this.currentAngle = 0;
    this.targetAngle = 0;

    // 初始化数据轮询
    this.dataPollTimer = setInterval(() => {
      try {
        let newAngle = parseFloat(
          IotDataTool.responseData?.shadow?.[0]?.reported?.properties?.mpu_1
        ) || 0;
        if (Math.abs(newAngle) > 540){
          newAngle = 540;
        }
        // 首次赋值或值变化时更新
        if (this.targetAngle === 0 || Math.abs(newAngle - this.targetAngle) > 0.1) {
          this.targetAngle = newAngle; // 触发@Watch
        }
      } catch (error) {
        hilog.error(0x00, "test", `数据解析错误: ${error}`);
      }
    }, 100); // 100ms轮询间隔
  }

  aboutToDisappear() {
    this.stopAngleAnimation(); // 页面销毁时停止计时器
    clearInterval(this.dataPollTimer); // 清除轮询定时器
  }

  onTargetAngleChange() {
    // 添加差值检查（防止不必要动画）
    if (Math.abs(this.currentAngle - this.targetAngle) > 0.1) {
      this.startAngleAnimation();
    }
    console.log("角度变化了")
    hilog.info(0x00, "test", "角度变化了")
  }

  // 启动角度动画
  // startAngleAnimation() {
  //   this.stopAngleAnimation(); // 先停止之前的动画
  //
  //   // 如果当前角度等于目标角度，无需动画
  //   if (Math.abs(this.currentAngle - this.targetAngle) < 0.1) {
  //     return;
  //   }
  //
  //   this.timerId = setInterval(() => {
  //     // 计算角度差
  //     const angleDiff = this.targetAngle - this.currentAngle;
  //
  //     // 根据角度差的大小动态调整步长，使动画更流畅
  //     const step = Math.min(5, Math.max(0.5, Math.abs(angleDiff) / 10)) * (angleDiff > 0 ? 1 : -1);
  //
  //     // 计算下一个角度
  //     const nextAngle = this.currentAngle + step;
  //
  //     // 判断是否接近目标角度
  //     const isNearTarget = Math.abs(nextAngle - this.targetAngle) < 0.1;
  //
  //     if (isNearTarget) {
  //       this.currentAngle = this.targetAngle; // 确保精确到达目标角度
  //       this.stopAngleAnimation(); // 停止计时器
  //     } else {
  //       this.currentAngle = nextAngle; // 更新当前角度
  //     }
  //   }, 16); // 约60fps的更新频率
  // }
  startAngleAnimation() {
    this.stopAngleAnimation();

    const startAngle = this.currentAngle;
    const angleDiff = this.targetAngle - startAngle;

    // 处理角度大于360度的情况（如果可能）
    const normalizedDiff = ((angleDiff + 180) % 360) - 180;

    if (Math.abs(normalizedDiff) < 0.1) {
      return;
    }

    const duration = Math.min(1500, Math.abs(normalizedDiff) * 20);
    const startTime = Date.now();
    const frameRate = 16;

    this.timerId = setInterval(() => {
      try {
        const elapsed = Date.now() - startTime;
        const progress = Math.min(elapsed / duration, 1);
        const easedProgress = this.easeInOutQuad(progress);

        // 使用归一化的角度差计算当前角度
        this.currentAngle = startAngle + (normalizedDiff * easedProgress);

        if (progress >= 1) {
          this.currentAngle = this.targetAngle;
          this.stopAngleAnimation();
        }
      } catch (error) {
        hilog.error(0x00, "test", `动画更新错误: ${error}`);
        this.stopAngleAnimation();
      }
    }, frameRate);
  }


  // 缓动函数实现（网页9的动画曲线原理）
  private easeInOutQuad(t: number): number {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }
  // 停止角度动画
  stopAngleAnimation() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  build() {
    Column({space:15}){
      // Text("方向盘角度反馈")
      //   .textAlign(TextAlign.Center)
      //   .fontSize(15)
      //   .width("100%")
      //   .height("10")
      //   .fontColor(this.themeManager.getCurrentTheme().textColor)
      //   .margin({
      //     top: 10
      //   })
      Stack(){
        Image($r("app.media.fang_xiang_pan_jiao_du"))
          .width("88%")
          .rotate({ angle: this.currentAngle })
        Text(this.currentAngle.toFixed(1) + "°")
          .textAlign(TextAlign.Center)
          .fontSize(28)
          .fontColor(this.angleColor)
      }
      .width("100%")
      .height("95%")
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(20)
    .backgroundColor(this.themeManager.getCurrentTheme().mask)
  }
}