defmodule AlchemistLibrary.Cache do
  use Nebulex.Cache,
    otp_app: :alchemist_library,
    adapter: NebulexRedisAdapter
end
