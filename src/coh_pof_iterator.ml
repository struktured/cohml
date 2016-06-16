module type S =
sig
module Object : Pofable.S
include Coh_iterator.S with module Object := Object
end


module Pof(Object:Pofable.S) : S with module Object = Object =
struct
  module Iterator = Coh_iterator.Make(Object)
  include (Iterator : S with module Object := Object)
  module Object = Object
end

