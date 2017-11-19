class Vec2
  let x: F32
  let y: F32

  new val create(x': F32 val, y': F32 val) =>
    x = x'
    y = y'

  fun val add(other: Vec2 val): Vec2 val =>
    Vec2(x + other.x, y + other.y)

  fun val neg(): Vec2 val =>
    Vec2(-x, -y)

  fun val scalar_product(scalar: F32 val): Vec2 val =>
    Vec2(x * scalar, y * scalar)

  fun val direction(): Vec2 val =>
    Vec2(x / magnitude(), y / magnitude())

  fun val magnitude(): F32 val =>
    ((x * x) + (y * y)).sqrt()

class Satellite
  var _position: Vec2 val
  var _speed: Vec2 val
  let _gravity: F32 val = 10
  let _step: F32 val = 1

  new create(position': Vec2 val, speed: Vec2 val) =>
    _position = position'
    _speed = speed

  fun ref step() =>
    _position = _position + _speed.scalar_product(_step)
    let force = (-_position).direction().scalar_product(_gravity / _position.magnitude() / _position.magnitude())
    _speed = _speed + force.scalar_product(_step)

  fun box position(): Vec2 val =>
    _position

class Game
  let _ship: Satellite
  let _asteroid: Satellite

  new create() =>
    _ship = Satellite(Vec2(10, 0), Vec2(0.65, 1.2))
    _asteroid = Satellite(Vec2(20, 0), Vec2(0, 0.9))

  fun ref step() =>
    _ship.step()
    _asteroid.step()

  fun box objects(): Array[Vec2 val] val =>
    let p1 = _ship.position()
    let p2 = _asteroid.position()
    [p1; p2]
