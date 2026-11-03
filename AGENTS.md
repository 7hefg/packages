# Package repository maintenance

- Repository: `7hefg/packages`; source URL: `https://7hefg.github.io/packages/`.
- Display name: `7he`. Keep the repository name, source URL, and Release codename `packages` unchanged when updating branding.
- This workspace serves an APT repository, not a plugin build. Do not build a deb for site-only changes.
- Check shell syntax with `bash -n scripts/update-repository.sh` and review changes with the git tools.
- Full index generation uses `scripts/update-repository.sh` on Debian/Ubuntu with `apt-ftparchive`, `xz`, and optional `qrencode`. The on-device environment lacks these tools; do not install them merely for branding changes.
- A push to `main` changing the homepage or index script triggers `.github/workflows/update-repository.yml`, which builds indexes and deploys GitHub Pages. Push only when requested.
- After deployment, fetch the source homepage, `Release`, and `Packages` to verify the live title, Origin/Label, and package index. An empty Packages file is expected until a package is published.
- Never commit generated `_site/` or APT indexes, and never add a deb manually. Package publishing uses Apelin's publishing tools.
