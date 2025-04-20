import { Header } from '../../component/Header'
import { Bottom } from '../../component/Bottom'
import { MainPanel } from './MainPanel'


@Entry
@Component
export struct VehicleControlPage {
  build() {
    Column(){
      Header()
      Row() {
        MainPanel()
      }
      .layoutWeight(1)

      Bottom()
    }
  }
}