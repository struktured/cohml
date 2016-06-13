open Coh_primitives

module type S =
sig
  include Coh_object.S
  module Key : Coh_object.S
  module Value : Coh_object.S
module Entry :
  sig
    module Key : module type of Key
    module Value : module type of Value
    include Coh_object.S
    val get_key : t -> Key.View.t
    val get_value : t -> Value.Holder.t option
    val set_value : t -> Value.Holder.t -> Value.Holder.t option
  end
  (*module Entry : Entry.S with module Key = Key and module Value = Value*)
  val size : t -> size32
  val is_empty : t -> bool
  val contains_key : t -> Key.View.t -> bool
  val contains_value : t -> Value.Holder.t -> bool
  val get : t -> Key.View.t -> Value.Holder.t option
  val put : t -> Key.View.t -> Value.Holder.t -> Value.Holder.t option
  val remove : t -> Key.View.t -> Value.Holder.t option
  val put_all : t -> to_put:t -> t
end

module Derived = struct
module Make(Key:Coh_object.S)(Value:Coh_object.S)(T:Coh_object.T) :
S with module Key = Key and module Value = Value and module Self.T = T =
struct
  module Key = Key
  module Value = Value
  include Coh_object.Make(T)
  module Entry =
  struct
    module Key = Key
    module Value = Value
    include Coh_object.Make(T)
    let get_key t = failwith("nyi")
    let get_value t = failwith("nyi")
    let set_value t v = failwith("nyi")
    let to_pof t b = failwith("nyi")
    let from_pof b = failwith("nyi")
  end
    let size t = failwith("nyi")
    let is_empty t = failwith("nyi")
    let contains_key t = failwith("nyi")
    let contains_value t = failwith("nyi")
    let get t = failwith("nyi")
    let put t = failwith("nyi")
    let remove t = failwith("nyi")
    let put_all t = failwith("nyi")
end (* Derived.Make *)
end (* Derived *)
module Make(Key:Coh_object.S)(Value:Coh_object.S) =
  Derived.Make(Key)(Value)(Coh_object.Opaque)
(*
module Pof = struct
module type S =
  sig
    module Key : Pofable.S
    module Value : Pofable.S
    module Entry : Entry.Pof.S with module Key = Key and module Value = Value
    include Object.S with module Key := Key and module Value := Value and module Entry := Entry
  end (* Pof.S *)

end (* Pof *)
*)

module Opaque = Make(Coh_object.Opaque)(Coh_object.Opaque)
include Opaque
