# Darwin Upgrade Parked (2026-05-27)

## Status
Upgrade attempt is intentionally paused.

Branch at pause point:
- chore/safe-upgrade-branch-alignment

## What Was Already Fixed
These migration-level issues were addressed on the upgrade branch:
- mariadb-client -> mariadb.client
- gh-copilot -> github-copilot-cli
- neofetch -> fastfetch (including alias updates)

## Why The Build Still Fails
The remaining failures are infra/store-level and substitution-related, not primarily module-logic errors.

Observed failure chain:
1. Lower-level substitute/store failures occur first.
2. Example hard failure: create_hard_link "File exists" under /nix/store/.links.
3. Substitute failures then fan out through large dependency closures (for example eigen/opencv stacks or texlive-related stacks).
4. Cascading derivation failures reach system-applications, then system-path, and finally darwin-system.

Important note:
- darwin-system is the final aggregator failure in this case, not the first root failure.

## Practical Resume Plan
When resuming, start with low-noise diagnostics before another full check run:
1. Capture first failing derivation from validation output.
2. Inspect whether failure is substitute-related, local-store link collision, or an actual build script/config issue.
3. Only after root failure is classified, retry full validation.

## Parking Decision
No further upgrade retries for now.
Keep branch as a parked workstream and resume later from this point.
