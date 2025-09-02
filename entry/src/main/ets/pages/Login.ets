import { common } from '@kit.AbilityKit'

@Builder
export function LoginBuilder() {
  Login()
}

@ComponentV2
struct Login {
  @Local isAgree: boolean = false
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext
  agreementDialogController: CustomDialogController = new CustomDialogController({
    builder: this.agreementDialogBuilder,
    width: 300,
    cornerRadius: 15,
    autoCancel: false,
    backgroundColor: '#fff'
  })

  @Builder
  agreementDialogBuilder() {
    Column({ space: 15 }) {
      Text('用户服务协议和隐私协议')
        .width('100%')
        .fontSize(18)
        .fontColor('#1c1c1c')
        .fontWeight(600)
        .textAlign(TextAlign.Center)
      Text() {
        Span('我已阅读并同意')
        Span('《用户服务协议》')
          .fontColor('#6773c7')
        Span('及')
        Span('《隐私协议》')
          .fontColor('#6773c7')
        Span('，未注册手机登录后将自动创建起点账号')
      }
      .lineHeight(20)
      .width('100%')
      .fontSize(14)
      .fontColor('#777')

      Row() {
        Button('不同意')
          .fontWeight(500)
          .width(115)
          .height(45)
          .backgroundColor('#ffe7e7')
          .fontColor('#e43640')
          .onClick(() => {
            this.agreementDialogController.close()
          })
        Button('同意并继续')
          .fontWeight(500)
          .width(115)
          .height(45)
          .backgroundColor('#e43640')
          .fontColor('#fff')
          .onClick(() => {
            this.isAgree = true
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .padding({
      top: 30,
      bottom: 25,
      left: 25,
      right: 25
    })
  }

  @Builder
  loginOption(text: string, icon: ResourceStr) {
    Row({ space: 5 }) {
      Image(icon)
        .width(24)
      Text(text)
        .fontWeight(500)
        .fontColor('#030303')
    }
    .justifyContent(FlexAlign.Center)
    .height(50)
    .width('100%')
    .backgroundColor('#fff')
    .borderRadius(30)
  }

  build() {
    NavDestination() {
      Stack() {
        Image($r('app.media.login_bg'))
          .objectFit(ImageFit.Fill)
          .expandSafeArea([SafeAreaType.SYSTEM])
        Column() {
          Row() {
            Image($r('app.media.close'))
              .fillColor('#fff')
              .width(30)
              .onClick(() => {
                this.context.terminateSelf()
              })
          }
          .padding(15)
          .width('100%')

          Column({ space: 20 }) {
            this.loginOption('微信登录', $r('app.media.wechat'))
            this.loginOption('QQ登录', $r('app.media.QQ'))
            this.loginOption('抖音登录', $r("app.media.Douyin"))
            Row() {
              Row() {
                Image($r('app.media.phone'))
                  .width(24)
              }
              .justifyContent(FlexAlign.Center)
              .border({ radius: '50%', width: 1, color: '#fff' })
              .width(50)
              .height(50)
              .onClick(() => {
                if (!this.isAgree) {
                  this.agreementDialogController.open()
                }
              })

              Row() {
                Image($r('app.media.more'))
                  .width(24)
              }
              .justifyContent(FlexAlign.Center)
              .border({ radius: '50%', width: 1, color: '#fff' })
              .width(50)
              .height(50)
              .onClick(() => {
                if (!this.isAgree) {
                  this.agreementDialogController.open()
                }
              })
            }
            .margin({ top: 10, bottom: 10 })
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)

            Row({ space: 3 }) {
              Row() {
                Checkbox()
                  .width(14)
                  .unselectedColor('#fff')
                  .selectedColor('#f00')
                  .select($$this.isAgree)
              }
              .padding({ top: 4 })

              Text('我已阅读并同意《用户服务协议》及《隐私协议》，未注册用户登录后将自动创建番茄账号')
                .layoutWeight(1)
                .fontSize(12)
                .fontColor('#fff')
                .lineHeight(22)
            }
            .alignItems(VerticalAlign.Top)
            .width('100%')
          }
          .padding(30)
          .width('100%')

        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height('100%')
    }
    .hideBackButton(true)
  }
}