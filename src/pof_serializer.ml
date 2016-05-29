module type S =
sig
  val serialize : Pof_writer.t -> 'a -> Pof_writer.t
  val deserializer : Pof_reader.t -> 'a
end

