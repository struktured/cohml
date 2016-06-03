module type S =
sig
  include Coh_object.S
  module Key : Pofable.S
  module Value : Pofable.S
  module Entry :
  sig
    include Coh_object.S
    val key : unit -> Key.View.t
    val value : unit -> Value.Holder.t option
    val set_value : Value.Holder.t -> Value.Holder.t option
  end
  type size32 = int
  val size : t -> size32
  val is_empty : t -> bool
  val contains_key : t -> Key.View.t -> bool
  val contains_value : t -> Value.Holder.t -> bool
  val get : t -> Key.View.t -> Value.Holder.t option
  val put : t -> Key.View.t -> Value.Holder.t -> Value.Holder.t option
  val remove : t -> Key.View.t -> Value.Holder.t option
  val put_all : t -> to_put:t -> t
end
