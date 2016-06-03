module type S =
sig
  include Coh_object.S
  val from_pof : Pof_reader.t -> t
  val to_pof : Pof_writer.t -> t -> Pof_writer.t
end

