use "files"

actor Main
  new create(env: Env) =>
    None

actor@ RealMain
  let _auth: (AmbientAuth | None)

  new create(auth: (AmbientAuth | None)) =>
    _auth = auth

    try
      let auth' = auth as AmbientAuth
      let caps = recover val FileCaps.>set(FileRead).>set(FileWrite).>set(FileCreate).>set(FileStat) end
      let path = FilePath(auth', "bork.txt", caps)?

      with file = CreateFile(path) as File do
        file.print("Hello")
      end
    else
      None
    end
