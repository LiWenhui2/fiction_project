import stack from '../utils/route'

@Entry
@Component
struct Index {
  @StorageProp('token') token: string = ''

  aboutToAppear(): void {
    if (this.token) {
      stack.pushPathByName('Home', '')
      return
    }
    stack.pushPathByName('Start', null)
  }

  build() {
    Navigation(stack) {
    }
    .hideNavBar(true)
    .height('100%')
    .width('100%')
  }
}