module type S =
sig
  module View : Pof.S
  include Map.S
  
  val put_all : to_put:t -> t -> t
end
