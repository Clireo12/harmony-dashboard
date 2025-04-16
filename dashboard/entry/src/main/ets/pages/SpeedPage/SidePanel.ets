@Component
export struct SidePanel {
  @Prop warning: boolean // 应急灯
  @Prop charge: boolean // 充电
  @Prop carDoor: boolean // 车门
  @Prop fan: boolean // 风扇
  @Prop temp: number // 温度

  build() {
    Column({ space: 80 }) {
      Text('666')
      Text('666')
      Text('666')
    }
    .padding(8)
    .justifyContent(FlexAlign.Center)
    .width(100)
    .height('100%')
  }
}