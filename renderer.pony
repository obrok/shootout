use "path:/usr/local/Cellar/glfw/3.1.2/lib"
use "lib:glfw3.3.1"

use @glfwInit[Bool]()
use @glfwWindowHint[None](target: I32, hint: I32)
use @glfwCreateWindow[Window](width: I32, height: I32, title: Window, monitor: Monitor, share: Window)
use @glfwMakeContextCurrent[None](window: Window)
use @glfwGetPrimaryMonitor[Window]()
use @glfwPollEvents[None]()
use @glfwGetKey[I32](window: Window, key: I32)

type Window is Pointer[U8] tag
type Monitor is Pointer[U8] tag

primitive GLTrue fun apply(): I32 => 1
primitive GLFWSamples fun apply(): I32 => 0x0002100D
primitive GLFWContextVersionMajor fun apply(): I32 => 0x00022002
primitive GLFWContextVersionMinor fun apply(): I32 => 0x00022003
primitive GLFWOpenglForwardCompat fun apply(): I32 => 0x00022006
primitive GLFWOpenglProfile fun apply(): I32 => 0x00022008
primitive GLFWOpenglCoreProfile fun apply(): I32 => 0x00032001
primitive GLFWClientApi fun apply(): I32 => 0x00022001
primitive GLFWOpenglApi fun apply(): I32 => 0x00030001
primitive GLFWKeyEscape fun apply(): I32 => 256
primitive GLFWPress fun apply(): I32 => 1

actor@ Renderer
  let window: Window
  var _die: Bool = false

  new create() =>
    @glfwInit()

    @glfwWindowHint(GLFWSamples(), 4)
    @glfwWindowHint(GLFWContextVersionMajor(), 3)
    @glfwWindowHint(GLFWContextVersionMinor(), 2)
    @glfwWindowHint(GLFWOpenglForwardCompat(), GLTrue())
    @glfwWindowHint(GLFWOpenglProfile(), GLFWOpenglCoreProfile())

    let title = "Shootout"
    window = @glfwCreateWindow(1024, 786, title.cstring(), Monitor, Window)
    @glfwMakeContextCurrent(window)

  be render() =>
    @glfwPollEvents()
    if @glfwGetKey(window, GLFWKeyEscape()) == GLFWPress() then
      _die = true
    end

  fun dead(): Bool =>
    _die
