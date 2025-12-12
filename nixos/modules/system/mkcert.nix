{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.mkcert;

  # Generate CA at build time
  mkcertCA =
    pkgs.runCommand "mkcert-ca"
      {
        buildInputs = [ pkgs.mkcert ];
      }
      ''
        mkdir -p $out
        export CAROOT=$out
        export HOME=$out
        ${pkgs.mkcert}/bin/mkcert -install
      '';

   # Generate a certificate for a set of domains
   mkCert =
     name: domains:
     pkgs.runCommand "mkcert-${name}"
       {
         buildInputs = [ pkgs.mkcert ];
       }
       ''
         mkdir -p $out
         export CAROOT=${mkcertCA}
         export HOME=$out
         cd $out
         ${pkgs.mkcert}/bin/mkcert ${concatStringsSep " " domains}

         # Rename to predictable names
         # mkcert creates files named like "domain.pem" and "domain-key.pem"
         # Use find to ensure we get the right files
         key_file=$(find $out -name "*-key.pem" | head -n1)
         if [ -z "$key_file" ]; then
           echo "Error: Could not find key file"
           exit 1
         fi

         cert_file=$(find $out -name "*.pem" | grep -v -- "-key.pem" | head -n1)
         if [ -z "$cert_file" ]; then
           echo "Error: Could not find certificate file"
           exit 1
         fi

         mv "$cert_file" cert.pem
         mv "$key_file" key.pem
       '';

  # Generate all configured certificates
  certDerivations = mapAttrs mkCert cfg.certs;
in
{
  options.services.mkcert = {

    certs = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = { };
      description = ''
        Certificates to generate. Each attribute name becomes the cert name,
        and the value is a list of domains/IPs for that certificate.

        Example:
          certs.actual = [ "actual.local" "localhost" "127.0.0.1" ];
      '';
      example = {
        actual = [
          "actual.local"
          "localhost"
          "127.0.0.1"
        ];
        jellyfin = [
          "jellyfin.local"
          "192.168.1.100"
        ];
      };
    };
  };

  config = {
    environment.systemPackages = [ pkgs.mkcert ];

    # Trust the CA system-wide
    security.pki.certificates = [
      (builtins.readFile "${mkcertCA}/rootCA.pem")
    ];

    # Install CA files and generated certificates
    environment.etc = {
      "mkcert/rootCA.pem".source = "${mkcertCA}/rootCA.pem";
      "mkcert/rootCA-key.pem".source = "${mkcertCA}/rootCA-key.pem";
    }
    // lib.concatMapAttrs (name: deriv: {
      "mkcert/certs/${name}/cert.pem".source = "${deriv}/cert.pem";
      "mkcert/certs/${name}/key.pem".source = "${deriv}/key.pem";
    }) certDerivations;
  };
}
