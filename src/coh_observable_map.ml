open Coh_primitives
module Map = Coh_object.Make
    (struct type t let name = "ObservableMap" end)
module Map_listener = Coh_object.Make
    (struct type t let name = "MapListener" end)
module Map_event = Coh_object.Make
    (struct type t let name = "MapEvent" end)

module type S =
sig
  include Coh_map.S
  module Filter : Coh_filter.S

  val add_key_listener : t ->
    ?lite:bool -> Map_listener.Handle.t -> Key.View.t -> t

  val remove_key_listener : t -> Map_listener.Handle.t -> t

  val add_filter_listener : t ->
    ?lite:bool -> ?filter:Filter.View.t -> Map_listener.Handle.t -> t

  val remove_filter_listener : t ->
    ?filter:Filter.View.t -> Map_listener.Handle.t -> t
end

module Derived =
struct
  module Make(Key:Coh_object.S)(Value:Coh_object.S)(T:Coh_object.T)
    : S with module Key = Key and module Value = Value =
  struct
    include Coh_map.Derived.Make(Key)(Value)(T)
    module Filter = Coh_filter.I (*TODO *)
    module Foreign =
    struct
      open Ctypes
      open Foreign

      let add_key_listener = Self.foreign "add_key_listener"
          (t @-> bool @-> Map_listener.Handle.t @-> Key.View.t @-> returning t)
      let remove_key_listener = Self.foreign "remove_key_listener"
          (t @-> Map_listener.Handle.t @-> returning t)
      let add_filter_listener = Self.foreign "add_filter_listener"
          (t @-> bool @-> Filter.View.t @-> Map_listener.Handle.t @-> returning t)
      let remove_filter_listener = Self.foreign "remove_filter_listener"
          (t @-> Filter.View.t @-> Map_listener.Handle.t @-> returning t)
    end

    let add_key_listener t ?(lite=false) =
      Foreign.add_key_listener t lite

    let remove_key_listener = Foreign.remove_key_listener
    let add_filter_listener t ?(lite=false) ?(filter=Coh_filter.noop) =
      Foreign.add_filter_listener t lite filter
    let remove_filter_listener t ?(filter=Coh_filter.noop) =
      Foreign.remove_filter_listener t filter
  end
end

module Object =
struct
  module type S = S
  module Make(Key:Coh_object.S) (Value:Coh_object.S) : 
    S with module Key = Key and module Value = Value =
  struct
    include Derived.Make(Key)(Value)(Map)
  end
end

module Pof =
struct
  module type S =
  sig
    module Key : Pofable.S
    module Value : Pofable.S
  end
  module Derived = struct
    module Make(Key:Pofable.S) (Value:Pofable.S)(T:Coh_object.T)
      : S with module Key = Key and module Value = Value =
    struct
      module D = Derived.Make(Key)(Value)(T)
      include (D : module type of D with module Key := Key and module Value := Value)
      module Key = Key
      module Value = Value
    end
  end
  module Make(Key:Pofable.S)(Value:Pofable.S) : S with module Key = Key and module Value = Value
  = struct
    include Derived.Make(Key)(Value)(Map)
  end
end
