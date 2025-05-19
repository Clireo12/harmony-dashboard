@Entry
@Component
export struct Snow {
  @State xPos: number = Math.random() * 100
  @State yPos: number = Math.random() * 100
  @State snowsize: number = Math.random() * 20 + 10
  @State snowopacity: number = Math.random() * 0.7 + 0.3
  @State snowspeed: number = Math.random() * 3 + 1
  @State snowswing: number = Math.random() * 2 - 1  //左右摆动幅度随机(-1到1)
  @State snowrotation: number = Math.random() * 360

  private timerId: number = 0 //定时器ID

  aboutToAppear() {
    this.timerId = setInterval(() => {
      this.yPos += this.snowspeed
      this.xPos += this.snowswing * 0.2
      this.snowrotation += 0.5

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
        .rotate({ angle: this.snowrotation })
        .position({ x: this.xPos + '%', y: this.yPos + '%' })
        .fillColor('#ccebff')
    }
  }
}