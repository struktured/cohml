module type S =
sig
  type t
  val from_pof : Pof_reader.t -> t
  val to_pof : Pof_writer.t -> t -> Pof_writer.t
end

