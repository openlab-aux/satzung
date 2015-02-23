with import <nixpkgs> {};

{
  satzung = stdenv.mkDerivation {
    name = "openlab-satzung";

    src = ./.;

    phases = [ "unpackPhase" "buildPhase" "installPhase" ];

    buildInputs = [ texLiveFull ];

    FONTCONFIG_FILE = writeText "satzung-fonts.conf" ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
      <fontconfig>
        ${lib.concatMapStrings (font: ''
          <dir>${font}</dir>
        '') [ ubuntu_font_family dejavu_fonts ]}
      </fontconfig>
    '';

    buildPhase = ''
      HOME="$(pwd)" latexmk -xelatex satzung.tex
    '';

    installPhase = ''
      install -vD -m 0644 satzung.pdf "$out/satzung.pdf"
      mkdir -p "$out/nix-support"
      echo "doc-pdf satzung $out/manual.pdf" \
        > "$out/nix-support/hydra-build-products"
    '';
  };
}
