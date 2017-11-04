actor@ RealMain
  let _auth: (AmbientAuth | None)
  let _renderer: Renderer tag

  new create(auth: (AmbientAuth | None), renderer: Renderer) =>
    _auth = auth
    _renderer = renderer
    this.trigger_render()

  be trigger_render() =>
    _renderer.render()
    this.trigger_render()
