{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, binary, blaze-html, blaze-markup
      , bytestring, cmdargs, conduit, conduit-extra, connection
      , containers, deepseq, directory, extra, filepath, foundation
      , hashable, haskell-src-exts, http-conduit, http-types, js-flot
      , js-jquery, mmap, old-locale, process-extras, QuickCheck
      , resourcet, stdenv, storable-tuple, tar, template-haskell, text
      , time, transformers, uniplate, utf8-string, vector, wai
      , wai-logger, warp, warp-tls, zlib
      }:
      mkDerivation {
        pname = "hoogle";
        version = "5.0.17.10";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        enableSeparateDataOutput = true;
        libraryHaskellDepends = [
          aeson base binary blaze-html blaze-markup bytestring cmdargs
          conduit conduit-extra connection containers deepseq directory extra
          filepath foundation hashable haskell-src-exts http-conduit
          http-types js-flot js-jquery mmap old-locale process-extras
          QuickCheck resourcet storable-tuple tar template-haskell text time
          transformers uniplate utf8-string vector wai wai-logger warp
          warp-tls zlib
        ];
        executableHaskellDepends = [ base ];
        testTarget = "--test-option=--no-net";
        homepage = "https://hoogle.haskell.org/";
        description = "Haskell API Search";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
