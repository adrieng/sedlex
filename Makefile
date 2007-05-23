VERSION=1.0

ALL=pa_ulex.cma ulexing.cma
OCAMLBUILD=ocamlbuild -byte-plugin

all::
	$(OCAMLBUILD) $(ALL)
all.opt::
	$(OCAMLBUILD) $(ALL) $(ALL:.cma=.cmxa)

MODS=ulexing utf16 utf8

install: all
	cd _build && $(MAKE) -f ../Makefile realinstall

realinstall:
	ocamlfind install ulex ../META $(wildcard $(MODS:=.mli) $(MODS:=.cmi) $(MODS:=.cmx) pa_ulex.cma ulexing.a ulexing.cma ulexing.cmxa)

uninstall:
	ocamlfind remove ulex

clean:
	$(OCAMLBUILD) -clean
	rm -f *~ *.html *.css *.tar.gz

view_test: all
	camlp4o -printer ocaml ./_build/pa_ulex.cma test.ml

run_test:
	ocamlbuild test.byte
	./test.byte

custom_ulexing.byte:
	$(OCAMLBUILD) custom_ulexing.byte

doc:
	ocamldoc -html ulexing.mli

PACKAGE = ulex-$(VERSION)
DISTRIB = CHANGES LICENSE META README Makefile *.ml *.mli
.PHONY: package
package: clean
	rm -Rf $(PACKAGE)
	mkdir $(PACKAGE)
	cp -R $(DISTRIB) $(PACKAGE)/
	tar czf $(PACKAGE).tar.gz $(PACKAGE)
	rm -Rf $(PACKAGE)

upload: 
	$(MAKE) package
	rsync -avz $(PACKAGE).tar.gz cduce@di.ens.fr:public_html/download
	$(MAKE) doc
	rsync -avz *.html *.css cduce@di.ens.fr:public_html/ulex