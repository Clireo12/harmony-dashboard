import { ThemeManager } from '../../model/ThemeManager';

// 方向盘角度反馈组件
@Component
export struct SteeringWheelAngleFeedback {
  private themeManager: ThemeManager = ThemeManager.getInstance();

  @State bgkColor: Color | string = "#2B323A"
  @State currentAngle: number = 0  // 动画当前角度
  private targetAngle: number = -270  // 目标角度可能为负数
  @State angleColor: Color | string = Color.Red
  private timerId: number = -1; // 定时器ID


  aboutToAppear() {
    this.startAngleAnimation(); // 页面加载时开始计时器
  }

  aboutToDisappear() {
    this.stopAngleAnimation(); // 页面销毁时停止计时器
  }

  // 启动角度动画
  startAngleAnimation() {
    this.stopAngleAnimation(); // 先停止之前的动画

    // 如果当前角度等于目标角度，无需动画
    if (this.currentAngle === this.targetAngle) {
      return;
    }

    // 计算步长（方向和速度）
    const step = this.calculateStep();

    this.timerId = setInterval(() => {
      // 计算下一个角度
      const nextAngle = this.currentAngle + step;

      // 判断是否达到或超过目标角度
      const hasReachedTarget = step > 0
        ? nextAngle >= this.targetAngle
        : nextAngle <= this.targetAngle;

      if (hasReachedTarget) {
        this.currentAngle = this.targetAngle; // 确保精确到达目标角度
        this.stopAngleAnimation(); // 停止计时器
      } else {
        this.currentAngle = nextAngle; // 更新当前角度
      }
    }, 5); // 每5毫秒更新一次
  }

  // 计算步长（方向和速度）
  private calculateStep(): number {
    const angleDiff = this.targetAngle - this.currentAngle;

    // 根据角度差的符号决定方向
    if (angleDiff > 0) {
      return 1; // 正向增加
    } else if (angleDiff < 0) {
      return -1; // 负向减少
    } else {
      return 0; // 无需变化
    }
  }

  // 停止角度动画
  stopAngleAnimation() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  build() {
    Column(){
      // Text("方向盘角度反馈")
      //   .textAlign(TextAlign.Center)
      //   .fontSize(16)
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
        Text(this.currentAngle.toString()+"°")
          // .onAppear(()=>{
          //
          // })
          .textAlign(TextAlign.Center)
          .fontSize(28)
          .fontColor(this.angleColor)
      }
      .width("100%")
      .height("100%")
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .borderRadius(25)
    .backgroundColor(this.themeManager.getCurrentTheme().mask)
  }
}