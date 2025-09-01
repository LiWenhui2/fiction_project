import axios from '../utils/HttpRequest'
import data from '../../../mock/userAgreementData.json'
@Entry
@ComponentV2
struct Start {
  @Local agreement: Record<string, string[]> = {
    'summary': []
  }
  startDialog: CustomDialogController = new CustomDialogController({
    builder: this.startDialogBuilder,
    width:300,

    cornerRadius:8
  })

  @Builder
  startDialogBuilder() {
    Column({space:20}) {
      Text('欢迎使用番茄免费小说')
        .width('100%')
        .fontSize(18)
        .fontWeight(500)
        .textAlign(TextAlign.Center)
        .fontColor('#030303')
      List({space:15}) {
        ForEach(this.agreement['summary'], (text: string) => {
          ListItem(){
            Text(text)
              .fontColor('#434343')
          }
        })
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height(200)
      Column({space:10}){
        Text('不同意')
          .fontColor('#9a9a9a')
          .fontWeight(300)
          .fontSize(14)
        Button('同意并继续')
          .width('100%')
          .backgroundColor('#f86724')
          .fontColor('#fff')
          .fontSize(18)
          .fontWeight(600)
          .padding(5)
      }
    }
    .padding({left:20,right:20,top:40,bottom:20})
  }

  aboutToAppear(): void {
   this.agreement['summary']=data.agreementData.summary
    setTimeout(() => {
      this.startDialog.open()
    }, 500)
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