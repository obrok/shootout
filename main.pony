use collections = "collections"

class Vec2
  let x: F32
  let y: F32

  new create(x': F32, y': F32) =>
    x = x'
    y = y'

  fun add(other: Vec2): Vec2 =>
    Vec2(x + other.x, y + other.y)

  fun neg(): Vec2 =>
    Vec2(-x, -y)

  fun scalar_product(scalar: F32): Vec2 =>
    Vec2(x * scalar, y * scalar)

  fun direction(): Vec2 =>
    Vec2(x / magnitude(), y / magnitude())

  fun magnitude(): F32 =>
    ((x * x) + (y * y)).sqrt()

class Satellite
  var _position: Vec2
  var _speed: Vec2
  let _gravity: F32 = 10
  let _step: F32 = 0.1

  new create(position: Vec2, speed: Vec2) =>
    _position = position
    _speed = speed

  fun ref step() =>
    _position = _position + _speed.scalar_product(_step)
    let force = (-_position).direction().scalar_product(_gravity / _position.magnitude() / _position.magnitude())
    _speed = _speed + force.scalar_product(_step)

  fun box string(): String iso^ =>
    let result = _position.x.string() + " " + _position.y.string()
    recover
      let result' = String
      result' .> append(result)
    end

class Game is Stringable
  let _ship: Satellite
  let _asteroid: Satellite

  new create() =>
    _ship = Satellite(Vec2(10, 0), Vec2(0.65, 1.2))
    _asteroid = Satellite(Vec2(20, 0), Vec2(0, 0.9))

  fun ref step() =>
    _ship.step()
    _asteroid.step()

  fun box string(): String iso^ =>
    let ship: String = _ship.string()
    let asteroid: String = _asteroid.string()
    recover String .> append(ship) .> append(" ") .> append(asteroid) end

actor Main
  new create(env: Env) =>
    let game: Game ref = Game
    for i in collections.Range(0, 10000) do
      env.out.print(game.string())
      game.step()
    end
