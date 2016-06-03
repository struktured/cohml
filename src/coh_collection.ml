open Coh_primitives
module type S =
sig
include Coh_object.S
module Object : Coh_object.S
module Iterator : Coh_iterator.S with module Object = Object
val size : t -> size32
val is_empty : t -> bool
val contains : t -> Object.View.t -> bool
val contains_all : t -> View.t -> bool
val iterator : t -> Iterator.Handle.t
end

