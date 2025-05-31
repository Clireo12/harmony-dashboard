/**
 * 雨滴动画
 * 模拟下雨效果，创建随机位置、大小和速度的雨滴
 */
@Component
export struct Rain {
  @State xPos: number = Math.random() * 100   //水平位置（百分比）
  @State yPos: number = Math.random() * 100   //垂直位置（百分比）
  @State rainLength: number = Math.random() * 10 + 10   //长度（随机值10-20）
  @State rainSpeed: number = Math.random() * 5 + 5    //下落速度（随机值5-10）
  @State rainWidth: number = Math.random() * 1 + 0.5  //宽度（随机值0.5-1.5）

  private timerId: number = 0   //动画定时器ID

  aboutToAppear() {
    //设置定时器，每50毫秒更新一次雨滴位置
    this.timerId = setInterval(() => {
      //雨滴垂直下落
      this.yPos += this.rainSpeed

      //雨滴落到屏幕底部时，重置到顶部随机位置
      if (this.yPos > 100) {
        this.yPos = -5  //稍微超出顶部，避免突然出现
        this.xPos = Math.random() * 100   //随机水平位置
      }
    }, 50)  //50毫秒的更新间隔
  }

  aboutToDisappear() {
    //清除定时器
    clearInterval(this.timerId)
  }


  build() {
    Column() {
      //使用Line组件绘制雨滴
      Line()
        .width(this.rainWidth) //设置雨滴宽度
        .height(this.rainLength) //设置雨滴长度
        .backgroundColor('#a0d0ff') //浅蓝色雨滴
        .position({
          x: this.xPos + '%', //水平位置（百分比）
          y: this.yPos + '%'  //垂直位置（百分比）
        })
    }
  }
}