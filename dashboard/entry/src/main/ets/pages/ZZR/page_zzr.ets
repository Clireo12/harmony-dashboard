import { DrivingMode } from './DrivingMode'
import { Header } from '../../component/Header'
import { SteeringWheelAngleFeedback } from './SteeringWheelAngleFeedback'
import { Constants } from './Constants'

@Entry
@Component
export struct SwitchMode {
  build() {
    Column(){
      Header()
      Row(){
        SteeringWheelAngleFeedback({
          _height:380
        })
        DrivingMode({
          _height:380
        })
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Top)
    }
    .width(Constants.PAGE_WEIGHT)
    .height(Constants.PAGE_HEIGHT)
  }
}