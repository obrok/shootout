use "path:/usr/local/Cellar/glfw/3.1.2/lib"
use "lib:GL/glew"
use "lib:glfw3.3.1"

use @glfwInit[Bool]()
use @glfwWindowHint[None](target: I32, hint: I32)
use @glfwCreateWindow[Window](width: I32, height: I32, title: Window, monitor: Monitor, share: Window)
use @glfwMakeContextCurrent[None](window: Window)
use @glfwGetPrimaryMonitor[Window]()
use @glfwPollEvents[None]()
use @glfwSwapBuffers[None](window: Window)
use @glfwGetKey[I32](window: Window, key: I32)
use @glewInit[U32]()

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
primitive GLEWOK fun apply(): U32 => 0

actor@ Renderer
  var window: Window = Window
  var _die: Bool = false
  var _death_message: String = ""

  new create() =>
    if not @glfwInit() then
      die("GLFW failed to init")
    end

    @glfwWindowHint(GLFWSamples(), 4)
    @glfwWindowHint(GLFWContextVersionMajor(), 3)
    @glfwWindowHint(GLFWContextVersionMinor(), 2)
    @glfwWindowHint(GLFWOpenglForwardCompat(), GLTrue())
    @glfwWindowHint(GLFWOpenglProfile(), GLFWOpenglCoreProfile())

    let title = "Shootout"
    window = @glfwCreateWindow(1024, 786, title.cstring(), Monitor, Window)
    @glfwMakeContextCurrent(window)

    if @glewInit() != GLEWOK() then
      die("GLEW failed to init")
    end

  be render() =>
    /* draw() */

    @glfwSwapBuffers(window)
    @glfwPollEvents()

    if @glfwGetKey(window, GLFWKeyEscape()) == GLFWPress() then
      die("ESC pressed")
    end

  fun ref die(message: String) =>
    _die = true
    _death_message = message

  fun dead(): Bool =>
    _die

  fun death_message(): Pointer[U8] tag =>
    _death_message.cstring()
