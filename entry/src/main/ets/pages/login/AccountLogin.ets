import stack from '../../utils/route'

@Builder
export function AccountLoginBuilder() {
  AccountLogin()
}

@Extend(Row)
function PhoneLoginRowStyle() {
  .padding({ left: 20, right: 15 })
  .height(50)
  .width('100%')
  .backgroundColor('#fff')
  .borderRadius(25)
}

@Extend(TextInput)
function textInputStyle() {
  .borderRadius(0)
  .caretColor('#cecece')
  .placeholderColor('#cecece')
  .backgroundColor(Color.Transparent)
  .padding(0)
  .layoutWeight(1)
}

@Component
struct AccountLogin {
  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Start }) {
        Text('番茄账号登录')
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

      Column({ space: 20 }) {
        Row({ space: 10 }) {
          Image($r('app.media.account_login_user'))
            .width(20)
          TextInput({ placeholder: '手机号/邮箱/起点账号' })
            .textInputStyle()
        }
        .PhoneLoginRowStyle()

        Row({ space: 10 }) {
          Image($r('app.media.account_login_pwd'))
            .width(22)
          TextInput({ placeholder: '密码' })
            .textInputStyle()
            .type(InputType.Password)
        }
        .PhoneLoginRowStyle()

        Row() {
          Text('登录')
            .fontColor('#fff')
            .fontSize(18)
            .fontWeight(600)
            .width('100%')
            .textAlign(TextAlign.Center)
        }
        .PhoneLoginRowStyle()
        .backgroundColor('#e0e0e0')

        Row() {
          Text('忘记密码？')
            .fontColor('#858585')
          Text('注册新账号')
            .fontColor('#1b1b1b')
            .onClick(() => {
              stack.pushPathByName('Register', null)
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
    }
    .backgroundColor('#f5f5f5')
    .padding(20)
    .hideBackButton(true)
  }
}