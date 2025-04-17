import { City } from '../../component/City'
import { CirclePanel } from '../SpeedPage/CirclePanel'

@Component
//实时传感器监控组件
struct SensorItem {
  @Prop label: string
  @Prop img : Resource
  build() {
    Column() {
      Image(this.img)
        .width("50%")
        .height("45%")
        .margin({
          bottom: 5
        })
      Text(this.label)
        .fontColor(Color.Black)
        .fontSize(20)
    }.shadow(ShadowStyle.OUTER_DEFAULT_XS)
      .width("85%")
      .height("45%")
      .justifyContent(FlexAlign.Center)
      .borderRadius(20)
      //在这里设置事件触发 当该组件被接触时 修改该组件的页面背景颜色


  }

}

@Component
export struct MainPanel {
  build() {
   Row(){
     //实时传感器监控
     Column() {
       Text("实时传感器监控")
         .fontColor(Color.Black)
         .fontSize(20)
         .margin({
           top:15
         })
         Grid() {
           GridItem() {
             SensorItem({ img : $r('app.media.battery'),label: '电池电压'})
           }

           GridItem() {
             SensorItem({ img : $r('app.media.wendu'),label: '冷却液温度' })
           }

           GridItem() {
             SensorItem({ img : $r('app.media.oil'),label: '机油压力'})
           }

           GridItem() {
             SensorItem({ img : $r("app.media.fuel1"), label: '燃油轨压力'})
           }
         }
         .columnsTemplate('1fr 1fr')
         .rowsGap(20)
         .columnsGap(20)

         .width('100%')
         .padding(20)

         .margin({ top: 20, bottom: 20 })

     }
     .backgroundColor(Color.Transparent)
     .borderRadius(20)
     .width("35%")
     .height("95%")
     .shadow( ShadowStyle.OUTER_DEFAULT_XS)
      //Car
      City()
      Image($r("app.media.car"))
        .width("35%")
        .height("70%")
        .offset({
          y: 50,
          x: -300
        })
        .margin({
          top: 20
        })

     // 自检功能
     Column() {
       Text('自检功能')
         .fontSize(20)
         .fontColor(Color.Gray)
         .margin({
           top: 10,
           bottom: 10 })
       CirclePanel({

         num: 10,
         unit: '自检中',
         current: 100
       })

         .margin({
           top:-130
         })

       Column() {
         Text('车胎自检中...')
           .fontSize(15)
           .fontColor(Color.Gray)
         Text('水压自检中...')
           .fontSize(15)
           .fontColor(Color.Gray)
         Text('机油压力自检中...')
           .fontSize(15)
           .fontColor(Color.Gray)
       }

       .margin({ top: -110 })

     }
     .shadow( ShadowStyle.OUTER_DEFAULT_XS)
     .width('35%')
     .height('95%')
     .backgroundColor(Color.Transparent)
     .borderRadius(20)
     .offset({
       x: -350
     })
      }
  }
}