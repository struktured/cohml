open Ctypes
open Foreign

module type S =
  sig
    module Key : Pofable.S
    module Value : Pofable.S
    include Coh_entry.S with module Key := Key and module Value := Value
  end

module Make(Key:Pofable.S)(Value:Pofable.S) :
  S with module Key = Key and module Value = Value =
struct
  module Key = Key
  module Value = Value
  module Entry_t = Coh_entry.Make(Key)(Value)
  include (Entry_t : S with module Key := Key and module Value := Value)
end

