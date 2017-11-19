actor GameManager
  let _game: Game = Game
  let _renderer: Renderer tag

  new create(renderer: Renderer) =>
    _renderer = renderer

  be tick() =>
    _game.step()
    _renderer.update_state(_game.objects())
