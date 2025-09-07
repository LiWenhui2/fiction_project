const alertDialogController: CustomDialogController = new CustomDialogController({
  builder:alertDialog,
  backgroundColor: '#0f0e13',
  width: 200,
  height: 50,
  cornerRadius: 15,
  isModal: false
})
@Builder
function alertDialog() {
  Text('用户未注册')
    .fontColor('#fff')
    .padding(15)
    .backgroundColor('#0f0e13')
    .width(200)
    .height(50)
    .fontWeight(500)
    .textAlign(TextAlign.Center)
}
@Component
export struct ShowAlert {
  build() {
  }
}
export default alertDialogController