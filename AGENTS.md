# Package repository maintenance

- Repository: `7hefg/packages`; source URL: `https://7hefg.github.io/packages/`.
- Display name: `7he`. Keep the repository name, source URL, and Release codename `packages` unchanged when updating branding.
- This workspace serves an APT repository, not a plugin build. Do not build a deb for site-only changes.
- Check shell syntax with `bash -n scripts/update-repository.sh` and review changes with the git tools.
- Full index generation uses `scripts/update-repository.sh` on Debian/Ubuntu with `apt-ftparchive`, `xz`, and optional `qrencode`. The on-device environment lacks these tools; do not install them merely for branding changes.
- A push to `main` changing the homepage or index script triggers `.github/workflows/update-repository.yml`, which builds indexes and deploys GitHub Pages. Push only when requested.
- After deployment, fetch the source homepage, `Release`, and `Packages` to verify the live title, Origin/Label, and package index. An empty Packages file is expected until a package is published.
- Never commit generated `_site/` or APT indexes, and never add a deb manually. Package publishing uses Apelin's publishing tools.
- `CydiaIcon.png` is original circular arc-reactor-inspired artwork (192×192 PNG, under 100 KB); the homepage and favicon use the same file with a cache-version query. Keep the canonical filename for package managers.
- Recreate it on-device with `mkdir -p tools/.build`, then `clang -arch arm64 -fobjc-arc -O2 -Wall -Wextra tools/draw-source-icon.m -framework Foundation -framework CoreGraphics -framework ImageIO -o tools/.build/draw-source-icon`, then `ldid -Stools/Tool.entitlements tools/.build/draw-source-icon`, then `./tools/.build/draw-source-icon "${APELIN_PROJECT_ROOT:?}/CydiaIcon.png"`. Run these from the project root, always sign again after compiling, and keep the ignored binary out of commits. The helper decodes and checks PNG dimensions and size after writing.
