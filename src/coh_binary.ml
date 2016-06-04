module type S =
sig
include Coh_object.S
end

module I : S = Coh_object.Opaque
include I
