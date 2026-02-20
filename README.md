# codegen flake module

Declarative configuration for vendoring auto generated files in your repo.  Includes a single command to regenerate everything, and integrates with `nix flake check` to ensure all your auto generated files are up-to-date.

## Usage

In your flake, add this module (assuming you use [flake.parts](https://flake.parts), and set the following configuration:

```nix
{
  inputs.codegen.url = "github:anteriorcore/codegen";
  # ...

  outputs = { ... }@inputs: {
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      # ...
      imports = [
        inputs.codegen.flakeModule.default
        ({
          perSystem =
            { self', ... }:
            {
              codegen = {
                enable = true;
                root = ./.;
                files ={
                  ".github/workflows".source = "${self'.packages.github-actions}/";
                  ".nixos.version".text = "${inputs.nixpkgs.shortRev}\n";
                };
              };
            };
        })
      ];
    };
}
```

Regenerate all files:

```command
$ nix run .#codegen
```

Check files are up to date:

```command
$ nix flake check
```

See the generated output without affecting your working directory:

```command
$ nix build .#codegen
```

## Copyright & License

Codegen Flake Module is authored by [Anterior](https://anterior.com), based in NYC, USA.

**We’re hiring!** If you got this far, e-mail us at hiring+oss@anterior.com and mention codegen.

The code is available under the AGPLv3 license (not later).

See the [LICENSE](LICENSE) file.

## No warranty.  Seriously.

This project is _actually_ provided as-is: the license text truly applies.  We release this source code in the hopes that it will be useful to anyone, but we reserve the right to:

- change the API at any time
- introduce backwards incompatible changes
- force-push commits which change git history
- never fix bugs which don’t affect us, even if we know about them
- not accept pull requests
- introduce changes which are only useful for us, Anterior.

Seriously though!  Please be warned this is just a source code release under the AGPLv3.  It is not a commitment to becoming long time maintainers of this project for public consumption.  We want to give back code, and we really do hope this is useful to you, but we’re too busy to be maintainers at the moment.  The license says it very well:

> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU Affero General Public License for more details.

We hope by being super clear about this, here, in the readme, that nobody will be upset down the line if we ignore your PRs, or disable github issues.

That said: happy hacking!

Thank you.
