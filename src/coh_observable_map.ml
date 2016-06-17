open Coh_primitives
open Ctypes
open Foreign

module Map = Coh_object.Make
  (struct type t let name = "ObservableMap" end)
module Map_listener =
  Coh_object.Make(struct type t let name = "MapListener" end)
module Map_event = Coh_object.Make(
  struct type t let name = "MapEvent" end)

module type S =
sig
include Coh_map.S with module Self = Map.Self
module Filter : Coh_filter.S

val add_key_listener : t ->
  ?lite:bool -> Map_listener.Handle.t -> Key.View.t -> t

val remove_key_listener : t -> Map_listener.Handle.t -> t

val add_filter_listener : t ->
  ?lite:bool -> ?filter:Filter.View.t -> Map_listener.Handle.t -> t

val remove_filter_listener : t ->
  ?filter:Filter.View.t -> Map_listener.Handle.t -> t
end

module Object =
struct
module type S = S
module Make(Key:Coh_object.S) (Value:Coh_object.S) S with module Key = Key and module Value = Value =
struct
  module Parent = struct include Coh_map.Make(Key)(Value) end
  include Derived.Make(Key)(Value)(Coh_map)
end
end

module Pof =
struct
module type S =
sig
  module Key : Pofable.S
  module Value : Pofable.S
end

module Make(Key:Pofable.S) (Value:Pofable.S)  : S with module Key = Key and module Value = Value  =
struct
  module Parent = struct include Coh_map.Make(Key)(Value) end
  module D = Derived.Make(Key)(Value)(Coh_map)
  include (D : module type of D with module Key := Key and module Value := Value)
  module Key = Key
  module Value = Value
end

module Derived = struct
module Make(Key:Pofable.S)(Value:Pofable.S)(T:Coh_object.T)
= struct
  module Parent = struct include Coh_map.Derived.Make(Key)(Value)(T) end
  include Derived.Make(Key)(Value)(Coh_map)
end
