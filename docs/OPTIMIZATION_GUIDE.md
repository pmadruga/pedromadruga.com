# Website Optimization Guide

This document describes the performance optimizations implemented for pedromadruga.com.

## Overview

The optimizations focus on four key areas:
1. **Image Optimization** - Modern formats and responsive images
2. **Font Loading** - Optimized web font delivery
3. **JavaScript** - Modular, minified, and deferred scripts
4. **SEO** - Structured data and enhanced metadata

## 1. Image Optimization

### Automatic Image Processing

All markdown images are automatically processed through a custom render hook that:
- Generates WebP and AVIF formats (25-50% size reduction)
- Creates responsive srcsets for multiple screen sizes (400px, 800px, 1200px, 1600px)
- Adds proper lazy loading with `loading="lazy"`
- Uses async decoding with `decoding="async"`
- Sets `fetchpriority="high"` for the first image (above-the-fold)
- Includes width/height attributes to prevent layout shifts (CLS optimization)

**File:** `layouts/_default/_markup/render-image.html`

### Manual Image Shortcode

For more control, use the responsive-img shortcode:

```markdown
{{< responsive-img src="my-image.jpg" alt="Description" priority="high" >}}
```

**Parameters:**
- `src` - Image filename (must be in page bundle)
- `alt` - Alt text for accessibility
- `priority` - "high" (above-fold), "low", or "auto"
- `class` - Optional CSS class

**File:** `layouts/shortcodes/responsive-img.html`

### Image Configuration

Hugo's image processing is configured in `hugo.yaml`:

```yaml
imaging:
  resampleFilter: "Lanczos"  # High-quality downscaling
  quality: 85                 # Balance between quality and size
  anchor: "Smart"             # Intelligent crop positioning
  bgColor: "#ffffff"
  hint: "photo"
```

### Best Practices

1. **Store images in page bundles** - Place images in the same directory as the markdown file
2. **Use descriptive alt text** - Required for accessibility and SEO
3. **Optimize source images** - Start with reasonable dimensions (max 2000px width)
4. **Choose right format** - AVIF for photos, WebP as fallback, original format as final fallback

## 2. Font Loading Optimization

### Preconnect

Preconnect hints reduce DNS lookup and connection time:

```html
<link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
```

### Display Swap

The `display=swap` parameter prevents FOIT (Flash of Invisible Text):

```html
<link href="https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible&display=swap" rel="stylesheet">
```

**Benefits:**
- Text visible immediately with fallback font
- Smooth transition when custom font loads
- Better perceived performance

**File:** `layouts/partials/extend_head.html`

## 3. JavaScript Optimization

### Modular Architecture

All inline JavaScript has been extracted into separate modules:

- **menu-scroll.js** - Menu position persistence
- **smooth-scroll.js** - Smooth anchor scrolling
- **scroll-to-top.js** - Back-to-top button
- **theme-toggle.js** - Dark/light mode switching
- **code-copy.js** - Code block copy functionality

### Hugo Pipes Processing

Scripts are processed through Hugo Pipes for:
- **Minification** - Removes whitespace and comments
- **Fingerprinting** - Adds content hash for cache busting
- **Deferred loading** - Scripts load after page content

```go
{{- $menuScroll := resources.Get "js/menu-scroll.js" | minify | fingerprint -}}
<script src="{{ $menuScroll.RelPermalink }}" defer></script>
```

### Benefits

- Better browser caching (fingerprinting)
- Non-blocking page load (defer attribute)
- Smaller file sizes (minification)
- Better maintainability (modular code)
- Conditional loading (only load what's needed)

**Files:**
- Source: `assets/js/*.js`
- Template: `layouts/partials/footer.html`

## 4. SEO Enhancements

### Structured Data (JSON-LD)

Four types of structured data are automatically generated:

#### Website Schema (Homepage)
```json
{
  "@type": "WebSite",
  "name": "Site name",
  "description": "...",
  "potentialAction": {
    "@type": "SearchAction"
  }
}
```

#### Blog Post Schema
```json
{
  "@type": "BlogPosting",
  "headline": "...",
  "datePublished": "...",
  "author": {...},
  "keywords": [...]
}
```

#### Breadcrumb Schema
Automatically generates navigation breadcrumbs for better SERP display.

#### OpenGraph & Twitter Cards
Enhanced social media metadata for better sharing previews.

**Files:**
- `layouts/partials/seo/schema-website.html`
- `layouts/partials/seo/schema-blog.html`
- `layouts/partials/seo/schema-breadcrumb.html`
- `layouts/partials/seo/opengraph.html`

### Meta Tags

Enhanced meta tags include:
- `description` - Page/site description
- `og:*` - OpenGraph for Facebook/LinkedIn
- `twitter:*` - Twitter Card metadata
- `article:*` - Article-specific metadata
- `canonical` - Canonical URL

## Core Web Vitals Impact

These optimizations target 2025 Core Web Vitals benchmarks:

### LCP (Largest Contentful Paint) < 2.5s
- ✅ Image optimization (WebP/AVIF)
- ✅ Responsive images with srcsets
- ✅ fetchpriority="high" for hero images
- ✅ Font preconnect and display=swap

### INP (Interaction to Next Paint) < 200ms
- ✅ Deferred JavaScript loading
- ✅ Minimal inline scripts
- ✅ Efficient event handlers

### CLS (Cumulative Layout Shift) < 0.1
- ✅ Width/height attributes on images
- ✅ Font display=swap
- ✅ No dynamically inserted content

## Testing & Validation

### Build Test
```bash
hugo --minify
```

Should complete without errors. Check `public/` for:
- Generated responsive images
- Minified JS files with fingerprints
- JSON-LD in page sources

### Local Development
```bash
hugo serve -D
```

### Performance Testing Tools

1. **Google PageSpeed Insights**
   - https://pagespeed.web.dev/
   - Tests Core Web Vitals on real devices

2. **WebPageTest**
   - https://www.webpagetest.org/
   - Detailed waterfall analysis

3. **Lighthouse** (Chrome DevTools)
   - Built into Chrome browser
   - Performance, Accessibility, SEO audits

4. **Structured Data Testing Tool**
   - https://search.google.com/test/rich-results
   - Validates JSON-LD schema

### Expected Improvements

- 40-60% reduction in page weight
- LCP under 2.5s on 4G connections
- 90+ Performance score in Lighthouse
- Valid structured data in Google's tools

## Maintenance

### Adding New JavaScript
1. Create file in `assets/js/`
2. Use IIFE pattern for encapsulation
3. Add to footer.html with minify and fingerprint
4. Use `defer` attribute

### Updating Images
- Images in markdown are automatically optimized
- No additional work needed
- First build may be slow (image processing)
- Subsequent builds use cached images

### SEO Updates
- Update `hugo.yaml` for site-wide defaults
- Add `description` to page front matter
- Add `images` array for custom OG images
- Tags automatically become keywords

## Browser Support

- **WebP:** All modern browsers (95%+ coverage)
- **AVIF:** Chrome 85+, Firefox 93+ (80%+ coverage)
- **Fallback:** Original format ensures 100% compatibility
- **JavaScript:** ES2015+ (all modern browsers)

## File Structure

```
layouts/
├── _default/
│   └── _markup/
│       └── render-image.html      # Automatic image processing
├── shortcodes/
│   └── responsive-img.html        # Manual image shortcode
└── partials/
    ├── extend_head.html           # Head enhancements
    ├── footer.html                # JS loading
    └── seo/
        ├── schema-website.html
        ├── schema-blog.html
        ├── schema-breadcrumb.html
        └── opengraph.html

assets/
└── js/
    ├── menu-scroll.js
    ├── smooth-scroll.js
    ├── scroll-to-top.js
    ├── theme-toggle.js
    └── code-copy.js

docs/
└── OPTIMIZATION_GUIDE.md          # This file
```

## Resources

- [Hugo Image Processing](https://gohugo.io/content-management/image-processing/)
- [Web Vitals](https://web.dev/vitals/)
- [Schema.org](https://schema.org/)
- [Open Graph Protocol](https://ogp.me/)

## Support

For issues or questions:
- Check Hugo documentation
- Test with `hugo --debug`
- Validate structured data with Google's tools
- Profile performance with Chrome DevTools
