# Favicon — davidshadle.com

Charcoal rounded square, initials knocked out in white. **Two variants are built. Pick one and delete the other.**

| Variant | Location | Typeface |
|---|---|---|
| **Uppercase DS** | this folder | Liberation Sans Bold, metric compatible with Helvetica |
| **lowercase ds** | `lowercase/` | DejaVu Sans Bold |

Compare them at real size in `favicon-uppercase-vs-lowercase.png`. Each variant also has its own `favicon-proof.png` showing 16, 32, 48 and 64 plus the 16 enlarged so you can see exactly which pixels are on.

In both variants the letterforms are **converted to vector paths**, so the icon renders identically regardless of what fonts a viewer has installed.

## Choosing

Both survive 16 pixels, which is the only test that matters. So this is a tone decision, not a legibility one.

- **Uppercase** reads more formal. Initials on a business card. Slightly more legible at the smallest size.
- **lowercase** reads warmer and more contemporary. Closer to a handle than a monogram, and closer to the reference sites in the content strategy.

Given the site is deliberately a person rather than a firm, lowercase is arguably the more consistent choice. Look at both in a real browser tab before deciding. A proof sheet and a live tab are different experiences.

**One note if you pick lowercase.** The two variants are set in different typefaces, because Liberation Sans Bold was too light at 16 pixels in lowercase and filled in. That only matters if the mark ever appears elsewhere on the site, where the uppercase version would sit more naturally alongside Helvetica-family type.

## Files, in each variant folder

| File | Size | Purpose |
|---|---|---|
| `favicon.svg` | vector | Modern browsers. Scales to any size. |
| `favicon.ico` | 16, 32, 48 | Older browsers and Windows. Each size rendered natively rather than downsampled, so the 16 stays crisp. |
| `apple-touch-icon.png` | 180 | iOS home screen. Full bleed square with no corner radius, because iOS applies its own mask. |
| `icon-192.png` | 192 | Android home screen and PWA manifest. |
| `icon-512.png` | 512 | PWA splash and app listings. |
| `favicon-inverted.svg` | vector | Light background variant. Not needed for the tab icon, useful if the mark ever appears on a dark page. |
| `favicon-proof.png` | reference | The icon at real sizes, plus the 16 enlarged. |

## Installation

Move the winning variant's files to the site root, then add to `<head>`:

```html
<link rel="icon" href="/favicon.ico" sizes="32x32">
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="/apple-touch-icon.png">
```

Three lines, in that order. The `.ico` first is deliberate: older browsers stop at the first icon they understand, and modern ones prefer the SVG.

### Static site

Put the files in whatever directory is served at the root. Confirm that `/favicon.ico` resolves directly, since some clients request that path and ignore the markup entirely.

### WordPress, if the theme is still in play

Two options.

**Through the admin,** Appearance then Customize then Site Identity, upload `icon-512.png` as the Site Icon. WordPress generates the rest. Simplest path, but you lose the SVG and the natively rendered 16.

**Through the theme,** which is better. Put the files in the theme root and add to `functions.php`:

```php
add_action('wp_head', function () {
    $u = get_template_directory_uri();
    echo '<link rel="icon" href="' . $u . '/favicon.ico" sizes="32x32">' . "\n";
    echo '<link rel="icon" href="' . $u . '/favicon.svg" type="image/svg+xml">' . "\n";
    echo '<link rel="apple-touch-icon" href="' . $u . '/apple-touch-icon.png">' . "\n";
});
```

Serving `favicon.ico` from the actual site root rather than the theme directory is still worth doing.

## Notes

**Why a filled container.** The mark has to hold its edge against both a light and a dark browser theme. Bare letterforms disappear in dark mode. The charcoal square solves both cases with one file.

**Why charcoal.** A favicon should never be the only place a brand color exists. If the site adopts an accent color later, the icon can follow. Until then, neutral is correct.

**Caching.** Browsers cache favicons aggressively and ignore normal cache headers. After deploying, hard refresh, and expect the old icon to persist in some places for a while. That is normal.

**If you ever change it.** Don't, unless the site changes with it. People find a tab by its icon, and a changed favicon reads as a different site.
