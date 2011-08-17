# Makefile for COH*ML based on Makefile for OCI*ML

COH_HOME_CPP=/opt/coherence-cpp
CCFLAGS=-ccopt -I/usr/lib/ocaml -ccopt -I$(COH_HOME_CPP)/include -ccopt -Wall
COBJS=message.o messageserializer.o cohml.o
MLOBJS=cohml.cmo log_message.cmo

cohmlsh:	$(COBJS) $(MLOBJS)
	ocamlmktop -g -custom -o $@ -ccopt -L$(COH_HOME_CPP)/lib -ccopt -lcoherence unix.cma $(MLOBJS) $(COBJS)
	mkdir -p log

message:	$(COBJS) $(MLOBJS) message.ml
	ocamlc -g -custom -o $@ -cclib -L$(COH_HOME_CPP)/lib -cclib -lcoherence unix.cma $(MLOBJS) message.ml $(COBJS)


listener:	$(COBJS) $(MLOBJS) listener.ml
	ocamlc -g -custom -o $@ -cclib -L$(COH_HOME_CPP)/lib -cclib -lcoherence unix.cma $(MLOBJS) listener.ml $(COBJS)

%.o:	%.c
	ocamlc -ccopt -xc++ -ccopt -g3 -c -o $@ -ccopt -I$(COH_HOME_CPP)/include -ccopt -L$(COH_HOME_CPP)/lib -ccopt -lcoherence $<

%.cmo: %.ml
	ocamlc -c -g unix.cma $<

clean:
	rm -f *.o *.cm* *.so *.a cohmlsh listener message

# End of file