use "path:/usr/local/Cellar/glfw/3.1.2/lib"
use "lib:GL/glew"
use "lib:glfw3.3.1"
use "itertools"

use @glfwInit[Bool]()
use @glfwWindowHint[None](target: I32, hint: I32)
use @glfwCreateWindow[Window](width: I32, height: I32, title: Window, monitor: Monitor, share: Window)
use @glfwMakeContextCurrent[None](window: Window)
use @glfwGetPrimaryMonitor[Window]()
use @glfwPollEvents[None]()
use @glfwSwapBuffers[None](window: Window)
use @glfwGetKey[I32](window: Window, key: I32)

use @glewInit[U32]()

use @glGenBuffers[None](number: ISize, target: Pointer[GLVBO] ref)
use @glGenVertexArrays[None](number: ISize, target: Pointer[GLVAO] ref)
use @glBindBuffer[None](target: GLenum, buffer: GLVBO)
use @glBindVertexArray[None](vao: GLVAO)
use @glBufferData[None](target: GLenum, size: GLsizeiptr, data: Pointer[F32] tag, usage: GLenum)
use @glCreateShader[GLShader](kind: GLenum)
use @glShaderSource[None](shader: GLShader, no_of_sources: GLsizei, sources: Pointer[Pointer[U8] tag] tag, lengths: VoidPtr)
use @glCompileShader[None](shader: GLShader)
use @glCreateProgram[GLProgram]()
use @glAttachShader[None](program: GLProgram, shader: GLShader)
use @glLinkProgram[None](program: GLProgram)
use @glUseProgram[None](program: GLProgram)
use @glGetAttribLocation[GLuint](program: GLProgram, name: Pointer[U8] tag)
use @glVertexAttribPointer[None](index: GLuint, input_dimension: GLint, data_type: GLenum, normalize: GLenum, stride: GLsizei, offset: VoidPtr)
use @glEnableVertexAttribArray[None](index: GLuint)
use @glDrawArrays[None](mode: GLenum, first: GLint, count: GLsizei)
use @glGetError[GLenum]()
use @glGetShaderiv[None](shader: GLShader, info_type: GLenum, result_out: Pointer[GLint] ref)
use @glGetProgramiv[None](program: GLProgram, info_type: GLenum, result_out: Pointer[GLint] ref)
use @glBindFragDataLocation[None](program: GLProgram, color_number: GLuint, name: Pointer[U8] tag)
use @glClear[None](buffer: GLenum)
use @glClearColor[None](r: F32, g: F32, b: F32, a: F32)

type VoidPtr is Pointer[U8] tag
type Window is VoidPtr
type Monitor is VoidPtr
type GLint is I32
type GLuint is U32
type GLenum is U32
type GLVBO is GLuint
type GLVAO is GLuint
type GLShader is GLuint
type GLProgram is GLuint
type GLsizeiptr is ISize
type GLsizei is ISize

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

primitive GLFalse
  fun apply(): GLenum => 0
  fun as_i32(): I32 => 0

primitive GLTrue
  fun apply(): GLenum => 1
  fun as_i32(): I32 => 1

primitive GLArrayBuffer fun apply(): GLenum => 0x8892
primitive GLStaticDraw fun apply(): GLenum => 0x88E4
primitive GLFragmentShader fun apply(): GLenum => 0x8B30
primitive GLVertexShader fun apply(): GLenum => 0x8B31
primitive GLFloat fun apply(): GLenum => 0x1406
primitive GLTriangles fun apply(): GLenum => 0x0004
primitive GLCompileStatus fun apply(): GLenum => 0x8B81
primitive GLLinkStatus fun apply(): GLenum => 0x8B82
primitive GLColorBufferBit fun apply(): GLenum => 0x00004000

primitive VertexShader fun apply(): String => """
  #version 150 core

  in vec2 position;

  void main()
  {
    gl_Position = vec4(position, 0.0, 1.0);
  }
"""

primitive FragmentShader fun apply(): String => """
  #version 150 core

  out vec4 outColor;

  void main()
  {
      outColor = vec4(1.0, 1.0, 1.0, 1.0);
  }
"""

actor@ Renderer
  var _window: Window = Window
  var _die: Bool = false
  var _death_message: String = ""
  var _program: GLProgram = GLProgram(0)
  var _message: String = ""
  var _objects: Array[Vec2 val] val = [Vec2(0.0, 0.5); Vec2(0.5, -0.5); Vec2(-0.5, -0.5)]
  var _buffer: GLVBO = GLVBO(0)
  var _counter: I32 = 1

  new create() =>
    if not @glfwInit() then
      die("GLFW failed to init")
    end

    @glfwWindowHint(GLFWSamples(), 4)
    @glfwWindowHint(GLFWContextVersionMajor(), 3)
    @glfwWindowHint(GLFWContextVersionMinor(), 2)
    @glfwWindowHint(GLFWOpenglForwardCompat(), GLTrue.as_i32())
    @glfwWindowHint(GLFWOpenglProfile(), GLFWOpenglCoreProfile())

    let title = "Shootout"
    _window = @glfwCreateWindow(1024, 786, title.cstring(), Monitor, Window)
    @glfwMakeContextCurrent(_window)

    if @glewInit() != GLEWOK() then
      die("GLEW failed to init")
    end

    let vao = _gen_vao()
    @glBindVertexArray(vao)

    let buffer = _gen_buffer()
    @glBindBuffer(GLArrayBuffer(), buffer)

    let vertex_shader = _compile_shader(GLVertexShader(), VertexShader())
    let fragment_shader = _compile_shader(GLFragmentShader(), FragmentShader())
    _program = @glCreateProgram()
    @glAttachShader(_program, vertex_shader)
    @glAttachShader(_program, fragment_shader)
    @glBindFragDataLocation(_program, 0, "outColor".cstring())
    @glLinkProgram(_program)
    @glUseProgram(_program)

    let pos_attr = @glGetAttribLocation(_program, "position".cstring())
    @glEnableVertexAttribArray(pos_attr)
    @glVertexAttribPointer(pos_attr, 2, GLFloat(), GLFalse(), 0, VoidPtr)

  be render() =>
    @glfwPollEvents()

    let code = @glGetError()
    if @glfwGetKey(_window, GLFWKeyEscape()) == GLFWPress() then
      die("ESC pressed. Status: " + code.string())
    end

    @glClearColor(0, 0, 0, 0)
    @glClear(GLColorBufferBit())
    let start: GLint = 0
    let vertices = _upload_state_to_buffer()
    @glDrawArrays(GLTriangles(), start, vertices)

    @glfwSwapBuffers(_window)

  be update_state(objects: Array[Vec2 val] val) =>
    _counter = _counter + 1
    _message = _counter.string()
    _objects = objects
    this.render()

  fun _upload_state_to_buffer(): GLsizei =>
    let vertices = _vertices_from_state()
    let float_size = ISize(4)
    @glBufferData(GLArrayBuffer(), ISize.from[USize](vertices.size()) * float_size, vertices.cpointer(), GLStaticDraw())
    ISize.from[USize](vertices.size() / 2)

  fun _vertices_from_state(): Array[F32] =>
    Iter[Vec2 val](_objects.values())
      .flat_map[F32]({(v: Vec2 val): Iterator[F32] =>
        let x = v.x / 400
        let y = v.y / 400
        [
          x; y
          x + 0.01; y - 0.02
          x - 0.01; y - 0.02
        ].values()
      })
      .collect(Array[F32](_objects.size() * 2))

  fun _compile_shader(kind: GLenum, text: String): GLShader =>
    let shader = @glCreateShader(kind)
    var text' = text.cstring()
    @glShaderSource(shader, 1, addressof text', VoidPtr)
    @glCompileShader(shader)
    shader

  fun _gen_buffer(): GLVBO =>
    var buffer = GLVBO(0)
    @glGenBuffers(1, addressof buffer)
    buffer

  fun _gen_vao(): GLVAO =>
    var vao = GLVAO(0)
    @glGenVertexArrays(1, addressof vao)
    vao

  fun ref die(death_message': String) =>
    _die = true
    _death_message = death_message'

  fun dead(): Bool =>
    _die

  fun death_message(): Pointer[U8] tag =>
    _death_message.cstring()

  fun message(): Pointer[U8] tag =>
    _message.cstring()
