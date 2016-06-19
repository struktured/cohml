module type S =
sig
  include Coh_object.S
end

include Coh_object.Make(struct type t let name = "ValueExtractor" end)

