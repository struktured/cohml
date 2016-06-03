module type S =
sig
  module Object :
  sig
    module View : Pofable.S
    module Holder : Pofable.S
  end
  module Entry :
  sig
    val key : unit -> Object.View.t
    val value : unit -> Object.Holder.t
  end

  module Size32 : Num
  type size32 = Size32.t
  val size : t -> size32
  val is_empty : t -> bool
  val contains_key : t -> Object.View.t -> bool
  val contains_value : t -> Object.Holder.t -> bool
  val get : t -> Object.View.t -> Object.Holder.t option
  val put : t -> Object.View.t -> Object.Holder.t -> Object.Holder.t option
  val remove : t -> Object.View.t -> Object.Holder.t option
  val put_all : t -> to_put:t -> t
end
