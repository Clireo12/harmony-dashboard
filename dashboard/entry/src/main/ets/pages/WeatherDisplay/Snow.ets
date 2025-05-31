/**
 * 雪花动画
 * 模拟下雪效果，创建随机位置、大小、透明度和运动轨迹的雪花
 */
@Entry
@Component
export struct Snow {
  @State xPos: number = Math.random() * 100   //水平位置（百分比）
  @State yPos: number = Math.random() * 100   //垂直位置（百分比）
  @State snowsize: number = Math.random() * 20 + 10 //尺寸（随机值10-30）
  @State snowopacity: number = Math.random() * 0.7 + 0.3  //透明度（随机值0.3-1.0）
  @State snowspeed: number = Math.random() * 3 + 1  //下落速度（随机值1-4）
  @State snowswing: number = Math.random() * 2 - 1  //左右摆动幅度（随机值-1到1）
  @State snowrotation: number = Math.random() * 360   //旋转角度（随机初始角度0-360）

  private timerId: number = 0   //动画定时器ID

  //初始化雪花动画
  aboutToAppear() {
    //设置定时器，每50毫秒更新一次雪花状态
    this.timerId = setInterval(() => {
      this.yPos += this.snowspeed   //雪花垂直下落
      this.xPos += this.snowswing * 0.2   //雪花水平轻微摆动
      this.snowrotation += 0.5  //雪花缓慢旋转

      //当雪花落到屏幕底部时，重置到顶部随机位置
      if (this.yPos > 100) {
        this.yPos = -5  //稍微超出顶部，避免突然出现
        this.xPos = Math.random() * 100   //随机水平位置
      }
    }, 50)
  }

  aboutToDisappear() {
    //清除定时器
    clearInterval(this.timerId)
  }

  build() {
    Row() {
      Image($r("app.media.snowflake"))
        .width(this.snowsize) //雪花尺寸
        .height(this.snowsize)
        .opacity(this.snowopacity) //透明度
        .rotate({ angle: this.snowrotation }) //旋转角度
        .position({
          x: this.xPos + '%', //水平位置（百分比）
          y: this.yPos + '%'  //垂直位置（百分比）
        })
        .fillColor('#ccebff')
    }
  }
}