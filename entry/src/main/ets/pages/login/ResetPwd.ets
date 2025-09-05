import stack from '../../utils/route'

@Builder
export function ResetPwdBuilder() {
  ResetPwd()
}

@Component
struct ResetPwd {
  @State account: string = ''

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Start }) {
        Text('忘记密码')
          .fontColor('#1b1b1b')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontSize(18)
        Image($r('app.media.backButton'))
          .width(20)
          .onClick(() => {
            stack.pop()
          })
      }
      .margin({ bottom: 80 })

      Column({ space: 30 }) {
        Image($r('app.media.resetPwd_safe'))
          .width(90)
        Text('输入待找回密码的账号')
          .fontColor('#aaa')
          .fontSize(24)
        TextInput({ placeholder: '账号 (手机/邮箱)', text: $$this.account })
          .placeholderColor('#ccc')
          .placeholderFont({ weight: 500 })
          .padding(5)
          .borderRadius(0)
          .backgroundColor(Color.Transparent)
          .border({ width: { bottom: 2 }, color: '#d2d3d5' })
          .margin({ bottom: 20 })
        Button('确认')
          .fontColor('#fff')
          .fontSize(20)
          .width('100%')
          .height(50)
          .backgroundColor(this.account ? '#2481fa' : '#d3e5fe')
      }
    }
    .backgroundColor('#fff')
    .padding(20)
    .hideBackButton(true)
  }
}