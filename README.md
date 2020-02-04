![](https://github.com/puripuri2100/xml2saty/workflows/CI/badge.svg)


# xml2saty

This software converts xml file to SATySFi's document file.


# Install using OPAM

Here is a list of minimally required softwares.

* git
* make
* [opam](https://opam.ocaml.org/) 2.0
* ocaml (>= 4.06.0) (installed by OPAM)


## Example

### Install opam (Ubuntu)

```sh
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)

eval $(opam env)
```

### Install ocaml (Ubuntu)

```sh
opam init --comp 4.07.0
```

### Install ocaml (Ubuntu on WSL)

```sh
opam init --comp 4.07.0 --disable-sandboxing
```

### Install opam's library

```sh
opam install xml-light
opam install menhir
```

### Build

```sh
git clone https://github.com/puripuri2100/xml2saty.git
cd xml2saty

make build
```


# Usage of xml2saty

Type

```sh
xml2saty <input file> -o <output file> -c <config file>
```

## Starting out

```sh
make example
```

If `example/gengou.saty` and `example/keihou.saty` are created, then the setup has been finished correctly.

---

This software released under [the MIT license](https://github.com/puripuri2100/xml2saty/blob/master/LICENSE).

Copyright (c) 2020 Naoki Kaneko (a.k.a. "puripuri2100")