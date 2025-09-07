import axios from '../../utils/HttpRequest'
import stack from '../../utils/route'

@Builder
export function NewPwdBuilder() {
  NewPwd()
}

@Extend(TextInput)
function textInputStyle() {
  .placeholderColor('#ccc')
  .placeholderFont({ weight: 500 })
  .padding(5)
  .borderRadius(0)
  .backgroundColor(Color.Transparent)
  .border({ width: { bottom: 2 }, color: '#d2d3d5' })
  .type(InputType.Password)
  .placeholderFont({ size: 14 })
}

@Component
struct NewPwd {
  @State password: string = ''
  @State confirmPwd: string = ''
  @State alertMessage: string = ''
  @State account: string = ''
  alertDialogController: CustomDialogController = new CustomDialogController({
    builder: this.alertDialog,
    backgroundColor: '#0f0e13',
    backgroundBlurStyle: BlurStyle.NONE,
    width: 200,
    height: 80,
    cornerRadius: 15,
    isModal: false
  })

  dialogOpen() {
    this.alertDialogController.open()
    setTimeout(() => {
      this.alertDialogController.close()
    }, 2000)
  }

  @Builder
  alertDialog() {
    Text(this.alertMessage)
      .fontColor('#fff')
      .padding(15)
      .backgroundColor('#0f0e13')
      .width(200)
      .height(80)
      .fontWeight(500)
      .textAlign(TextAlign.Center)
  }

  aboutToAppear(): void {
    this.account = stack.getParamByName('NewPwd')[0] as string
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Start }) {
        Text('输入新密码')
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
        Text('请设置新密码')
          .fontColor('#aaa')
          .fontSize(24)
        TextInput({ placeholder: '请输入新密码 (最少6位，由字母、数字组成)', text: $$this.password })
          .textInputStyle()
        TextInput({ placeholder: '请确认新密码', text: $$this.confirmPwd })
          .textInputStyle()
        Button('确认')
          .fontColor('#fff')
          .fontSize(20)
          .width('100%')
          .height(50)
          .margin({ top: 10 })
          .backgroundColor(/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/.test(this.password) &&
            this.password == this.confirmPwd ? '#2481fa' : '#d3e5fe')
          .onClick(async () => {
            if (!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/.test(this.password)) {
              this.alertMessage = '密码必须由字母、数字组成，至少6位'
              this.dialogOpen()
              return
            }
            if (this.password != this.confirmPwd) {
              this.alertMessage = '两次输入密码不一致'
              this.dialogOpen()
              return
            }
            const res = await axios.post('/user/resetPwd', {
              'account': this.account,
              'password': this.password
            } as Record<string, string>)
            if (res['status'] == 1) {
              this.alertMessage = '重置密码失败'
              this.dialogOpen()
              return
            }
            this.alertMessage = '密码重置成功，即将跳转登录页面'
            this.dialogOpen()
            setTimeout(() => {
              stack.popToName('AccountLogin')
            }, 2500)
          })
      }
    }
    .backgroundColor('#fff')
    .padding(20)
    .hideBackButton(true)
  }
}