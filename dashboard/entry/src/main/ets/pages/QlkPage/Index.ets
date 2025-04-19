import { Header } from '../../component/Header'
import { Bottom } from '../../component/Bottom'
import { MainPanel } from './MainPanel'


@Entry
@Component
export struct VehicleControlPage {
  // @State Width:number = 380
  @State Height:number = 380
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