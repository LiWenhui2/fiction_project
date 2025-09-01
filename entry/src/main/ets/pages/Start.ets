import axios from '../utils/HttpRequest'

@Entry
@ComponentV2
struct Start {
  @Local agreement: Record<string, string[]> = {
    'summary': []
  }
  startDialog: CustomDialogController = new CustomDialogController({
    builder: this.startDialogBuilder
  })

  @Builder
  startDialogBuilder() {
    Column() {
      Text('欢迎使用番茄免费小说')
        .width('100%')
      Column() {
        ForEach(this.agreement['summary'], (text: string) => {
          Text(text)
        })
      }
    }
    .width(280)
    .height(300)
  }

  aboutToAppear(): void {
    this.getAgreementContext()
    setTimeout(() => {
      this.startDialog.open()
    }, 500)
  }

  async getAgreementContext() {
    const context = await axios.get('user/getAgreement')
    this.agreement['summary'] = context['data']['summary']
    console.log(JSON.stringify(this.agreement['summary']))
  }

  build() {
    Column() {
      Stack() {
        Image($r('app.media.start'))
          .width('100%')
          .objectFit(ImageFit.Fill)
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      }
    }
    .height('100%')
    .width('100%')
  }
}