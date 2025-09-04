import stack from '../utils/route'

@Entry
@Component
struct Index {
  aboutToAppear(): void {
    stack.pushPathByName('Login', null)
    // stack.pushPathByName('Start',null)
  }

  build() {
    Navigation(stack) {
    }
    .hideNavBar(true)
    .height('100%')
    .width('100%')
  }
}