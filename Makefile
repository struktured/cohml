# Makefile for COH*ML based on Makefile for OCI*ML

COH_HOME_CPP=$(HOME)/local/
CCFLAGS=-ccopt -I/usr/lib/ocaml -ccopt -I$(COH_HOME_CPP)/include -ccopt -Wall -Wno-permissive
COBJS=message.o messagemaplistener.o messageserializer.o cohml.o
MLOBJS=cohml.cmo log_message.cmo

OCAML_VERSION_MAJOR = `ocamlopt -version | cut -f1 -d.`
OCAML_VERSION_MINOR = `ocamlopt -version | cut -f2 -d.`
OCAML_VERSION_POINT = `ocamlopt -version | cut -f3 -d.`


all:	cohmlsh subscriber publisher message listener

cohmlsh:	$(COBJS) $(MLOBJS) 
	ocamlmktop -g -custom -o $@ -cclib -L$(COH_HOME_CPP)/lib unix.cma $(MLOBJS) $(COBJS) -cclib -lstdc++ -cclib -lcoherence 
	mkdir -p log

subscriber:	$(COBJS) $(MLOBJS) subscriber.ml
	ocamlc -g -annot -custom -o $@ unix.cma $(MLOBJS) subscriber.ml $(COBJS) -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence -cclib -lcamlrun_shared -cclib -lm

publisher:	$(COBJS) $(MLOBJS) publisher.ml
	ocamlc -g -annot -custom -o $@ -cclib -L$(COH_HOME_CPP)/lib -cclib -lm -cclib -lc -cclib -lstdc++ -cclib -lcoherence unix.cma $(MLOBJS) publisher.ml $(COBJS)

message:	$(COBJS) $(MLOBJS) message.ml
	ocamlc -g -custom -o $@ -cclib -L$(COH_HOME_CPP)/lib -cclib -lstdc++ -cclib -lcoherence unix.cma $(MLOBJS) message.ml $(COBJS)


listener:	$(COBJS) $(MLOBJS) listener.ml
	ocamlc -g -annot -custom -o $@ -cclib -L$(COH_HOME_CPP)/lib -cclib -lcoherence unix.cma $(MLOBJS) listener.ml $(COBJS)

%.o:	%.c
	ocamlc -ccopt -xc++ -ccopt -g3 -c -o $@ -ccopt -fpermissive -ccopt -I$(COH_HOME_CPP)/include -cclib -L$(COH_HOME_CPP)/lib -ccopt -fpermissive -cclib -lstdc++ -cclib -lcoherence -ccopt -DOCAML_VERSION_MINOR=$(OCAML_VERSION_MINOR) $<

%.cmo: %.ml
	ocamlc -c -g -annot unix.cma $<

clean:
	rm -f *.o *.cm* *.so *.a cohmlsh listener message subscriber publisher *~ 

# End of file
