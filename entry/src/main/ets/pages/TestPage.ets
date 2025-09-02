import { camera, cameraPicker } from '@kit.CameraKit'
import { common } from '@kit.AbilityKit'

@Entry
@Component
struct TestPage {
  @State imgUrl: string = ''
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext

  build() {
    Column() {
      Image(this.imgUrl)
      Button('相机')
        .onClick(async () => {
          const res = await cameraPicker.pick(this.context,
            [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO],
            {
              cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
            })
          this.imgUrl = res.resultUri
        })
    }
    .height('100%')
    .width('100%')
  }
}