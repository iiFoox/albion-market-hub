# Compliance Reference — LGPD / GDPR

> **Category:** Security / Compliance
> **Usage:** Referenced by all agents for data protection compliance

---

## LGPD (Lei Geral de Proteção de Dados — Brazil)

### Key Requirements
| Requirement | Implementation |
|---|---|
| **Consent** | Explicit opt-in for data collection; record consent timestamp |
| **Purpose Limitation** | Only collect what's needed; document purpose |
| **Data Minimization** | Collect minimum necessary data |
| **Right to Access** | API to export user's personal data (JSON/CSV) |
| **Right to Deletion** | API to delete user's data (right to be forgotten) |
| **Right to Portability** | Export data in machine-readable format |
| **Data Breach Notification** | Notify ANPD within "reasonable time" + affected users |
| **DPO** | Designate a Data Protection Officer |
| **Privacy by Design** | Build privacy into the system from day one |

### Developer Checklist
- [ ] Personal data fields identified and documented
- [ ] Consent collection mechanism with timestamp
- [ ] Data export endpoint (user's own data)
- [ ] Data deletion endpoint (cascade all user data)
- [ ] Data anonymization for analytics
- [ ] Encryption for sensitive data at rest
- [ ] Access logging for personal data queries
- [ ] Privacy policy page accessible from app
- [ ] Cookie consent banner (if web)
- [ ] Data retention policy implemented (auto-delete after X days)

---

## GDPR (General Data Protection Regulation — EU)

Similar to LGPD with stricter enforcement:
- Fines up to 4% of global revenue or €20M
- 72-hour breach notification requirement
- Explicit consent for cookies and tracking
- Right to object to automated decision-making
- Data Protection Impact Assessment (DPIA) for high-risk processing

### Technical Implementation
```typescript
// Data export endpoint
app.get('/api/me/export', auth, async (req, res) => {
  const userData = await getUserDataExport(req.user.id);
  // Include ALL personal data: profile, orders, reviews, logs
  res.setHeader('Content-Disposition', 'attachment; filename=my-data.json');
  res.json(userData);
});

// Data deletion endpoint
app.delete('/api/me', auth, async (req, res) => {
  await deleteAllUserData(req.user.id);
  // Cascade: profile, orders, reviews, sessions, tokens, logs
  // Anonymize where deletion isn't possible (invoices for tax)
  res.status(204).send();
});

// Anonymization for analytics
function anonymizeUser(user: User) {
  return {
    ...user,
    email: 'anonymized@deleted.com',
    name: 'Deleted User',
    phone: null,
    address: null,
    ip: null,
  };
}
```
