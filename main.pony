use collections = "collections"

actor Main
  new create(env: Env) =>
    let game: Game ref = Game
    for i in collections.Range(0, 10000) do
      env.out.print(game.string())
      game.step()
    end
