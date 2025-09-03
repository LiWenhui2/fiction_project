import stack from '../../utils/route'

@Builder
export function RegisterBuilder() {
  Register()
}

@Extend(TextInput)
function textInputStyle() {
  .type(InputType.Number)
  .borderRadius(0)
  .caretColor('#cecece')
  .placeholderColor('#cecece')
  .backgroundColor(Color.Transparent)
  .padding(0)
  .layoutWeight(1)
}

@Extend(Row)
function PhoneLoginRowStyle() {
  .padding({ left: 20, right: 15 })
  .height(50)
  .width('100%')
  .backgroundColor('#fff')
  .borderRadius(25)
}

@ComponentV2
struct Register {
  @Local phone: string = ''
  @Local email: string = ''
  @Local alertMessage: string = ''

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Start }) {
        Text('账号注册')
          .fontColor('#1b1b1b')
          .width('100%')
          .textAlign(TextAlign.Center)
          .fontSize(20)
        Image($r('app.media.backButton'))
          .width(20)
          .onClick(() => {
            stack.pop()
          })
      }
      .margin({ bottom: 20 })

      Column({ space: 15 }) {
        Row({ space: 10 }) {
          Image($r('app.media.login_phone'))
            .width(24)
          Text('+86')
            .fontColor('#1b1b1b')
            .fontWeight(500)
            .margin({ left: 5, right: 5 })

          Image($r('app.media.login_phone_more'))
            .width(12)
          TextInput({ placeholder: '请输入手机号' })
            .textInputStyle()
        }
        .PhoneLoginRowStyle()

        Row({ space: 10 }) {
          Image($r('app.media.register_email'))
            .width(24)
          TextInput({ placeholder: '请输入邮箱' })
            .textInputStyle()
        }
        .PhoneLoginRowStyle()

        Row({ space: 10 }) {
          Image($r('app.media.login_code'))
            .width(24)
          TextInput({ placeholder: '请输入邮箱验证码' })
            .textInputStyle()
          Divider().strokeWidth(1).color('#cecece').height(25).vertical(true)
          Text('获取验证码')
            .fontColor('#921721')
        }
        .PhoneLoginRowStyle()


        Row() {
          Text('注册')
            .fontColor('#fff')
            .fontSize(18)
            .fontWeight(600)
            .width('100%')
            .textAlign(TextAlign.Center)
        }
        .PhoneLoginRowStyle()
        .backgroundColor('#e0e0e0')
      }
    }
    .backgroundColor('#f5f5f5')
    .padding(20)
    .hideBackButton(true)
  }
}