## Performance Optimization

### Goal Setting
- **Load Time**: {{target_load_time}}
- **Core Web Vitals** improvement

### Resource Optimization

{{#if image_optimization}}
#### Image Optimization
- Choose appropriate image formats (WebP, AVIF)
- Use responsive images (srcset)
- Implement image compression
- Specify aspect ratios to prevent layout shift
{{/if}}

{{#if minification}}
#### CSS/JS Optimization
- File minification
- Remove unnecessary code
- Utilize tree shaking
- Inline critical CSS
{{/if}}

#### Font Optimization
- Web font subsetting
- Appropriate font-display settings
- Prioritize local fonts

### Loading Strategy

{{#if lazy_loading}}
#### Lazy Loading
- Image lazy loading (loading="lazy")
- Content loading based on scroll
- Utilize Intersection Observer
{{/if}}

#### Resource Priority
- Preload important resources with preload
- Prepare next page with prefetch
- Proper use of defer and async

### Cache Strategy
- {{cache_strategy}}
- Appropriate Cache-Control headers
- Consider Service Worker utilization
- CDN usage

### Measurement and Monitoring

#### Performance Metrics
- First Contentful Paint (FCP)
- Largest Contentful Paint (LCP)
- First Input Delay (FID)
- Cumulative Layout Shift (CLS)

#### Continuous Optimization
- Regular measurement with Lighthouse
- Real User Monitoring (RUM)
- Performance budget setting