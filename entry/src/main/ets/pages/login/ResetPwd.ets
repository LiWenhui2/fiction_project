import { SliderVerification } from '../../components/SliderVerification'
import axios from '../../utils/HttpRequest'
import stack from '../../utils/route'

@Builder
export function ResetPwdBuilder() {
  ResetPwd()
}

@Component
struct ResetPwd {
  @State account: string = 'vonphy217@gmail.com'
  @State isSliderVerificationShow: boolean = true
  @State alertMessage: string = ''
  @State @Watch('closeDialog') verifyStatus: number = 0 //0 失败 1 成功 -1 取消
  private sliderVerificationDialogController: CustomDialogController = new CustomDialogController({
    builder: this.sliderVerificationDialogBuilder,
    cornerRadius: 5,
    maskColor: '#7f7f7f',
    backgroundColor: '#fff',
    autoCancel: false
  })
  alertDialogController: CustomDialogController = new CustomDialogController({
    builder: this.alertDialog,
    backgroundColor: '#0f0e13',
    width: 200,
    height: 50,
    cornerRadius: 15,
    isModal: false
  })

  @Builder
  alertDialog() {
    Text(this.alertMessage)
      .fontColor('#fff')
      .padding(15)
      .backgroundColor('#0f0e13')
      .width(200)
      .height(50)
      .fontWeight(500)
      .textAlign(TextAlign.Center)
  }

  dialogOpen() {
    this.alertDialogController.open()
    setTimeout(() => {
      this.alertDialogController.close()
    }, 2000)
  }

  closeDialog() {
    if (this.verifyStatus == 1) {
      setTimeout(async () => {
        this.sliderVerificationDialogController.close()
        const isExistRes = await axios.post<Record<string, string>>('/user/isExist', {
          'account': this.account
        })
        if (isExistRes['status'] == 1) {
          this.alertMessage = '账号未注册'
          this.dialogOpen()
          return
        }
        const sendCodeRes = await axios.post('/verify/sendCode', {
          'email': this.account
        } as Record<string, string>)
        if (sendCodeRes['status'] == 1) {
          this.alertMessage = '验证码发送失败'
          this.dialogOpen()
          return
        }
        stack.pushPathByName('Verification', this.account)
      }, 500)
    } else if (this.verifyStatus == -1) {
      this.sliderVerificationDialogController.close()
      this.verifyStatus = 0
      console.log('cancel')
    }


  }

  @Builder
  sliderVerificationDialogBuilder() {
    SliderVerification({ verifyStatus: this.verifyStatus })
  }

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
          .onClick(() => {
            if (this.account) {
              this.sliderVerificationDialogController.open()
            }
          })
      }
    }
    .backgroundColor('#fff')
    .padding(20)
    .hideBackButton(true)
  }
}