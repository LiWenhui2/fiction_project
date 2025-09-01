@Builder
export function LoginBuilder() {
  Login()
}

@Component
struct Login {
  build() {
    Stack() {
      Video({
        src: '43.159.41.42:3333/uploads/login_bg.mp4'
      })
    }
  }
}