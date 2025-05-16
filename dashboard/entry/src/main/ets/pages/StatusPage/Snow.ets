@Entry
@Component
export struct Snow {
  @State xPos: number = Math.random() * 100
  @State yPos: number = Math.random() * 100
  @State snowsize: number = Math.random() * 20 + 10  //大小随机(10-30px)
  @State snowopacity: number = Math.random() * 0.7 + 0.3  //透明度随机(0.3-1)
  @State speed: number = Math.random() * 2 + 1  //下落速度随机(1-3)
  @State swing: number = Math.random() * 2 - 1  //左右摆动幅度随机(-1到1)
  @State rotation: number = Math.random() * 360  //旋转角度随机(0-360度)

  private timerId: number = 0 //定时器ID

  aboutToAppear() {
    this.timerId = setInterval(() => {
      this.yPos += this.speed
      this.xPos += this.swing * 0.2
      this.rotation += 0.5

      //当雪花落到底部时，重置到顶部随机位置
      if (this.yPos > 100) {
        this.yPos = -5
        this.xPos = Math.random() * 100
      }
    }, 50)
  }

  aboutToDisappear() {
    clearInterval(this.timerId)
  }

  build() {
    Row(){
      Image($r("app.media.snow"))
        .width(this.snowsize)
        .height(this.snowsize)
        .opacity(this.snowopacity)
        .rotate({ angle: this.rotation })
        .position({ x: this.xPos + '%', y: this.yPos + '%' })
    }
  }
}