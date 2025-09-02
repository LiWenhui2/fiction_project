class navStack extends NavPathStack{
  static stack:navStack
  getStack(){
    if (!navStack.stack) {
      navStack.stack=new navStack()
    }
    return navStack.stack
  }
}
const stack:navStack=new navStack().getStack()
export default stack