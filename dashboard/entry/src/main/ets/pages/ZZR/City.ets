@Component
export struct City {
  private Width:number|string = 280
  private Height:number|string = 350
  build() {
    Stack(){
      Stack(){
        Column(){
          Image($r("app.media.city"))
            .offset({y:40})
            .width("220%")
          // .height("100%")
          Image($r("app.media.pavement"))
            .width("200%")
            .offset({ y: 100 })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(this.Width)
        .height(this.Height)
        Image($r("app.media.car"))
          .width("45%")
          .offset({ y : 50})
      }

    }
  }
}