# E-Commerce Specialization Profile

> **Category:** Profile / Industry-Specific
> **Usage:** Applied when project involves online retail / marketplace

---

## Activation Trigger
```
ACTIVATE WHEN:
→ Project sells products or services online
→ Project has cart, checkout, or payment flow
→ Project manages inventory or catalog
→ User mentions: e-commerce, loja, marketplace, checkout, carrinho
```

## Architecture Patterns

### Product Catalog
```typescript
// Schema design for flexible product attributes
model Product {
  id          String   @id @default(uuid())
  name        String
  slug        String   @unique
  description String
  status      ProductStatus @default(DRAFT)
  
  // Pricing
  priceInCents  Int
  compareAtPrice Int?   // Original price (for "was R$99, now R$79")
  currency      String @default("BRL")
  
  // Inventory
  trackInventory Boolean @default(true)
  quantity       Int     @default(0)
  
  // SEO
  metaTitle       String?
  metaDescription String?
  
  // Relations
  images    ProductImage[]
  variants  ProductVariant[]   // Size, color, etc.
  categories ProductCategory[]
  reviews   Review[]
  
  // Flexible attributes (JSON for variable product types)
  attributes Json?  // { "weight": "500g", "material": "cotton" }
  
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  @@index([status])
  @@index([slug])
}
```

### Cart & Checkout Flow
```
CART ARCHITECTURE:
→ Anonymous cart (stored in cookie/localStorage until login)
→ Cart merge on login (anonymous + saved cart)
→ Cart expiration (7 days inactive → clear)
→ Real-time inventory check at add-to-cart AND at checkout

CHECKOUT STEPS:
1. Cart Review → validate items, stock, prices
2. Shipping Address → validate, calculate shipping
3. Shipping Method → show options with price/ETA
4. Payment → Stripe/payment processor
5. Order Confirmation → create order, reduce inventory, send email

CRITICAL RULES:
→ NEVER trust client-side prices — always recalculate on server
→ Lock inventory at checkout start (5-minute reservation)
→ Handle payment failure gracefully (restore inventory)
→ Idempotency key on payment to prevent double charges
```

### Inventory Management
```
STRATEGIES:
→ Simple: Single quantity counter per product
→ Variants: Quantity per variant (size M = 10, L = 5)
→ Multi-warehouse: Quantity per variant per location
→ Reservation: Soft-lock inventory during checkout

EVENTS:
→ inventory.reserved (checkout started)
→ inventory.released (checkout abandoned/failed)
→ inventory.decremented (order confirmed)
→ inventory.replenished (restock)
→ inventory.low_stock (alert when below threshold)
```

## Performance Requirements

```
E-COMMERCE SPECIFIC SLAs:
→ Product page load: < 1.5s (LCP)
→ Search results: < 500ms
→ Add to cart: < 300ms (optimistic UI)
→ Checkout page: < 2s
→ Payment processing: < 5s

CACHING STRATEGY:
→ Product catalog: CDN cache (5 min TTL, invalidate on update)
→ Product page: ISR (revalidate every 60s)
→ Cart: No cache (always fresh)
→ Search: Redis cache (30s TTL)
→ User profile: Redis (5 min TTL)
```

## SEO Checklist (E-Commerce)
- [ ] Structured data (Product, BreadcrumbList, Review)
- [ ] Canonical URLs for product variants
- [ ] Sitemap with all product pages
- [ ] Image alt text with product name
- [ ] Meta title: "Product Name | Category | Store Name"
- [ ] Product page has unique description (not manufacturer copy)
- [ ] 301 redirects for deleted/renamed products
- [ ] Social sharing meta tags (og:image, og:price)
