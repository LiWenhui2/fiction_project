import stack from '../utils/route'

@Entry
@Component
struct Index {
  aboutToAppear(): void {
    stack.pushPathByName('Start',null)
  }

  build() {
    Navigation(stack){
      Text('Index')
    }
    .hideNavBar(true)
    .height('100%')
    .width('100%')
  }
}