# Fluxtruth.github.io

Personal portfolio of Philipp Tschakert, published with GitHub Pages at
<https://philipp-tschakert.de>.

A single static page, no server, no CMS, no database, no cookies, no tracking and no
requests to third parties. Fonts and images are embedded in the page.

## Structure

```
public/               everything that gets published
  index.html          the site (views are switched by URL hash, e.g. #callout)
  404.html            error page
  robots.txt, sitemap.xml, og.png
  licenses/           license texts of embedded third-party fonts
.github/
  workflows/pages.yml deploy on every push to main
  scripts/check-static.sh  fails the build if third-party requests, cookies or browser storage appear
  dependabot.yml      monthly updates of the GitHub Actions
```

## Run locally

```bash
python3 -m http.server 8000 --directory public
# open http://localhost:8000
```

## Deploy

Pushing to `main` runs the workflow, checks the site and publishes `public/`.
One-time setup in the repository: **Settings → Pages → Source: GitHub Actions**.

## Custom domain

The site runs on `philipp-tschakert.de` (file `public/CNAME`). DNS at the registrar: four A records
to GitHub Pages and a `www` CNAME to `fluxtruth.github.io`. HTTPS is enforced under Settings → Pages.
The URLs in `public/index.html` (`canonical`, `og:url`, `og:image`, `twitter:image`),
`public/robots.txt` and `public/sitemap.xml` use this domain. `og.png` shows it as text.

## Before publishing

- `LEGAL-REVIEW` comments in `public/index.html` mark the Impressum and the privacy notice.
  Have both reviewed by a lawyer, then remove the comments.

## License

All rights reserved, see [LICENSE](LICENSE). Fonts: SIL Open Font License 1.1,
see `public/licenses/OFL-Geist.txt`.
