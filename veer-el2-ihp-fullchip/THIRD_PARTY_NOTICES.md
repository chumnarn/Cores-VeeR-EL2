# Third-party sources

- `vendor/el2`: chumnarn/Cores-VeeR-EL2, commit `925f3a34bdadc8f28b12a70cfb73e043b0f5ef3d`, Apache-2.0. Original source and license included; no RTL edits. Configuration output is project-specific.
- IHP full-chip template: commit `0418301723d86133de686ef743cfd668bb3d11d4`, Apache-2.0. The Nix lock and bondpad assets are retained; top, core, SDC and YAML are adapted. `LICENSE-template` is included.
- `vendor/ihp-io`: IHP-Open-PDK IO simulation view at commit `5e6d592e4002946a4616f798c357f0f3c06cf3b6`. Apache-2.0, original header and license included. This reference view is not the pinned Ciel physical PDK; synthesis uses the user's installed PDK views.
- Original integration RTL, scripts, testbenches and guide in this package: Apache-2.0 unless a retained upstream header specifies otherwise.

Downloaded tools, compiled models, full PDK and third-party executable binaries are not redistributed.
