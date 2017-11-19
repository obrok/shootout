use "time"

actor@ RealMain
  let _auth: (AmbientAuth | None)
  let _renderer: Renderer tag
  let _game_manager: GameManager tag

  new create(auth: (AmbientAuth | None), renderer: Renderer) =>
    _auth = auth
    _renderer = renderer
    _game_manager = GameManager(renderer)
    let timers = Timers
    let timer = Timer(Notify(this), 0, 1_000_000_000 / 60)
    timers(consume timer)

  be trigger_tick() =>
    _game_manager.tick()

class Notify is TimerNotify
  let _main: RealMain tag

  new iso create(main: RealMain tag) =>
    _main = main

  fun ref apply(timer: Timer, count: U64): Bool =>
    _main.trigger_tick()
    true
